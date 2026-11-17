import Foundation
@testable import Moonvies

/// Reemplaza a `WatchlistService` en los tests: guarda las películas en un arreglo
@MainActor
final class MockWatchlistService: WatchlistServiceProtocol {

    private(set) var savedItems: [WatchlistItem]
    var shouldFail: Bool

    /// Películas guardadas hoy
    init(savedMovies: [Movie] = [], shouldFail: Bool = false) {
        self.savedItems = savedMovies.map { WatchlistItem(movie: $0, addedAt: Date()) }
        self.shouldFail = shouldFail
    }

    /// Películas guardadas en fechas concretas (para probar los recordatorios)
    init(savedItems: [WatchlistItem]) {
        self.savedItems = savedItems
        self.shouldFail = false
    }

    var savedMovies: [Movie] {
        savedItems.map { $0.movie }
    }

    func fetchItems() -> [WatchlistItem] {
        savedItems
    }

    func saveMovie(_ movie: Movie, addedAt: Date) throws {
        guard !shouldFail else {
            throw MockServiceError.savingFailed
        }

        savedItems.insert(WatchlistItem(movie: movie, addedAt: addedAt), at: 0)
    }

    func removeMovie(movieID: String) throws {
        guard !shouldFail else {
            throw MockServiceError.savingFailed
        }

        savedItems.removeAll { $0.movie.id == movieID }
    }
}
