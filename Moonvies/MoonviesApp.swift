import SwiftUI

@main
struct MoonviesApp: App {
    // Estado compartido de toda la app: se crea una sola vez aquí
    // y se reparte con `.environment(...)`.
    @State private var moviesStore = MoviesStore(repository: MockMovieRepository())
    @State private var favoritesStore = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(moviesStore)
                .environment(favoritesStore)
        }
    }
}
