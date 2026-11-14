import Testing
@testable import Moonvies

/// Pruebas del sub-flujo "Agregar a favoritos" y de los datos del detalle
@MainActor
struct MovieDetailViewModelTests {

    private func makeLoadedMoviesStore() async -> MoviesStore {
        let store = MoviesStore(movieService: MockMovieService(moviesToReturn: TestMovies.all))
        await store.loadMovies()

        return store
    }

    @Test
    func toggleFavoriteAddsMovieAndShowsConfirmation() async {
        // Arrange
        let favoritesStore = FavoritesStore(favoritesService: MockFavoritesService())
        let viewModel = MovieDetailViewModel(
            movie: TestMovies.coco,
            moviesStore: await makeLoadedMoviesStore(),
            favoritesStore: favoritesStore,
            watchlistStore: WatchlistStore(watchlistService: MockWatchlistService(), notificationService: MockNotificationService())
        )

        // Act
        viewModel.toggleFavorite()

        // Assert
        #expect(viewModel.isFavorite)
        #expect(viewModel.message?.text == "Agregada a favoritos")
        #expect(viewModel.message?.isError == false)
    }

    @Test
    func toggleFavoriteTwiceRemovesMovie() async {
        // Arrange
        let viewModel = MovieDetailViewModel(
            movie: TestMovies.coco,
            moviesStore: await makeLoadedMoviesStore(),
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService()),
            watchlistStore: WatchlistStore(watchlistService: MockWatchlistService(), notificationService: MockNotificationService())
        )

        // Act
        viewModel.toggleFavorite()
        viewModel.toggleFavorite()

        // Assert
        #expect(!viewModel.isFavorite)
        #expect(viewModel.message?.text == "Eliminada de favoritos")
    }

    @Test
    func toggleFavoriteShowsErrorWhenSavingFails() async {
        // Arrange
        let viewModel = MovieDetailViewModel(
            movie: TestMovies.coco,
            moviesStore: await makeLoadedMoviesStore(),
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService(shouldFail: true)),
            watchlistStore: WatchlistStore(watchlistService: MockWatchlistService(), notificationService: MockNotificationService())
        )

        // Act
        viewModel.toggleFavorite()

        // Assert
        #expect(!viewModel.isFavorite)
        #expect(viewModel.message?.text == FavoriteError.saveFailed.message)
        #expect(viewModel.message?.isError == true)
    }

    @Test
    func favoriteAddedInDetailAppearsInHome() async {
        // Arrange: Home y Detalle comparten el mismo store
        let moviesStore = await makeLoadedMoviesStore()
        let favoritesStore = FavoritesStore(favoritesService: MockFavoritesService())
        let watchlistStore = WatchlistStore(watchlistService: MockWatchlistService(), notificationService: MockNotificationService())
        let homeViewModel = HomeViewModel(moviesStore: moviesStore, favoritesStore: favoritesStore, watchlistStore: watchlistStore)
        let detailViewModel = MovieDetailViewModel(
            movie: TestMovies.roma,
            moviesStore: moviesStore,
            favoritesStore: favoritesStore,
            watchlistStore: watchlistStore
        )

        // Act
        detailViewModel.toggleFavorite()
        detailViewModel.toggleWatchlist()

        // Assert
        #expect(homeViewModel.favoriteMovies == [TestMovies.roma])
        #expect(homeViewModel.watchlistMovies == [TestMovies.roma])
    }

    @Test
    func suggestionsExcludeCurrentMovieAndHaveMaximumSix() async {
        // Arrange
        let viewModel = MovieDetailViewModel(
            movie: TestMovies.parasite,
            moviesStore: await makeLoadedMoviesStore(),
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService()),
            watchlistStore: WatchlistStore(watchlistService: MockWatchlistService(), notificationService: MockNotificationService())
        )

        // Act
        let suggestions = viewModel.suggestions

        // Assert
        #expect(suggestions.count == 6)
        #expect(!suggestions.contains(TestMovies.parasite))
        #expect(suggestions.first == TestMovies.inception)
    }

    @Test
    func toggleWatchlistAddsAndRemovesMovie() async {
        // Arrange
        let viewModel = MovieDetailViewModel(
            movie: TestMovies.coco,
            moviesStore: await makeLoadedMoviesStore(),
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService()),
            watchlistStore: WatchlistStore(watchlistService: MockWatchlistService(), notificationService: MockNotificationService())
        )

        // Act + Assert
        viewModel.toggleWatchlist()
        #expect(viewModel.isInWatchlist)
        #expect(viewModel.message?.text == "Agregada a Por ver. Te la recordaremos en 2 semanas")

        viewModel.toggleWatchlist()
        #expect(!viewModel.isInWatchlist)
        #expect(viewModel.message?.text == "Quitada de Por ver")
    }

    @Test
    func addingToWatchlistSchedulesAReminder() async {
        // Arrange
        let notifications = MockNotificationService()
        let viewModel = MovieDetailViewModel(
            movie: TestMovies.coco,
            moviesStore: await makeLoadedMoviesStore(),
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService()),
            watchlistStore: WatchlistStore(watchlistService: MockWatchlistService(), notificationService: notifications)
        )

        // Act
        viewModel.toggleWatchlist()

        // Assert
        #expect(notifications.scheduledMovieIDs == [TestMovies.coco.id])
    }

    @Test
    func toggleWatchlistShowsErrorWhenSavingFails() async {
        // Arrange
        let viewModel = MovieDetailViewModel(
            movie: TestMovies.coco,
            moviesStore: await makeLoadedMoviesStore(),
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService()),
            watchlistStore: WatchlistStore(watchlistService: MockWatchlistService(shouldFail: true), notificationService: MockNotificationService())
        )

        // Act
        viewModel.toggleWatchlist()

        // Assert
        #expect(!viewModel.isInWatchlist)
        #expect(viewModel.message?.text == WatchlistError.saveFailed.message)
        #expect(viewModel.message?.isError == true)
    }
}
