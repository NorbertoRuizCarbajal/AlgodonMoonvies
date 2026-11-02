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
        let savedIDs = service.fetchFavoriteIDs()

        // Assert
        #expect(savedIDs.isEmpty)
    }

    @Test
    func saveFavoriteStoresTheMovieID() throws {
        // Arrange
        let service = makeService()

        // Act
        try service.saveFavorite(movieID: "coco")

        // Assert
        #expect(service.fetchFavoriteIDs() == ["coco"])
    }

    @Test
    func fetchReturnsMostRecentFavoriteFirst() throws {
        // Arrange
        let service = makeService()

        // Act
        try service.saveFavorite(movieID: "coco")
        try service.saveFavorite(movieID: "roma")

        // Assert
        #expect(service.fetchFavoriteIDs() == ["roma", "coco"])
    }

    @Test
    func removeFavoriteDeletesOnlyThatMovie() throws {
        // Arrange
        let service = makeService()
        try service.saveFavorite(movieID: "coco")
        try service.saveFavorite(movieID: "roma")

        // Act
        try service.removeFavorite(movieID: "coco")

        // Assert
        #expect(service.fetchFavoriteIDs() == ["roma"])
    }

    @Test
    func favoritesAreStillThereWithANewContext() throws {
        // Arrange: simula cerrar y volver a abrir la app con la misma base de datos
        try makeService().saveFavorite(movieID: "coco")

        // Act
        let savedIDs = makeService().fetchFavoriteIDs()

        // Assert
        #expect(savedIDs == ["coco"])
    }
}
