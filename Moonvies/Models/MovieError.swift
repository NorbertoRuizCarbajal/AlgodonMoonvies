import Foundation

/// Errores al cargar el catálogo de películas.
enum MovieError: Error {
    case loadFailed

    var message: String {
        switch self {
        case .loadFailed:
            return "No se pudieron cargar las películas. Intenta de nuevo."
        }
    }
}
