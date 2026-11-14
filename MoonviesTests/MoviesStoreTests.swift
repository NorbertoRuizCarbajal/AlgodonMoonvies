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

    func testLoadMoviesSetsEmptyWhenServiceReturnsNoMovies() async {
        // Arrange: la consulta sale bien pero sin resultados
        let store = MoviesStore(movieService: MockMovieService(moviesToReturn: []))

        // Act
        await store.loadMovies()

        // Assert
        XCTAssertEqual(store.state, .empty)
        XCTAssertTrue(store.movies.isEmpty)
    }

    func testLoadMoviesKeepsTheSpecificErrorFromService() async {
        // Arrange: una respuesta HTTP no exitosa (401)
        let store = MoviesStore(movieService: FailingMovieService(error: .httpStatus(401)))

        // Act
        await store.loadMovies()

        // Assert
        XCTAssertEqual(store.state, .error(.httpStatus(401)))
    }

    func testLoadMoviesCanRecoverAfterAnError() async {
        // Arrange: primero falla
        let failingStore = MoviesStore(movieService: FailingMovieService(error: .noConnection))
        await failingStore.loadMovies()
        XCTAssertEqual(failingStore.state, .error(.noConnection))

        // Act: al reintentar con un servicio que sí responde, carga el contenido
        let store = MoviesStore(movieService: MockMovieService(moviesToReturn: TestMovies.all))
        await store.loadMovies()

        // Assert
        XCTAssertEqual(store.state, .loaded(TestMovies.all))
    }

    func testLoadMoreMoviesAppendsTheNextPage() async {
        // Arrange
        let store = MoviesStore(movieService: MockMovieService(pages: [[TestMovies.coco], [TestMovies.roma]]))
        await store.loadMovies()
        XCTAssertTrue(store.canLoadMore)

        // Act
        await store.loadMoreMovies()

        // Assert
        XCTAssertEqual(store.movies, [TestMovies.coco, TestMovies.roma])
        XCTAssertFalse(store.canLoadMore)
    }

    func testLoadMoreMoviesSkipsMoviesThatWereAlreadyLoaded() async {
        // Arrange: TMDB puede repetir una película entre páginas
        let pages = [[TestMovies.coco, TestMovies.roma], [TestMovies.roma, TestMovies.parasite]]
        let store = MoviesStore(movieService: MockMovieService(pages: pages))
        await store.loadMovies()

        // Act
        await store.loadMoreMovies()

        // Assert
        XCTAssertEqual(store.movies, [TestMovies.coco, TestMovies.roma, TestMovies.parasite])
    }

    func testLoadMoreMoviesKeepsTheMoviesWhenItFails() async {
        // Arrange
        let service = MockMovieService(pages: [[TestMovies.coco], [TestMovies.roma]], failingPage: 2)
        let store = MoviesStore(movieService: service)
        await store.loadMovies()

        // Act
        await store.loadMoreMovies()

        // Assert
        XCTAssertEqual(store.movies, [TestMovies.coco])
        XCTAssertEqual(store.loadMoreError, .noConnection)
        XCTAssertTrue(store.canLoadMore)
    }

    func testLoadMoreMoviesDoesNothingOnTheLastPage() async {
        // Arrange
        let store = MoviesStore(movieService: MockMovieService(moviesToReturn: [TestMovies.coco]))
        await store.loadMovies()

        // Act
        await store.loadMoreMovies()

        // Assert
        XCTAssertEqual(store.movies, [TestMovies.coco])
        XCTAssertFalse(store.canLoadMore)
    }
}
