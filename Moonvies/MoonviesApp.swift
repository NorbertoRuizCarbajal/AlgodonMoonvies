import SwiftUI

@main
struct MoonviesApp: App {
    /// Favoritos: estado compartido por Home y Detalle.
    /// Se crea una sola vez aquí y se reparte con `.environment(...)`.
    @State private var favoritesStore = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(favoritesStore)
        }
    }
}
