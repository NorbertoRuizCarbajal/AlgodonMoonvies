import Foundation
import Observation

/// Fuente única de verdad del catálogo
/// Lo carga una sola vez desde el servicio y lo comparten Home, Buscar y Detalle
@MainActor
@Observable
final class MoviesStore {
    private(set) var state: LoadState = .idle

    private let movieService: any MovieServiceProtocol

    init(movieService: any MovieServiceProtocol) {
        self.movieService = movieService
    }

    /// Las películas cargadas. Mientras carga o si hubo error, regresa una lista vacía
    var movies: [Movie] {
        switch state {
        case .loaded(let movies):
            return movies
        case .idle, .loading, .error:
            return []
        }
    }

    /// Controla la llamada al servicio: cargando → éxito o error
    func loadMovies() async {
        state = .loading

        do {
            let movies = try await movieService.fetchMovies()
            state = .loaded(movies)
        } catch {
            state = .error(.loadFailed)
        }
    }

    func movie(withID id: String) -> Movie? {
        movies.first { $0.id == id }
    }
}

// MARK: - Datos para los #Preview

extension MoviesStore {
    /// Store ya cargado con los datos de prueba, para que los #Preview no tengan que esperar
    static func preview() -> MoviesStore {
        let store = MoviesStore(movieService: MovieService())
        store.state = .loaded(MockMovies().all)
        return store
    }
}
