import Foundation
import Observation

/// Fuente única de verdad del catálogo
@MainActor
@Observable
final class MoviesStore {
    private(set) var state: LoadState = .idle

    private let movieService: any MovieServiceProtocol

    init(movieService: any MovieServiceProtocol) {
        self.movieService = movieService
    }

    /// Películas cargadas (vacío si no hay contenido)
    var movies: [Movie] {
        switch state {
        case .loaded(let movies):
            return movies
        case .idle, .loading, .empty, .error:
            return []
        }
    }

    /// Controla la llamada al servicio: cargando → contenido, vacío o error
    func loadMovies() async {
        state = .loading

        do {
            let movies = try await movieService.fetchMovies()
            state = movies.isEmpty ? .empty : .loaded(movies)
        } catch let movieError as MovieError {
            print("Error al cargar películas:", movieError)
            state = .error(movieError)
        } catch {
            print("Error al cargar películas:", error)
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
