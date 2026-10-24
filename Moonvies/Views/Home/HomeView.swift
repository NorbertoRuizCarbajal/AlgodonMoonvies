import SwiftUI

/// Pantalla principal: header, barra de búsqueda y pestañas.
/// Solo dibuja: los datos ya vienen preparados por `HomeViewModel`.
struct HomeView: View {
    @State private var viewModel: HomeViewModel

    /// Estado de interfaz: solo Home necesita saber qué pestaña está seleccionada,
    /// por eso se queda en la vista y no en el ViewModel.
    @State private var selectedTab: HomeTab = .recommended

    init(viewModel: HomeViewModel) {
        // `State(initialValue:)` guarda el ViewModel la primera vez y lo conserva
        // aunque la vista se vuelva a crear.
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            HomeHeaderView()

            TabSelectorView(selectedTab: $selectedTab)

            ScrollView {
                HomeTabContentView(selectedTab: selectedTab, viewModel: viewModel)
                    .padding(.bottom, 32)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

/// Decide qué mostrar según el estado de la carga y la pestaña seleccionada.
struct HomeTabContentView: View {
    let selectedTab: HomeTab
    let viewModel: HomeViewModel

    var body: some View {
        switch viewModel.loadState {
        case .idle, .loading:
            MessageView(title: "Cargando películas...")

        case .error(let movieError):
            MessageView(title: movieError.message, buttonTitle: "Reintentar") {
                Task {
                    await viewModel.retryLoading()
                }
            }

        case .loaded:
            switch selectedTab {
            case .recommended:
                RecommendedTabView(
                    bestRatedMovie: viewModel.bestRatedToday,
                    weeklyTop: viewModel.weeklyTop
                )
            case .all:
                // Pestaña "Todo": por ahora sin contenido.
                VStack {
                }
            case .favorites:
                FavoritesTabView(movies: viewModel.favoriteMovies)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: HomeViewModel(moviesStore: .preview(), favoritesStore: FavoritesStore()))
    }
}
