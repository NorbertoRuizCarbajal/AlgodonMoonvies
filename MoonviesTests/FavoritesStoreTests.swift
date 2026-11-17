import Testing
@testable import Moonvies

/// Pruebas de las reglas de favoritos y de su guardado
@MainActor
struct FavoritesStoreTests {

    @Test
    func initLoadsSavedFavorites() {
        // Arrange
        let mockService = MockFavoritesService(savedMovies: [TestMovies.coco, TestMovies.roma])

        // Act
        let store = FavoritesStore(favoritesService: mockService)

        // Assert
        #expect(store.movies == [TestMovies.coco, TestMovies.roma])
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
        #expect(store.movies == [TestMovies.roma, TestMovies.coco])
        #expect(mockService.savedMovies == [TestMovies.roma, TestMovies.coco])
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
        #expect(store.movies == [TestMovies.coco])
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
        #expect(store.movies.count == store.maximumFavorites)
    }

    @Test
    func addThrowsSaveFailedAndKeepsListWhenSavingFails() {
        // Arrange
        let store = FavoritesStore(favoritesService: MockFavoritesService(shouldFail: true))

        // Act y Assert
        #expect(throws: FavoriteError.saveFailed) {
            try store.add(TestMovies.coco)
        }
        #expect(store.movies.isEmpty)
    }

    @Test
    func removeDeletesFavoriteFromListAndService() throws {
        // Arrange
        let mockService = MockFavoritesService(savedMovies: [TestMovies.coco, TestMovies.roma])
        let store = FavoritesStore(favoritesService: mockService)

        // Act
        try store.remove(TestMovies.coco)

        // Assert
        #expect(store.movies == [TestMovies.roma])
        #expect(mockService.savedMovies == [TestMovies.roma])
        #expect(!store.isFavorite(TestMovies.coco))
    }

    @Test
    func removeThrowsRemoveFailedAndKeepsListWhenServiceFails() {
        // Arrange
        let store = FavoritesStore(favoritesService: MockFavoritesService(savedMovies: [TestMovies.coco], shouldFail: true))

        // Act y Assert
        #expect(throws: FavoriteError.removeFailed) {
            try store.remove(TestMovies.coco)
        }
        #expect(store.movies == [TestMovies.coco])
    }
}
