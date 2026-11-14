import Foundation
import SwiftData

/// Contrato para guardar "Por ver" de forma permanente
protocol WatchlistServiceProtocol {
    func fetchItems() -> [WatchlistItem]
    func saveMovie(_ movie: Movie, addedAt: Date) throws
    func removeMovie(movieID: String) throws
}

/// Implementación con SwiftData
final class WatchlistService: WatchlistServiceProtocol {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Del agregado más reciente al más antiguo, con su fecha
    func fetchItems() -> [WatchlistItem] {
        let descriptor = FetchDescriptor<WatchlistMovie>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )

        let saved = (try? context.fetch(descriptor)) ?? []

        return saved.map { $0.item }
    }

    func saveMovie(_ movie: Movie, addedAt: Date) throws {
        context.insert(WatchlistMovie(movie: movie, addedAt: addedAt))

        try context.save()
    }

    func removeMovie(movieID: String) throws {
        let descriptor = FetchDescriptor<WatchlistMovie>(
            predicate: #Predicate {
                $0.movieID == movieID
            }
        )

        for saved in try context.fetch(descriptor) {
            context.delete(saved)
        }

        try context.save()
    }
}
