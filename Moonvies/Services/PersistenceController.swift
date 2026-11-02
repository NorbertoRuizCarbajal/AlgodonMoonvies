import Foundation
import SwiftData

/// Crea el contenedor de SwiftData de la app
struct PersistenceController {

    /// `inMemory: true` guarda todo solo en memoria (para #Preview y tests)
    static func makeModelContainer(inMemory: Bool) -> ModelContainer {
        let schema = Schema([
            FavoriteMovie.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("No se pudo crear el ModelContainer: \(error)")
        }
    }
}
