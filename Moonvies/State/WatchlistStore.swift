import Foundation
import SwiftData
import Observation

/// Fuente única de verdad de "Por ver", compartida por Home, Detalle y Notificaciones
@MainActor
@Observable
final class WatchlistStore {
    /// Del agregado más reciente al más antiguo, con la fecha en que se agregó
    private(set) var items: [WatchlistItem]

    private let watchlistService: any WatchlistServiceProtocol
    private let notificationService: any NotificationServiceProtocol

    init(watchlistService: any WatchlistServiceProtocol, notificationService: any NotificationServiceProtocol) {
        self.watchlistService = watchlistService
        self.notificationService = notificationService
        self.items = watchlistService.fetchItems()
    }

    var movies: [Movie] {
        items.map { $0.movie }
    }

    func contains(_ movie: Movie) -> Bool {
        items.contains { $0.movie.id == movie.id }
    }

    /// Primero se guarda en el dispositivo y solo si funcionó se actualiza la lista
    /// y se programa el recordatorio de 2 semanas
    func add(_ movie: Movie) throws {
        guard !contains(movie) else {
            throw WatchlistError.alreadyAdded
        }

        let addedAt = Date()

        do {
            try watchlistService.saveMovie(movie, addedAt: addedAt)
        } catch {
            throw WatchlistError.saveFailed
        }

        items.insert(WatchlistItem(movie: movie, addedAt: addedAt), at: 0)
        notificationService.scheduleReminder(for: movie, afterDays: WatchlistReminder.minimumDays)
    }

    func remove(_ movie: Movie) throws {
        do {
            try watchlistService.removeMovie(movieID: movie.id)
        } catch {
            throw WatchlistError.removeFailed
        }

        items.removeAll { $0.movie.id == movie.id }
        notificationService.cancelReminder(movieID: movie.id)
    }

    /// Películas que llevan mucho tiempo pendientes. `today` se recibe para poder probarlo
    func reminders(today: Date) -> [WatchlistReminder] {
        WatchlistReminder.makeReminders(from: items, today: today)
    }
}

// MARK: - Datos para los #Preview

extension WatchlistStore {
    static func preview() -> WatchlistStore {
        let container = PersistenceController.makeModelContainer(inMemory: true)
        let service = WatchlistService(context: ModelContext(container))

        return WatchlistStore(watchlistService: service, notificationService: NotificationService())
    }
}
