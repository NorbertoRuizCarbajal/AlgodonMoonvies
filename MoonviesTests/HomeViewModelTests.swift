import Testing
@testable import Moonvies

/// Pruebas de los datos que prepara Home
@MainActor
struct HomeViewModelTests {

    private func makeViewModel(
        movies: [Movie] = TestMovies.all,
        savedFavoriteIDs: [String] = []
    ) async -> HomeViewModel {
        let moviesStore = MoviesStore(movieService: MockMovieService(moviesToReturn: movies))
        await moviesStore.loadMovies()

        let favoritesStore = FavoritesStore(favoritesService: MockFavoritesService(savedIDs: savedFavoriteIDs))

        return HomeViewModel(moviesStore: moviesStore, favoritesStore: favoritesStore)
    }

    @Test
    func weeklyTopIsSortedByRatingAndHasMaximumEightMovies() async {
        // Arrange
        let extraMovie = TestMovies.movie(id: "extra", title: "Extra", rating: 1.0)
        let viewModel = await makeViewModel(movies: TestMovies.all + [extraMovie])

        // Act
        let weeklyTop = viewModel.weeklyTop

        // Assert
        #expect(weeklyTop.count == 8)
        #expect(weeklyTop.first == TestMovies.parasite)
        #expect(!weeklyTop.contains(extraMovie))
    }

    @Test
    func bestRatedTodayIsOneOfTheTopFiveMovies() async throws {
        // Arrange
        let viewModel = await makeViewModel()
        let topFive = Array(TestMovies.all.sorted { $0.rating > $1.rating }.prefix(5))

        // Act
        let bestRatedToday = try #require(viewModel.bestRatedToday)

        // Assert
        #expect(topFive.contains(bestRatedToday))
    }

    @Test
    func favoriteMoviesKeepTheSavedOrder() async {
        // Arrange
        let viewModel = await makeViewModel(savedFavoriteIDs: ["coco", "parasitos"])

        // Act
        let favorites = viewModel.favoriteMovies

        // Assert
        #expect(favorites == [TestMovies.coco, TestMovies.parasite])
    }

    @Test
    func favoriteMoviesIgnoreIDsThatAreNotInTheCatalog() async {
        // Arrange
        let viewModel = await makeViewModel(savedFavoriteIDs: ["no-existe", "coco"])

        // Act
        let favorites = viewModel.favoriteMovies

        // Assert
        #expect(favorites == [TestMovies.coco])
    }

    @Test
    func loadStateShowsErrorWhenServiceFails() async {
        // Arrange
        let moviesStore = MoviesStore(movieService: MockMovieService(moviesToReturn: [], error: .loadingFailed))
        let favoritesStore = FavoritesStore(favoritesService: MockFavoritesService())
        let viewModel = HomeViewModel(moviesStore: moviesStore, favoritesStore: favoritesStore)

        // Act
        await viewModel.retryLoading()

        // Assert
        #expect(viewModel.loadState == .error(.loadFailed))
        #expect(viewModel.bestRatedToday == nil)
        #expect(viewModel.weeklyTop.isEmpty)
    }
}
