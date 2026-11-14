import Foundation
import Testing
@testable import Moonvies

/// Pruebas de la pantalla Notificaciones y del número de la campana en Home
@MainActor
struct NotificationsViewModelTests {

    private func makeWatchlistStore(daysAgo days: [Int]) -> WatchlistStore {
        let movies = [TestMovies.coco, TestMovies.roma, TestMovies.parasite]
        var items: [WatchlistItem] = []

        for index in days.indices {
            let date = Calendar.current.date(byAdding: .day, value: -days[index], to: Date()) ?? Date()
            items.append(WatchlistItem(movie: movies[index], addedAt: date))
        }

        return WatchlistStore(watchlistService: MockWatchlistService(savedItems: items), notificationService: MockNotificationService())
    }

    @Test
    func remindersShowOnlyOldMovies() {
        // Arrange
        let viewModel = NotificationsViewModel(watchlistStore: makeWatchlistStore(daysAgo: [20, 2]))

        // Act
        let reminders = viewModel.reminders

        // Assert
        #expect(reminders.count == 1)
        #expect(reminders.first?.message == "Hace 2 semanas tienes pendiente por ver Coco")
    }

    @Test
    func remindersAreEmptyWhenWatchlistIsEmpty() {
        // Arrange
        let viewModel = NotificationsViewModel(watchlistStore: makeWatchlistStore(daysAgo: []))

        // Act + Assert
        #expect(viewModel.reminders.isEmpty)
    }

    @Test
    func homeBellCountsPendingReminders() {
        // Arrange
        let watchlistStore = makeWatchlistStore(daysAgo: [15, 40, 1])
        let homeViewModel = HomeViewModel(
            moviesStore: MoviesStore(movieService: MockMovieService(moviesToReturn: [])),
            favoritesStore: FavoritesStore(favoritesService: MockFavoritesService()),
            watchlistStore: watchlistStore
        )

        // Act + Assert
        #expect(homeViewModel.remindersCount == 2)
    }
}
