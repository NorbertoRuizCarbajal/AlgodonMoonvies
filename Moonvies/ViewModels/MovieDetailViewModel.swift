import Foundation
import Observation

/// Lógica del detalle de una película: favoritos, Por ver, sugerencias y avisos
@MainActor
@Observable
final class MovieDetailViewModel {
    let movie: Movie
    private(set) var message: FeedbackMessage?

    private let moviesStore: MoviesStore
    private let favoritesStore: FavoritesStore
    private let watchlistStore: WatchlistStore

    init(movie: Movie, moviesStore: MoviesStore, favoritesStore: FavoritesStore, watchlistStore: WatchlistStore) {
        self.movie = movie
        self.moviesStore = moviesStore
        self.favoritesStore = favoritesStore
        self.watchlistStore = watchlistStore
    }

    /// Se lee del store compartido: nunca se desincroniza con la pestaña Favoritos
    var isFavorite: Bool {
        favoritesStore.isFavorite(movie)
    }

    var isInWatchlist: Bool {
        watchlistStore.contains(movie)
    }

    var suggestions: [Movie] {
        let otherMovies = moviesStore.movies.filter { $0.id != movie.id }
        return Array(otherMovies.sorted { $0.rating > $1.rating }.prefix(6))
    }

    // MARK: - Favoritos (sub-flujo del diagrama)

    /// Tocar "Agregar a favoritos" → ¿Se agregó?
    ///   Sí → corazón rojo + "Agregada a favoritos"
    ///   No → mensaje de error
    func toggleFavorite() {
        do {
            guard !isFavorite else {
                try favoritesStore.remove(movie)
                showMessage("Eliminada de favoritos", isError: false)
                return
            }

            try favoritesStore.add(movie)
            showMessage("Agregada a favoritos", isError: false)
        } catch let favoriteError as FavoriteError {
            showMessage(favoriteError.message, isError: true)
        } catch {
            showMessage("No se pudo agregar a favoritos.", isError: true)
        }
    }

    // MARK: - Por ver

    func toggleWatchlist() {
        do {
            guard !isInWatchlist else {
                try watchlistStore.remove(movie)
                showMessage("Quitada de Por ver", isError: false)
                return
            }

            try watchlistStore.add(movie)
            showMessage("Agregada a Por ver. Te la recordaremos en 2 semanas", isError: false)
        } catch let watchlistError as WatchlistError {
            showMessage(watchlistError.message, isError: true)
        } catch {
            showMessage("No se pudo actualizar Por ver.", isError: true)
        }
    }

    // MARK: - Avisos

    private func showMessage(_ text: String, isError: Bool) {
        let newMessage = FeedbackMessage(text: text, isError: isError)
        message = newMessage

        Task {
            try? await Task.sleep(for: .seconds(2.5))

            // Si mientras tanto llegó otro aviso, ese no se toca
            guard self.message?.id == newMessage.id else { return }
            self.message = nil
        }
    }
}
