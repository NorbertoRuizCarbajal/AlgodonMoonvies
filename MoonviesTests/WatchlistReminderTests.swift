import Foundation
import Testing
@testable import Moonvies

/// Pruebas de las reglas de los recordatorios de "Por ver"
@MainActor
struct WatchlistReminderTests {

    private let today = Date()

    private func item(_ movie: Movie, daysAgo days: Int) -> WatchlistItem {
        let date = Calendar.current.date(byAdding: .day, value: -days, to: today) ?? today
        return WatchlistItem(movie: movie, addedAt: date)
    }

    @Test
    func messageSaysHowLongTheMovieHasBeenPending() {
        // Act
        let message = WatchlistReminder.message(for: TestMovies.coco, days: 14)

        // Assert
        #expect(message == "Hace 2 semanas tienes pendiente por ver Coco")
    }

    @Test(arguments: [
        (0, "Hoy"),
        (1, "Hace 1 día"),
        (5, "Hace 5 días"),
        (7, "Hace 1 semana"),
        (14, "Hace 2 semanas"),
        (20, "Hace 2 semanas"),
        (21, "Hace 3 semanas")
    ])
    func timeAgoTextUsesDaysOrWeeks(days: Int, expectedText: String) {
        #expect(WatchlistReminder.timeAgoText(days: days) == expectedText)
    }

    @Test
    func moviesAddedLessThanTwoWeeksAgoHaveNoReminder() {
        // Arrange
        let items = [item(TestMovies.coco, daysAgo: 0), item(TestMovies.roma, daysAgo: 13)]

        // Act
        let reminders = WatchlistReminder.makeReminders(from: items, today: today)

        // Assert
        #expect(reminders.isEmpty)
    }

    @Test
    func moviesAddedTwoWeeksAgoOrMoreHaveAReminder() {
        // Arrange
        let items = [item(TestMovies.coco, daysAgo: 14), item(TestMovies.roma, daysAgo: 30)]

        // Act
        let reminders = WatchlistReminder.makeReminders(from: items, today: today)

        // Assert: la más antigua primero
        #expect(reminders.map { $0.movie } == [TestMovies.roma, TestMovies.coco])
        #expect(reminders.map { $0.daysPending } == [30, 14])
    }

    @Test
    func emptyWatchlistHasNoReminders() {
        #expect(WatchlistReminder.makeReminders(from: [], today: today).isEmpty)
    }
}
