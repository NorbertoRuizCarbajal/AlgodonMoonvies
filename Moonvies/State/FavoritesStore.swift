import Foundation
import SwiftData
import Observation

/// Fuente única de verdad de los favoritos
/// Es `class` (reference semantics) porque Home y Detalle deben ver la MISMA lista
/// Al crearse carga los favoritos guardados y cada cambio se guarda con `favoritesService`
@MainActor
@Observable
final class FavoritesStore {
    /// Del favorito más reciente al más antiguo
    private(set) var movies: [Movie]

    let maximumFavorites = 20

    private let favoritesService: any FavoritesServiceProtocol

    init(favoritesService: any FavoritesServiceProtocol) {
        self.favoritesService = favoritesService
        self.movies = favoritesService.fetchMovies()
    }

    func isFavorite(_ movie: Movie) -> Bool {
        movies.contains { $0.id == movie.id }
    }

    /// Primero se guarda en el dispositivo y solo si funcionó se actualiza la lista
    func add(_ movie: Movie) throws {
        guard !isFavorite(movie) else {
            throw FavoriteError.alreadyAdded
        }
        guard movies.count < maximumFavorites else {
            throw FavoriteError.limitReached
        }

        do {
            try favoritesService.saveFavorite(movie)
        } catch {
            throw FavoriteError.saveFailed
        }

        movies.insert(movie, at: 0)
    }

    func remove(_ movie: Movie) throws {
        do {
            try favoritesService.removeFavorite(movieID: movie.id)
        } catch {
            throw FavoriteError.removeFailed
        }

        movies.removeAll { $0.id == movie.id }
    }
}

// MARK: - Datos para los #Preview

extension FavoritesStore {
    /// Store con SwiftData en memoria, para que los #Preview no toquen los favoritos reales
    static func preview() -> FavoritesStore {
        let container = PersistenceController.makeModelContainer(inMemory: true)
        let service = FavoritesService(context: ModelContext(container))

        return FavoritesStore(favoritesService: service)
    }
}
