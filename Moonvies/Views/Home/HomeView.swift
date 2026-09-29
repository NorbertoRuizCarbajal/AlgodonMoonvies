import SwiftUI

// Pantalla principal: header, barra de búsqueda y pestañas
struct HomeView: View {
    @State private var selectedTab: HomeTab = .recommended

    var body: some View {
        VStack(spacing: 16) {
            HomeHeaderView()

            TabSelectorView(selectedTab: $selectedTab)

            ScrollView {
                HomeTabContentView(selectedTab: selectedTab)
                    .padding(.bottom, 32)
            }
        }
    }
}

struct HomeTabContentView: View {
    let selectedTab: HomeTab

    var body: some View {
        switch selectedTab {
        case .recommended:
            RecommendedTabView()
        case .all:
            // Pestaña "Todo": por ahora sin contenido.
            VStack {
            }
        case .favorites:
            FavoritesTabView()
        }
    }
}

#Preview {
    HomeView()
}
