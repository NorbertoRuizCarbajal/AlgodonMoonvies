import Foundation
import Testing
@testable import Moonvies

/// Pruebas de las reglas de "Por ver", su guardado y sus recordatorios
@MainActor
struct WatchlistStoreTests {

    private func daysAgo(_ days: Int, from today: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: today) ?? today
    }

    @Test
    func initLoadsSavedMovies() {
        // Arrange
        let service = MockWatchlistService(savedMovies: [TestMovies.coco])

        // Act
        let store = WatchlistStore(watchlistService: service, notificationService: MockNotificationService())

        // Assert
        #expect(store.movies == [TestMovies.coco])
        #expect(store.contains(TestMovies.coco))
    }

    @Test
    func addSavesMovieAndPutsItFirst() throws {
        // Arrange
        let service = MockWatchlistService()
        let store = WatchlistStore(watchlistService: service, notificationService: MockNotificationService())

        // Act
        try store.add(TestMovies.coco)
        try store.add(TestMovies.roma)

        // Assert
        #expect(store.movies == [TestMovies.roma, TestMovies.coco])
        #expect(service.savedMovies == [TestMovies.roma, TestMovies.coco])
    }

    @Test
    func addingTheSameMovieTwiceThrowsAlreadyAdded() throws {
        // Arrange
        let store = WatchlistStore(watchlistService: MockWatchlistService(), notificationService: MockNotificationService())
        try store.add(TestMovies.coco)

        // Act + Assert
        #expect(throws: WatchlistError.self) {
            try store.add(TestMovies.coco)
        }
        #expect(store.movies.count == 1)
    }

    @Test
    func addDoesNotChangeTheListWhenSavingFails() {
        // Arrange
        let store = WatchlistStore(watchlistService: MockWatchlistService(shouldFail: true), notificationService: MockNotificationService())

        // Act + Assert
        #expect(throws: WatchlistError.self) {
            try store.add(TestMovies.coco)
        }
        #expect(store.movies.isEmpty)
    }

    @Test
    func removeDeletesOnlyThatMovie() throws {
        // Arrange
        let store = WatchlistStore(
            watchlistService: MockWatchlistService(savedMovies: [TestMovies.roma, TestMovies.coco]),
            notificationService: MockNotificationService()
        )

        // Act
        try store.remove(TestMovies.coco)

        // Assert
        #expect(store.movies == [TestMovies.roma])
    }

    // MARK: - Recordatorios

    @Test
    func addSchedulesAReminderInTwoWeeks() throws {
        // Arrange
        let notifications = MockNotificationService()
        let store = WatchlistStore(watchlistService: MockWatchlistService(), notificationService: notifications)

        // Act
        try store.add(TestMovies.coco)

        // Assert
        #expect(notifications.scheduledMovieIDs == [TestMovies.coco.id])
        #expect(notifications.scheduledDays == [14])
    }

    @Test
    func noReminderIsScheduledWhenSavingFails() {
        // Arrange
        let notifications = MockNotificationService()
        let store = WatchlistStore(watchlistService: MockWatchlistService(shouldFail: true), notificationService: notifications)

        // Act
        try? store.add(TestMovies.coco)

        // Assert
        #expect(notifications.scheduledMovieIDs.isEmpty)
    }

    @Test
    func removeCancelsTheReminder() throws {
        // Arrange
        let notifications = MockNotificationService()
        let store = WatchlistStore(
            watchlistService: MockWatchlistService(savedMovies: [TestMovies.coco]),
            notificationService: notifications
        )

        // Act
        try store.remove(TestMovies.coco)

        // Assert
        #expect(notifications.cancelledMovieIDs == [TestMovies.coco.id])
    }

    @Test
    func remindersUseTheSavedDates() {
        // Arrange: Coco lleva 15 días, Roma solo 3
        let today = Date()
        let service = MockWatchlistService(savedItems: [
            WatchlistItem(movie: TestMovies.roma, addedAt: daysAgo(3, from: today)),
            WatchlistItem(movie: TestMovies.coco, addedAt: daysAgo(15, from: today))
        ])
        let store = WatchlistStore(watchlistService: service, notificationService: MockNotificationService())

        // Act
        let reminders = store.reminders(today: today)

        // Assert
        #expect(reminders.map { $0.movie } == [TestMovies.coco])
    }
}
