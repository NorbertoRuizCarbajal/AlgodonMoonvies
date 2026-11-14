import Foundation

/// Errores al agregar o quitar películas de "Por ver"
enum WatchlistError: Error {
    case alreadyAdded
    case saveFailed
    case removeFailed

    var message: String {
        switch self {
        case .alreadyAdded:
            return "Esta película ya está en Por ver."
        case .saveFailed:
            return "No se pudo guardar en Por ver. Intenta de nuevo."
        case .removeFailed:
            return "No se pudo quitar de Por ver. Intenta de nuevo."
        }
    }
}
