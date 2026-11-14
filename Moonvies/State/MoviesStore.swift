import Foundation
import Observation

/// Fuente única de verdad del catálogo
@MainActor
@Observable
final class MoviesStore {
    private(set) var state: LoadState = .idle
    private(set) var isLoadingMore = false
    /// Error al pedir más páginas; no borra las películas que ya se cargaron
    private(set) var loadMoreError: MovieError?

    private var currentPage = 0
    private var totalPages = 0

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

    var canLoadMore: Bool {
        guard case .loaded = state else { return false }
        return currentPage < totalPages
    }

    /// Controla la llamada al servicio: cargando → contenido, vacío o error
    func loadMovies() async {
        state = .loading
        loadMoreError = nil

        do {
            let page = try await movieService.fetchMovies(page: 1)
            currentPage = page.page
            totalPages = page.totalPages
            state = page.movies.isEmpty ? .empty : .loaded(page.movies)
        } catch let movieError as MovieError {
            print("Error al cargar películas:", movieError)
            state = .error(movieError)
        } catch {
            print("Error al cargar películas:", error)
            state = .error(.loadFailed)
        }
    }

    /// Busca en TMDB. No cambia el catálogo: el resultado lo guarda la pantalla Buscar
    func searchMovies(query: String) async throws -> [Movie] {
        try await movieService.searchMovies(query: query)
    }

    /// Agrega la siguiente página al final, sin repetir películas
    func loadMoreMovies() async {
        guard canLoadMore, !isLoadingMore else { return }

        isLoadingMore = true
        loadMoreError = nil
        defer { isLoadingMore = false }

        do {
            let page = try await movieService.fetchMovies(page: currentPage + 1)
            let loadedIDs = Set(movies.map { $0.id })
            let newMovies = page.movies.filter { !loadedIDs.contains($0.id) }

            currentPage = page.page
            totalPages = page.totalPages
            state = .loaded(movies + newMovies)
        } catch let movieError as MovieError {
            loadMoreError = movieError
        } catch {
            loadMoreError = .loadFailed
        }
    }
}

// MARK: - Datos para los #Preview

extension MoviesStore {
    /// Store ya cargado, para que los #Preview no tengan que esperar
    static func preview() -> MoviesStore {
        let store = MoviesStore(movieService: MovieService())
        store.state = .loaded(Movie.samples)
        return store
    }
}
