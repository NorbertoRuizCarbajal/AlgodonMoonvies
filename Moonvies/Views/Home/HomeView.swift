import SwiftUI

/// Pantalla principal: header, barra de búsqueda y pestañas
/// Solo dibuja: los datos ya vienen preparados por `HomeViewModel`
struct HomeView: View {
    @State private var viewModel: HomeViewModel

    /// Estado de interfaz: solo Home necesita saber qué pestaña está seleccionada,
    /// por eso se queda en la vista y no en el ViewModel
    @State private var selectedTab: HomeTab = .recommended

    init(viewModel: HomeViewModel) {
        // `State(initialValue:)` guarda el ViewModel la primera vez y lo conserva
        // aunque la vista se vuelva a crear
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            HomeHeaderView(remindersCount: viewModel.remindersCount)

            TabSelectorView(selectedTab: $selectedTab)

            ScrollView {
                HomeTabContentView(selectedTab: selectedTab, viewModel: viewModel)
                    .padding(.bottom, 32)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

/// Decide qué mostrar según el estado de la carga y la pestaña seleccionada
struct HomeTabContentView: View {
    let selectedTab: HomeTab
    let viewModel: HomeViewModel

    var body: some View {
        switch selectedTab {
        // Favoritos y Por ver están guardados en el dispositivo, no dependen de la carga
        case .favorites:
            MovieListTabView(movies: viewModel.favoriteMovies, emptyTitle: "Aún no hay favoritos")
        case .watchlist:
            MovieListTabView(movies: viewModel.watchlistMovies, emptyTitle: "Aún no tienes películas por ver")
        case .recommended, .all:
            LoadStateView(state: viewModel.loadState, onRetry: retry) {
                catalogContent
            }
        }
    }

    @ViewBuilder
    private var catalogContent: some View {
        if selectedTab == .recommended {
            RecommendedTabView(
                bestRatedMovie: viewModel.bestRatedToday,
                weeklyTop: viewModel.weeklyTop
            )
        } else {
            VStack(spacing: 24) {
                MovieListTabView(movies: viewModel.allMovies, emptyTitle: "No hay películas por ahora")

                if viewModel.canLoadMore {
                    LoadMoreView(
                        isLoading: viewModel.isLoadingMore,
                        errorMessage: viewModel.loadMoreError?.message,
                        onLoadMore: loadMore
                    )
                }
            }
        }
    }

    private func retry() {
        Task {
            await viewModel.retryLoading()
        }
    }

    private func loadMore() {
        Task {
            await viewModel.loadMore()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(
                moviesStore: .preview(),
                favoritesStore: .preview(),
                watchlistStore: .preview()
            )
        )
    }
}
