import Foundation
import SwiftData

/// Contrato para guardar los favoritos de forma permanente
/// `FavoritesStore` solo conoce este protocolo; en los tests se reemplaza por un mock
protocol FavoritesServiceProtocol {
    func fetchFavoriteIDs() -> [String]
    func saveFavorite(movieID: String) throws
    func removeFavorite(movieID: String) throws
}

/// Implementación con SwiftData: lee, guarda y borra `FavoriteMovie` en el `ModelContext`
final class FavoritesService: FavoritesServiceProtocol {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Ids guardados, del favorito más reciente al más antiguo
    func fetchFavoriteIDs() -> [String] {
        let descriptor = FetchDescriptor<FavoriteMovie>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )

        let favorites = (try? context.fetch(descriptor)) ?? []

        return favorites.map { $0.movieID }
    }

    func saveFavorite(movieID: String) throws {
        let favorite = FavoriteMovie(movieID: movieID, addedAt: Date())
        context.insert(favorite)

        try context.save()
    }

    func removeFavorite(movieID: String) throws {
        let descriptor = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate {
                $0.movieID == movieID
            }
        )

        let savedFavorites = try context.fetch(descriptor)

        for favorite in savedFavorites {
            context.delete(favorite)
        }

        try context.save()
    }
}
