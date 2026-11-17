import Foundation
@testable import Moonvies

/// Reemplaza a `FavoritesService` en los tests: guarda las películas en un arreglo en lugar de SwiftData
@MainActor
final class MockFavoritesService: FavoritesServiceProtocol {

    private(set) var savedMovies: [Movie]
    var shouldFail: Bool

    init(savedMovies: [Movie] = [], shouldFail: Bool = false) {
        self.savedMovies = savedMovies
        self.shouldFail = shouldFail
    }

    func fetchMovies() -> [Movie] {
        savedMovies
    }

    func saveFavorite(_ movie: Movie) throws {
        guard !shouldFail else {
            throw MockServiceError.savingFailed
        }

        savedMovies.insert(movie, at: 0)
    }

    func removeFavorite(movieID: String) throws {
        guard !shouldFail else {
            throw MockServiceError.savingFailed
        }

        savedMovies.removeAll { $0.id == movieID }
    }
}
