import Foundation
import Testing
import SwiftData
@testable import Moonvies

/// Pruebas de la persistencia real de "Por ver" con SwiftData, guardando en memoria
@MainActor
struct WatchlistServiceTests {

    private let container: ModelContainer

    init() {
        container = PersistenceController.makeModelContainer(inMemory: true)
    }

    private func makeService() -> WatchlistService {
        WatchlistService(context: ModelContext(container))
    }

    @Test
    func savedMovieKeepsAllItsDataAndItsDate() throws {
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
        let addedAt = Date(timeIntervalSince1970: 1_000_000)

        // Act
        try makeService().saveMovie(movie, addedAt: addedAt)

        // Assert: la fecha se guarda porque los recordatorios la necesitan
        #expect(makeService().fetchItems() == [WatchlistItem(movie: movie, addedAt: addedAt)])
    }

    @Test
    func fetchReturnsMostRecentFirst() throws {
        // Arrange
        let service = makeService()

        // Act
        try service.saveMovie(TestMovies.coco, addedAt: Date(timeIntervalSince1970: 1))
        try service.saveMovie(TestMovies.roma, addedAt: Date(timeIntervalSince1970: 2))

        // Assert
        #expect(service.fetchItems().map { $0.movie } == [TestMovies.roma, TestMovies.coco])
    }

    @Test
    func removeMovieDeletesOnlyThatMovie() throws {
        // Arrange
        let service = makeService()
        try service.saveMovie(TestMovies.coco, addedAt: Date(timeIntervalSince1970: 1))
        try service.saveMovie(TestMovies.roma, addedAt: Date(timeIntervalSince1970: 2))

        // Act
        try service.removeMovie(movieID: TestMovies.coco.id)

        // Assert
        #expect(service.fetchItems().map { $0.movie } == [TestMovies.roma])
    }
}
