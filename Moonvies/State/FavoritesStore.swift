import Foundation
import Observation

/// Fuente única de verdad de los favoritos.
/// Es `class` (reference semantics) porque Home y Detalle deben ver la MISMA lista:
/// lo que agregas en el detalle aparece de inmediato en la pestaña Favoritos.
@Observable
class FavoritesStore {
    /// Identificadores de las películas, del favorito más reciente al más antiguo.
    private(set) var favoriteIDs: [String] = []

    private let maximumFavorites = 20

    func isFavorite(_ movie: Movie) -> Bool {
        favoriteIDs.contains(movie.id)
    }

    func add(_ movie: Movie) throws {
        guard !isFavorite(movie) else {
            throw FavoriteError.alreadyAdded
        }
        guard favoriteIDs.count < maximumFavorites else {
            throw FavoriteError.limitReached
        }

        favoriteIDs.insert(movie.id, at: 0)
    }

    func remove(_ movie: Movie) {
        favoriteIDs.removeAll { $0 == movie.id }
    }
}
