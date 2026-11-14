import Foundation
import UserNotifications

/// Contrato para programar los recordatorios de "Por ver"
/// `WatchlistStore` solo conoce este protocolo; en los tests se reemplaza por un mock
protocol NotificationServiceProtocol {
    func scheduleReminder(for movie: Movie, afterDays days: Int)
    func cancelReminder(movieID: String)
}

/// Implementación con notificaciones locales del sistema (UserNotifications)
/// No necesita internet ni servidor: el iPhone muestra la notificación cuando se cumple el tiempo
struct NotificationService: NotificationServiceProtocol {

    /// Programa: "Hace 2 semanas tienes pendiente por ver ..."
    func scheduleReminder(for movie: Movie, afterDays days: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Moonvies"
        content.body = WatchlistReminder.message(for: movie, days: days)
        content.sound = .default

        // El sistema pide un tiempo mayor a 0; con 0 días llega a los 5 segundos (útil para probar)
        let seconds = max(Double(days) * 24 * 60 * 60, 5)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        let request = UNNotificationRequest(
            identifier: identifier(for: movie.id),
            content: content,
            trigger: trigger
        )

        Task {
            let center = UNUserNotificationCenter.current()

            do {
                // La primera vez el sistema pregunta al usuario; después solo responde lo que ya eligió
                let granted = try await center.requestAuthorization(options: [.alert, .sound])
                guard granted else { return }

                try await center.add(request)
            } catch {
                print("No se pudo programar el recordatorio:", error)
            }
        }
    }

    /// Si la película sale de "Por ver", ya no tiene sentido recordarla
    func cancelReminder(movieID: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [identifier(for: movieID)])
    }

    /// Un identificador por película, para poder cancelar su recordatorio
    private func identifier(for movieID: String) -> String {
        "por-ver-\(movieID)"
    }
}
