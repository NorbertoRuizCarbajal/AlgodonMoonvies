import SwiftUI

// Pantalla principal
struct HomeView: View {
    @Environment(FeedbackCenter.self) private var feedbackCenter

  
    @State private var selectedTab: HomeTab = .recommended

    var body: some View {
        VStack(spacing: 16) {
            HomeHeaderView(
                showsNotificationBadge: true,
                onSearchTap: openSearch,
                onIconTap: showComingSoon
            )

            TabSelectorView(selectedTab: $selectedTab)

            ScrollView {
                HomeContentView(selectedTab: selectedTab)
                    .padding(.bottom, 32)
            }
        }
    }

    
    private func openSearch() {
        feedbackCenter.showComingSoon("La búsqueda")
    }

    private func showComingSoon(_ feature: String) {
        feedbackCenter.showComingSoon(feature)
    }
}


struct HomeContentView: View {
    let selectedTab: HomeTab

    @Environment(MoviesViewModel.self) private var moviesViewModel

    var body: some View {
        switch moviesViewModel.state {
        case .idle, .loading:
            MessageView(
                iconName: "hourglass",
                title: "Cargando películas...",
                message: "Esto tarda solo un momento."
            )

        case .error(let movieError):
            MessageView(
                iconName: "wifi.exclamationmark",
                title: "No se pudieron cargar las películas",
                message: movieError.message,
                buttonTitle: "Reintentar"
            ) {
                Task {
                    await moviesViewModel.loadMovies()
                }
            }

        case .loaded:
            switch selectedTab {
            case .recommended:
                RecommendedTabView()
            case .all, .favorites:
                
                VStack {
                }
            
            }
        }
    }
}

#Preview {
    HomeView()
        .previewEnvironment()
}
