import SwiftUI

/// Raíz de la navegación. Aquí vive la pila de pantallas (`path`),
/// aquí se decide qué vista corresponde a cada `Route`
/// y aquí se crea el ViewModel de cada pantalla con lo que necesita.
struct RootView: View {
    @Environment(MoviesStore.self) private var moviesStore
    @Environment(FavoritesStore.self) private var favoritesStore

    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(viewModel: HomeViewModel(moviesStore: moviesStore, favoritesStore: favoritesStore))
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .search:
                        SearchView(viewModel: SearchViewModel(moviesStore: moviesStore))
                    case .detail(let movie):
                        MovieDetailView(
                            viewModel: MovieDetailViewModel(
                                movie: movie,
                                moviesStore: moviesStore,
                                favoritesStore: favoritesStore
                            ),
                            onGoHome: goHome
                        )
                    }
                }
        }
        .onAppear {
            Task {
                await moviesStore.loadMovies()
            }
        }
    }

    /// "Fin → Regresar a Home" del diagrama: vacía la pila de un solo paso.
    private func goHome() {
        path.removeAll()
    }
}

#Preview {
    RootView()
        .environment(MoviesStore(repository: MockMovieRepository()))
        .environment(FavoritesStore())
}
