import SwiftUI

/// Raíz de la navegación. Aquí vive la pila de pantallas (`path`),
/// aquí se decide qué vista corresponde a cada `Route`
/// y aquí se crea el ViewModel de cada pantalla con lo que necesita.
/// Recibe los stores por parámetro desde `MoonviesApp`
struct RootView: View {
    let moviesStore: MoviesStore
    let favoritesStore: FavoritesStore
    let watchlistStore: WatchlistStore

    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(
                viewModel: HomeViewModel(
                    moviesStore: moviesStore,
                    favoritesStore: favoritesStore,
                    watchlistStore: watchlistStore
                )
            )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .search:
                        SearchView(viewModel: SearchViewModel(moviesStore: moviesStore))
                    case .notifications:
                        NotificationsView(viewModel: NotificationsViewModel(watchlistStore: watchlistStore))
                    case .detail(let movie):
                        MovieDetailView(
                            viewModel: MovieDetailViewModel(
                                movie: movie,
                                moviesStore: moviesStore,
                                favoritesStore: favoritesStore,
                                watchlistStore: watchlistStore
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

    /// "Fin → Regresar a Home" del diagrama: vacía la pila de un solo paso
    private func goHome() {
        path.removeAll()
    }
}

#Preview {
    RootView(
        moviesStore: .preview(),
        favoritesStore: .preview(),
        watchlistStore: .preview()
    )
}
