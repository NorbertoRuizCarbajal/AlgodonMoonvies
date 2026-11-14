import Foundation
@testable import Moonvies

enum MockServiceError: Error {
    case loadingFailed
    case savingFailed
}

/// Reemplaza a `MovieService` en los tests: regresa las páginas que le pasemos o un error
struct MockMovieService: MovieServiceProtocol {

    let pages: [[Movie]]
    var error: MockServiceError?
    /// Número de página que falla con `MovieError.noConnection`
    var failingPage: Int?

    init(moviesToReturn: [Movie], error: MockServiceError? = nil) {
        self.pages = [moviesToReturn]
        self.error = error
        self.failingPage = nil
    }

    init(pages: [[Movie]], failingPage: Int? = nil) {
        self.pages = pages
        self.error = nil
        self.failingPage = failingPage
    }

    func fetchMovies(page: Int) async throws -> MoviesPage {
        if let error {
            throw error
        }
        if page == failingPage {
            throw MovieError.noConnection
        }

        let index = page - 1
        let movies = pages.indices.contains(index) ? pages[index] : []

        return MoviesPage(movies: movies, page: page, totalPages: pages.count)
    }

    /// Simula `GET /3/search/movie`: busca en todas sus páginas sin importar mayúsculas ni acentos
    func searchMovies(query: String) async throws -> [Movie] {
        if let error {
            throw error
        }

        let allMovies = pages.flatMap { $0 }

        return allMovies.filter {
            $0.title.localizedStandardContains(query) || $0.originalTitle.localizedStandardContains(query)
        }
    }
}

/// Servicio de prueba que lanza un `MovieError` concreto
struct FailingMovieService: MovieServiceProtocol {

    let error: MovieError

    func fetchMovies(page: Int) async throws -> MoviesPage {
        throw error
    }

    func searchMovies(query: String) async throws -> [Movie] {
        throw error
    }
}
