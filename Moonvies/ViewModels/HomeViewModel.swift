import Foundation
import Observation

/// Prepara los datos que muestra Home.
/// Antes esta lógica estaba repartida en `RecommendedTabView` y `FavoritesTabView`.
@Observable
class HomeViewModel {
    private let moviesStore: MoviesStore
    private let favoritesStore: FavoritesStore

    init(moviesStore: MoviesStore, favoritesStore: FavoritesStore) {
        self.moviesStore = moviesStore
        self.favoritesStore = favoritesStore
    }

    var loadState: LoadState {
        moviesStore.state
    }

    /// "Mejor valorada hoy": rota cada día entre las 5 mejor calificadas.
    var bestRatedToday: Movie? {
        let topMovies = Array(moviesSortedByRating.prefix(5))
        guard !topMovies.isEmpty else { return nil }

        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return topMovies[dayOfYear % topMovies.count]
    }

    var weeklyTop: [Movie] {
        Array(moviesSortedByRating.prefix(8))
    }

    /// Convierte los identificadores guardados en películas, respetando su orden.
    var favoriteMovies: [Movie] {
        var result: [Movie] = []

        for id in favoritesStore.favoriteIDs {
            guard let movie = moviesStore.movie(withID: id) else {
                continue
            }
            result.append(movie)
        }

        return result
    }

    func retryLoading() async {
        await moviesStore.loadMovies()
    }

    private var moviesSortedByRating: [Movie] {
        moviesStore.movies.sorted { $0.rating > $1.rating }
    }
}
