import Testing
@testable import Moonvies

/// Pruebas de los datos que prepara Home
@MainActor
struct HomeViewModelTests {

    private func makeViewModel(
        movies: [Movie] = TestMovies.all,
        favorites: [Movie] = [],
        watchlist: [Movie] = []
    ) async -> HomeViewModel {
        let moviesStore = MoviesStore(movieService: MockMovieService(moviesToReturn: movies))
        await moviesStore.loadMovies()

        let favoritesStore = FavoritesStore(favoritesService: MockFavoritesService(savedMovies: favorites))
        let watchlistStore = WatchlistStore(watchlistService: MockWatchlistService(savedMovies: watchlist), notificationService: MockNotificationService())

        return HomeViewModel(moviesStore: moviesStore, favoritesStore: favoritesStore, watchlistStore: watchlistStore)
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
        let viewModel = await makeViewModel(favorites: [TestMovies.coco, TestMovies.parasite])

        // Act
        let favorites = viewModel.favoriteMovies

        // Assert
        #expect(favorites == [TestMovies.coco, TestMovies.parasite])
    }

    @Test
    func favoriteMoviesDoNotDependOnTheCatalog() async {
        // Arrange: el catálogo cambia cada día, pero el favorito se conserva
        let viewModel = await makeViewModel(movies: [TestMovies.roma], favorites: [TestMovies.coco])

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
        let watchlistStore = WatchlistStore(watchlistService: MockWatchlistService(), notificationService: MockNotificationService())
        let viewModel = HomeViewModel(moviesStore: moviesStore, favoritesStore: favoritesStore, watchlistStore: watchlistStore)

        // Act
        await viewModel.retryLoading()

        // Assert
        #expect(viewModel.loadState == .error(.loadFailed))
        #expect(viewModel.bestRatedToday == nil)
        #expect(viewModel.weeklyTop.isEmpty)
    }

    @Test
    func allMoviesReturnsTheWholeCatalogInServiceOrder() async {
        // Arrange
        let viewModel = await makeViewModel()

        // Act
        let allMovies = viewModel.allMovies

        // Assert
        #expect(allMovies == TestMovies.all)
    }

    @Test
    func watchlistMoviesComeFromTheSavedList() async {
        // Arrange: Por ver no depende del catálogo cargado
        let viewModel = await makeViewModel(movies: [], watchlist: [TestMovies.roma])

        // Act
        let watchlist = viewModel.watchlistMovies

        // Assert
        #expect(watchlist == [TestMovies.roma])
    }

    @Test
    func loadMoreAddsTheNextPageToAllMovies() async {
        // Arrange
        let service = MockMovieService(pages: [[TestMovies.coco], [TestMovies.roma]])
        let moviesStore = MoviesStore(movieService: service)
        let viewModel = HomeViewModel(
            moviesStore: moviesStore,
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService()),
            watchlistStore: WatchlistStore(watchlistService: MockWatchlistService(), notificationService: MockNotificationService())
        )
        await moviesStore.loadMovies()

        // Act
        await viewModel.loadMore()

        // Assert
        #expect(viewModel.allMovies == [TestMovies.coco, TestMovies.roma])
        #expect(!viewModel.canLoadMore)
    }
}
