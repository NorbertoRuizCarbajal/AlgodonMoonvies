import Foundation
import Observation

/// Prepara los recordatorios que muestra la pantalla Notificaciones
@MainActor
@Observable
final class NotificationsViewModel {
    private let watchlistStore: WatchlistStore

    init(watchlistStore: WatchlistStore) {
        self.watchlistStore = watchlistStore
    }

    /// Se calcula con la fecha de hoy cada vez que se dibuja la pantalla
    var reminders: [WatchlistReminder] {
        watchlistStore.reminders(today: Date())
    }

    /// Texto que explica cuándo llegan los recordatorios
    var explanation: String {
        "Te avisamos cuando una película lleva \(WatchlistReminder.minimumDays) días o más en Por ver."
    }
}
