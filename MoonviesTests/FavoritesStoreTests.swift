import Testing
@testable import Moonvies

/// Pruebas de las reglas de favoritos y de su guardado
@MainActor
struct FavoritesStoreTests {

    @Test
    func initLoadsSavedFavorites() {
        // Arrange
        let mockService = MockFavoritesService(savedIDs: ["coco", "roma"])

        // Act
        let store = FavoritesStore(favoritesService: mockService)

        // Assert
        #expect(store.favoriteIDs == ["coco", "roma"])
        #expect(store.isFavorite(TestMovies.coco))
    }

    @Test
    func addSavesFavoriteAndPutsItFirst() throws {
        // Arrange
        let mockService = MockFavoritesService()
        let store = FavoritesStore(favoritesService: mockService)

        // Act
        try store.add(TestMovies.coco)
        try store.add(TestMovies.roma)

        // Assert
        #expect(store.favoriteIDs == ["roma", "coco"])
        #expect(mockService.savedIDs == ["roma", "coco"])
    }

    @Test
    func addingTheSameMovieTwiceThrowsAlreadyAdded() throws {
        // Arrange
        let store = FavoritesStore(favoritesService: MockFavoritesService())
        try store.add(TestMovies.coco)

        // Act y Assert
        #expect(throws: FavoriteError.alreadyAdded) {
            try store.add(TestMovies.coco)
        }
        #expect(store.favoriteIDs == ["coco"])
    }

    @Test
    func addingMoreThanTheLimitThrowsLimitReached() throws {
        // Arrange
        let store = FavoritesStore(favoritesService: MockFavoritesService())

        for number in 1...store.maximumFavorites {
            try store.add(TestMovies.movie(id: "pelicula-\(number)", title: "Película \(number)"))
        }

        // Act y Assert
        #expect(throws: FavoriteError.limitReached) {
            try store.add(TestMovies.coco)
        }
        #expect(store.favoriteIDs.count == store.maximumFavorites)
    }

    @Test
    func addThrowsSaveFailedAndKeepsListWhenSavingFails() {
        // Arrange
        let store = FavoritesStore(favoritesService: MockFavoritesService(shouldFail: true))

        // Act y Assert
        #expect(throws: FavoriteError.saveFailed) {
            try store.add(TestMovies.coco)
        }
        #expect(store.favoriteIDs.isEmpty)
    }

    @Test
    func removeDeletesFavoriteFromListAndService() throws {
        // Arrange
        let mockService = MockFavoritesService(savedIDs: ["coco", "roma"])
        let store = FavoritesStore(favoritesService: mockService)

        // Act
        try store.remove(TestMovies.coco)

        // Assert
        #expect(store.favoriteIDs == ["roma"])
        #expect(mockService.savedIDs == ["roma"])
        #expect(!store.isFavorite(TestMovies.coco))
    }

    @Test
    func removeThrowsRemoveFailedAndKeepsListWhenServiceFails() {
        // Arrange
        let store = FavoritesStore(favoritesService: MockFavoritesService(savedIDs: ["coco"], shouldFail: true))

        // Act y Assert
        #expect(throws: FavoriteError.removeFailed) {
            try store.remove(TestMovies.coco)
        }
        #expect(store.favoriteIDs == ["coco"])
    }
}
