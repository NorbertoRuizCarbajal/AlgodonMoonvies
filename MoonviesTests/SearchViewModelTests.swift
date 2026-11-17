import Testing
@testable import Moonvies

/// Pruebas del rombo "¿Se encontraron resultados?" de la pantalla Buscar
@MainActor
struct SearchViewModelTests {

    private var popularMovies: [Movie] {
        Array(TestMovies.all.sorted { $0.rating > $1.rating }.prefix(6))
    }

    private func makeViewModel(service: any MovieServiceProtocol = MockMovieService(moviesToReturn: TestMovies.all)) async -> SearchViewModel {
        let store = MoviesStore(movieService: service)
        await store.loadMovies()

        // Sin espera para que los tests sean rápidos
        return SearchViewModel(moviesStore: store, typingDelay: .zero)
    }

    @Test
    func emptyQueryShowsSixPopularMovies() async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        viewModel.query = ""

        // Assert
        #expect(viewModel.result == .popular(popularMovies))
    }

    @Test
    func queryWithOnlySpacesShowsPopularMovies() async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        viewModel.query = "   "
        await viewModel.search()

        // Assert
        #expect(viewModel.result == .popular(popularMovies))
    }

    @Test
    func resultIsSearchingBeforeTheServiceAnswers() async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        viewModel.query = "Bajo"

        // Assert
        #expect(viewModel.result == .searching)
    }

    @Test
    func searchFindsMatchingMovies() async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        viewModel.query = "Bajo"
        await viewModel.search()

        // Assert
        #expect(viewModel.result == .found([TestMovies.faultInOurStars, TestMovies.eightBelow]))
    }

    @Test(arguments: [
        "parasitos",
        "PARÁSITOS",
        "Parasite",
        "  parásitos  "
    ])
    func searchIgnoresCaseAccentsAndSpaces(searchText: String) async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        viewModel.query = searchText
        await viewModel.search()

        // Assert
        #expect(viewModel.result == .found([TestMovies.parasite]))
    }

    @Test
    func searchWithoutMatchesReturnsNotFound() async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        viewModel.query = "Kuan"
        await viewModel.search()

        // Assert
        #expect(viewModel.result == .notFound)
    }

    @Test
    func searchShowsTheErrorWhenTheServiceFails() async {
        // Arrange: el catálogo no carga y la búsqueda tampoco
        let viewModel = await makeViewModel(service: FailingMovieService(error: .noConnection))

        // Act
        viewModel.query = "Coco"
        await viewModel.search()

        // Assert
        #expect(viewModel.result == .error(.noConnection))
    }

    @Test
    func clearSearchResetsQueryAndShowsPopularMovies() async {
        // Arrange
        let viewModel = await makeViewModel()
        viewModel.query = "Kuan"
        await viewModel.search()

        // Act
        viewModel.clearSearch()

        // Assert
        #expect(viewModel.query.isEmpty)
        #expect(viewModel.result == .popular(popularMovies))
    }

    @Test
    func loadStateShowsErrorWhenServiceFails() async {
        // Arrange
        let store = MoviesStore(movieService: FailingMovieService(error: .noConnection))
        let viewModel = SearchViewModel(moviesStore: store, typingDelay: .zero)

        // Act
        await viewModel.retryLoading()

        // Assert
        #expect(viewModel.loadState == .error(.noConnection))
    }
}
