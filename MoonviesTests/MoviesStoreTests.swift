import XCTest
@testable import Moonvies

/// Pruebas de la carga del catálogo (control de la llamada al servicio)
@MainActor
final class MoviesStoreTests: XCTestCase {

    func testStateIsIdleBeforeLoading() {
        // Arrange
        let mockService = MockMovieService(moviesToReturn: TestMovies.all)

        // Act
        let store = MoviesStore(movieService: mockService)

        // Assert
        XCTAssertEqual(store.state, .idle)
        XCTAssertTrue(store.movies.isEmpty)
    }

    func testLoadMoviesLoadsMoviesFromService() async {
        // Arrange: preparar los datos
        let expectedMovies = [TestMovies.interstellar, TestMovies.inception]
        let mockService = MockMovieService(moviesToReturn: expectedMovies)
        let store = MoviesStore(movieService: mockService)

        // Act: ejecutar la función
        await store.loadMovies()

        // Assert: comprobar el resultado
        XCTAssertEqual(store.state, .loaded(expectedMovies))
        XCTAssertEqual(store.movies, expectedMovies)
        XCTAssertEqual(store.movies.count, 2)
    }

    func testLoadMoviesSetsErrorWhenServiceFails() async {
        // Arrange
        let mockService = MockMovieService(moviesToReturn: [], error: .loadingFailed)
        let store = MoviesStore(movieService: mockService)

        // Act
        await store.loadMovies()

        // Assert
        XCTAssertEqual(store.state, .error(.loadFailed))
        XCTAssertTrue(store.movies.isEmpty)
    }

    func testMovieWithIDFindsMovie() async {
        // Arrange
        let store = MoviesStore(movieService: MockMovieService(moviesToReturn: TestMovies.all))
        await store.loadMovies()

        // Act
        let movie = store.movie(withID: "coco")

        // Assert
        XCTAssertEqual(movie, TestMovies.coco)
    }

    func testMovieWithIDReturnsNilWhenItDoesNotExist() async {
        // Arrange
        let store = MoviesStore(movieService: MockMovieService(moviesToReturn: TestMovies.all))
        await store.loadMovies()

        // Act
        let movie = store.movie(withID: "no-existe")

        // Assert
        XCTAssertNil(movie)
    }
}
