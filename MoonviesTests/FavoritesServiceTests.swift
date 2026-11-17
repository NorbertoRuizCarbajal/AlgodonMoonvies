import Testing
import SwiftData
@testable import Moonvies

/// Pruebas de la persistencia real con SwiftData, guardando en memoria
@MainActor
struct FavoritesServiceTests {

    private let container: ModelContainer

    /// Cada test recibe un contenedor nuevo y vacío
    init() {
        container = PersistenceController.makeModelContainer(inMemory: true)
    }

    private func makeService() -> FavoritesService {
        FavoritesService(context: ModelContext(container))
    }

    @Test
    func fetchReturnsEmptyListWhenNothingWasSaved() {
        // Arrange
        let service = makeService()

        // Act
        let savedMovies = service.fetchMovies()

        // Assert
        #expect(savedMovies.isEmpty)
    }

    @Test
    func savedFavoriteKeepsAllItsData() throws {
        // Arrange
        let movie = Movie(
            id: "7",
            title: "Coco",
            originalTitle: "Coco",
            year: "2017",
            releaseDate: "2017-10-27",
            rating: 4.1,
            synopsis: "Sinopsis",
            posterPath: "/coco.jpg"
        )

        // Act
        try makeService().saveFavorite(movie)

        // Assert
        #expect(makeService().fetchMovies() == [movie])
    }

    @Test
    func fetchReturnsMostRecentFavoriteFirst() throws {
        // Arrange
        let service = makeService()

        // Act
        try service.saveFavorite(TestMovies.coco)
        try service.saveFavorite(TestMovies.roma)

        // Assert
        #expect(service.fetchMovies() == [TestMovies.roma, TestMovies.coco])
    }

    @Test
    func removeFavoriteDeletesOnlyThatMovie() throws {
        // Arrange
        let service = makeService()
        try service.saveFavorite(TestMovies.coco)
        try service.saveFavorite(TestMovies.roma)

        // Act
        try service.removeFavorite(movieID: TestMovies.coco.id)

        // Assert
        #expect(service.fetchMovies() == [TestMovies.roma])
    }
}
