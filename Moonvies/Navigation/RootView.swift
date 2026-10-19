import SwiftUI

/// Raíz de la navegación. Aquí vive la pila de pantallas (`path`)
/// y aquí se decide qué vista corresponde a cada `Route`.
struct RootView: View {
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .search:
                        SearchView()
                    case .detail(let movie):
                        MovieDetailView(movie: movie, onGoHome: goHome)
                    }
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
        .environment(FavoritesStore())
}
