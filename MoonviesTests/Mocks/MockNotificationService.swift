import Foundation
@testable import Moonvies

/// Reemplaza a `NotificationService` en los tests: en lugar de programar
/// notificaciones reales, anota qué se pidió para poder comprobarlo
@MainActor
final class MockNotificationService: NotificationServiceProtocol {

    private(set) var scheduledMovieIDs: [String] = []
    private(set) var scheduledDays: [Int] = []
    private(set) var cancelledMovieIDs: [String] = []

    func scheduleReminder(for movie: Movie, afterDays days: Int) {
        scheduledMovieIDs.append(movie.id)
        scheduledDays.append(days)
    }

    func cancelReminder(movieID: String) {
        cancelledMovieIDs.append(movieID)
    }
}
