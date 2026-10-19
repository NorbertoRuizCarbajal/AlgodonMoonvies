import Foundation
import Observation

/// Fuente única de verdad del catálogo.
/// Lo carga una sola vez desde el repositorio y lo comparten Home, Buscar y Detalle.
/// Antes cada vista creaba su propio `MockMovies()`.
@Observable
class MoviesStore {
    private(set) var state: LoadState = .idle

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    /// Las películas cargadas. Mientras carga o si hubo error, regresa una lista vacía.
    var movies: [Movie] {
        switch state {
        case .loaded(let movies):
            return movies
        case .idle, .loading, .error:
            return []
        }
    }

    func loadMovies() async {
        state = .loading

        do {
            let movies = try await repository.fetchMovies()
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
    /// Store ya cargado con los datos de prueba, para que los #Preview no tengan que esperar.
    static func preview() -> MoviesStore {
        let store = MoviesStore(repository: MockMovieRepository())
        store.state = .loaded(MockMovies().all)
        return store
    }
}
