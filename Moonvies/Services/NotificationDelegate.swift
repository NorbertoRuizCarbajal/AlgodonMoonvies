import Foundation
import UserNotifications

/// Por defecto iOS no muestra notificaciones si la app está abierta
/// Este delegado le pide al sistema que también las muestre como banner
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
