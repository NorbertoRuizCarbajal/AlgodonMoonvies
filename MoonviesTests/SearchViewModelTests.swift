import Testing
@testable import Moonvies

/// Pruebas del rombo "¿Se encontraron resultados?" de la pantalla Buscar
@MainActor
struct SearchViewModelTests {

    private func makeViewModel(movies: [Movie] = TestMovies.all) async -> SearchViewModel {
        let store = MoviesStore(movieService: MockMovieService(moviesToReturn: movies))
        await store.loadMovies()

        return SearchViewModel(moviesStore: store)
    }

    @Test
    func emptyQueryShowsSixPopularMovies() async {
        // Arrange
        let viewModel = await makeViewModel()
        let expectedMovies = Array(TestMovies.all.sorted { $0.rating > $1.rating }.prefix(6))

        // Act
        viewModel.query = ""

        // Assert
        #expect(viewModel.result == .popular(expectedMovies))
    }

    @Test
    func queryWithOnlySpacesShowsPopularMovies() async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        viewModel.query = "   "

        // Assert
        #expect(viewModel.result == .popular(Array(TestMovies.all.sorted { $0.rating > $1.rating }.prefix(6))))
    }

    @Test
    func queryFindsMatchingMovies() async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        viewModel.query = "Bajo"

        // Assert
        #expect(viewModel.result == .found([TestMovies.faultInOurStars, TestMovies.eightBelow]))
    }

    @Test(arguments: [
        "parasitos",
        "PARÁSITOS",
        "Parasite",
        "bong"
    ])
    func searchIgnoresCaseAndAccentsAndChecksOriginalTitleAndDirector(searchText: String) async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        viewModel.query = searchText

        // Assert
        #expect(viewModel.result == .found([TestMovies.parasite]))
    }

    @Test
    func queryWithoutMatchesReturnsNotFound() async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        viewModel.query = "Kuan"

        // Assert
        #expect(viewModel.result == .notFound)
    }

    @Test
    func clearSearchResetsQueryAndShowsPopularMovies() async {
        // Arrange
        let viewModel = await makeViewModel()
        viewModel.query = "Kuan"

        // Act
        viewModel.clearSearch()

        // Assert
        #expect(viewModel.query.isEmpty)
        #expect(viewModel.result == .popular(Array(TestMovies.all.sorted { $0.rating > $1.rating }.prefix(6))))
    }
}
