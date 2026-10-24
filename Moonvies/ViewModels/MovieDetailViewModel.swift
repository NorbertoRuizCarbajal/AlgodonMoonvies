import Foundation
import Observation

/// Lógica del detalle de una película: favoritos, sugerencias y avisos.
/// Antes todo esto vivía dentro de `MovieDetailView`.
@Observable
class MovieDetailViewModel {
    let movie: Movie
    private(set) var message: FeedbackMessage?

    private let moviesStore: MoviesStore
    private let favoritesStore: FavoritesStore

    init(movie: Movie, moviesStore: MoviesStore, favoritesStore: FavoritesStore) {
        self.movie = movie
        self.moviesStore = moviesStore
        self.favoritesStore = favoritesStore
    }

    /// Se lee del store compartido: nunca se desincroniza con la pestaña Favoritos.
    var isFavorite: Bool {
        favoritesStore.isFavorite(movie)
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
        guard !isFavorite else {
            favoritesStore.remove(movie)
            showMessage("Eliminada de favoritos", isError: false)
            return
        }

        do {
            try favoritesStore.add(movie)
            showMessage("Agregada a favoritos", isError: false)
        } catch let favoriteError as FavoriteError {
            showMessage(favoriteError.message, isError: true)
        } catch {
            showMessage("No se pudo agregar a favoritos.", isError: true)
        }
    }

    // MARK: - Funciones que todavía no existen (por ahora, Calificar)

    func showComingSoon(_ feature: String) {
        showMessage("\(feature) estará disponible pronto", isError: false)
    }

    // MARK: - Avisos

    private func showMessage(_ text: String, isError: Bool) {
        let newMessage = FeedbackMessage(text: text, isError: isError)
        message = newMessage

        Task {
            try? await Task.sleep(for: .seconds(2.5))

            // Si mientras tanto llegó otro aviso, ese no se toca.
            guard self.message?.id == newMessage.id else { return }
            self.message = nil
        }
    }
}
