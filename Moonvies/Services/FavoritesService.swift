import Foundation
import SwiftData

/// Contrato para guardar los favoritos de forma permanente
/// `FavoritesStore` solo conoce este protocolo; en los tests se reemplaza por un mock
protocol FavoritesServiceProtocol {
    func fetchMovies() -> [Movie]
    func saveFavorite(_ movie: Movie) throws
    func removeFavorite(movieID: String) throws
}

/// Implementación con SwiftData: lee, guarda y borra `FavoriteMovie` en el `ModelContext`
final class FavoritesService: FavoritesServiceProtocol {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Del favorito más reciente al más antiguo
    func fetchMovies() -> [Movie] {
        let descriptor = FetchDescriptor<FavoriteMovie>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )

        let favorites = (try? context.fetch(descriptor)) ?? []

        // Los favoritos del esquema anterior no tienen título y no se pueden mostrar
        return favorites.filter { !$0.title.isEmpty }.map { $0.movie }
    }

    func saveFavorite(_ movie: Movie) throws {
        context.insert(FavoriteMovie(movie: movie, addedAt: Date()))

        try context.save()
    }

    func removeFavorite(movieID: String) throws {
        let descriptor = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate {
                $0.movieID == movieID
            }
        )

        for favorite in try context.fetch(descriptor) {
            context.delete(favorite)
        }

        try context.save()
    }
}
