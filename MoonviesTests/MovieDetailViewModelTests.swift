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
            favoritesStore: favoritesStore
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
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService())
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
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService(shouldFail: true))
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
        let homeViewModel = HomeViewModel(moviesStore: moviesStore, favoritesStore: favoritesStore)
        let detailViewModel = MovieDetailViewModel(
            movie: TestMovies.roma,
            moviesStore: moviesStore,
            favoritesStore: favoritesStore
        )

        // Act
        detailViewModel.toggleFavorite()

        // Assert
        #expect(homeViewModel.favoriteMovies == [TestMovies.roma])
    }

    @Test
    func suggestionsExcludeCurrentMovieAndHaveMaximumSix() async {
        // Arrange
        let viewModel = MovieDetailViewModel(
            movie: TestMovies.parasite,
            moviesStore: await makeLoadedMoviesStore(),
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService())
        )

        // Act
        let suggestions = viewModel.suggestions

        // Assert
        #expect(suggestions.count == 6)
        #expect(!suggestions.contains(TestMovies.parasite))
        #expect(suggestions.first == TestMovies.inception)
    }

    @Test
    func showComingSoonShowsMessage() async {
        // Arrange
        let viewModel = MovieDetailViewModel(
            movie: TestMovies.coco,
            moviesStore: await makeLoadedMoviesStore(),
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService())
        )

        // Act
        viewModel.showComingSoon("Calificar")

        // Assert
        #expect(viewModel.message?.text == "Calificar estará disponible pronto")
    }
}
