import Foundation
import Observation

/// Prepara los datos que muestra Home
@MainActor
@Observable
final class HomeViewModel {
    private let moviesStore: MoviesStore
    private let favoritesStore: FavoritesStore
    private let watchlistStore: WatchlistStore

    init(moviesStore: MoviesStore, favoritesStore: FavoritesStore, watchlistStore: WatchlistStore) {
        self.moviesStore = moviesStore
        self.favoritesStore = favoritesStore
        self.watchlistStore = watchlistStore
    }

    var loadState: LoadState {
        moviesStore.state
    }

    /// "Mejor valorada hoy": rota cada día entre las 5 mejor calificadas
    var bestRatedToday: Movie? {
        let topMovies = Array(moviesSortedByRating.prefix(5))
        guard !topMovies.isEmpty else { return nil }

        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return topMovies[dayOfYear % topMovies.count]
    }

    var weeklyTop: [Movie] {
        Array(moviesSortedByRating.prefix(8))
    }

    /// Pestaña "Todo": el catálogo completo en el orden de TMDB
    var allMovies: [Movie] {
        moviesStore.movies
    }

    var watchlistMovies: [Movie] {
        watchlistStore.movies
    }

    var favoriteMovies: [Movie] {
        favoritesStore.movies
    }

    /// Número que aparece en la campana de notificaciones
    var remindersCount: Int {
        watchlistStore.reminders(today: Date()).count
    }

    var canLoadMore: Bool {
        moviesStore.canLoadMore
    }

    var isLoadingMore: Bool {
        moviesStore.isLoadingMore
    }

    var loadMoreError: MovieError? {
        moviesStore.loadMoreError
    }

    func retryLoading() async {
        await moviesStore.loadMovies()
    }

    func loadMore() async {
        await moviesStore.loadMoreMovies()
    }

    private var moviesSortedByRating: [Movie] {
        moviesStore.movies.sorted { $0.rating > $1.rating }
    }
}
