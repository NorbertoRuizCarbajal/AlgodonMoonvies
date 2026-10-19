import SwiftUI

/// Pantalla principal: header, barra de búsqueda y pestañas.
struct HomeView: View {
    /// Estado local: solo Home necesita saber qué pestaña está seleccionada.
    /// Como Home se queda en la base de la pila, la pestaña se conserva al regresar.
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
        .toolbar(.hidden, for: .navigationBar)
    }
}

/// Muestra el contenido de la pestaña seleccionada.
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
    NavigationStack {
        HomeView()
    }
    .environment(FavoritesStore())
}
