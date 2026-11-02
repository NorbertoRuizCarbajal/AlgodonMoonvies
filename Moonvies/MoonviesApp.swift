import SwiftUI
import SwiftData

@main
struct MoonviesApp: App {
    /// Base de datos local donde se guardan los favoritos
    private let sharedModelContainer: ModelContainer

    // Estado compartido de toda la app: se crea una sola vez aquí
    // y se reparte con `.environment(...)`
    @State private var moviesStore: MoviesStore
    @State private var favoritesStore: FavoritesStore

    init() {
        let container = PersistenceController.makeModelContainer(inMemory: false)
        let favoritesService = FavoritesService(context: ModelContext(container))

        sharedModelContainer = container
        _moviesStore = State(initialValue: MoviesStore(movieService: MovieService()))
        _favoritesStore = State(initialValue: FavoritesStore(favoritesService: favoritesService))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(moviesStore)
                .environment(favoritesStore)
        }
        .modelContainer(sharedModelContainer)
    }
}
