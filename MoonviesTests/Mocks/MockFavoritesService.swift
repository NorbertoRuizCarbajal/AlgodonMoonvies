import Foundation
@testable import Moonvies

/// Reemplaza a `FavoritesService` en los tests: guarda los ids en un arreglo en lugar de SwiftData
@MainActor
final class MockFavoritesService: FavoritesServiceProtocol {

    private(set) var savedIDs: [String]
    var shouldFail: Bool

    init(savedIDs: [String] = [], shouldFail: Bool = false) {
        self.savedIDs = savedIDs
        self.shouldFail = shouldFail
    }

    func fetchFavoriteIDs() -> [String] {
        savedIDs
    }

    func saveFavorite(movieID: String) throws {
        guard !shouldFail else {
            throw MockServiceError.savingFailed
        }

        savedIDs.insert(movieID, at: 0)
    }

    func removeFavorite(movieID: String) throws {
        guard !shouldFail else {
            throw MockServiceError.savingFailed
        }

        savedIDs.removeAll { $0 == movieID }
    }
}
