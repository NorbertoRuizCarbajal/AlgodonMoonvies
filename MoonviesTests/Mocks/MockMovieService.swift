import Foundation
@testable import Moonvies

enum MockServiceError: Error {
    case loadingFailed
    case savingFailed
}

/// Reemplaza a `MovieService` en los tests: regresa las películas que le pasemos o un error
struct MockMovieService: MovieServiceProtocol {

    let moviesToReturn: [Movie]
    var error: MockServiceError? = nil

    func fetchMovies() async throws -> [Movie] {
        if let error {
            throw error
        }

        return moviesToReturn
    }
}

/// Servicio de prueba que lanza un `MovieError` concreto
struct FailingMovieService: MovieServiceProtocol {

    let error: MovieError

    func fetchMovies() async throws -> [Movie] {
        throw error
    }
}
