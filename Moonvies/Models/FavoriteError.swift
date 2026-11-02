import Foundation

/// Errores al agregar o quitar favoritos (rama "No" del rombo "¿Se agregó a favoritos?")
enum FavoriteError: Error {
    case alreadyAdded
    case limitReached
    case saveFailed
    case removeFailed

    var message: String {
        switch self {
        case .alreadyAdded:
            return "Esta película ya está en tus favoritos."
        case .limitReached:
            return "Llegaste al límite de favoritos. Quita alguna para agregar otra."
        case .saveFailed:
            return "No se pudo guardar el favorito. Intenta de nuevo."
        case .removeFailed:
            return "No se pudo quitar de favoritos. Intenta de nuevo."
        }
    }
}
