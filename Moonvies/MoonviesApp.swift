import SwiftUI
import SwiftData
import UserNotifications

@main
struct MoonviesApp: App {
    /// Base de datos local donde se guardan favoritos y Por ver
    private let sharedModelContainer: ModelContainer

    
    @State private var moviesStore: MoviesStore
    @State private var favoritesStore: FavoritesStore
    @State private var watchlistStore: WatchlistStore

    /// Se guarda aquí porque el centro de notificaciones no lo retiene
    private let notificationDelegate = NotificationDelegate()

    init() {
        let container = PersistenceController.makeModelContainer(inMemory: false)
        let context = ModelContext(container)

        sharedModelContainer = container
        _moviesStore = State(initialValue: MoviesStore(movieService: MovieService()))
        _favoritesStore = State(initialValue: FavoritesStore(favoritesService: FavoritesService(context: context)))
        _watchlistStore = State(initialValue: WatchlistStore(
            watchlistService: WatchlistService(context: context),
            notificationService: NotificationService()
        ))

        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
            WindowGroup {
                RootView(
                    moviesStore: moviesStore,
                    favoritesStore: favoritesStore,
                    watchlistStore: watchlistStore
                )
            }
            .modelContainer(sharedModelContainer)
        }
}
