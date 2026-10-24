import Foundation

/// Errores al agregar a favoritos (rama "No" del rombo "¿Se agregó a favoritos?").
enum FavoriteError: Error {
    case alreadyAdded
    case limitReached

    var message: String {
        switch self {
        case .alreadyAdded:
            return "Esta película ya está en tus favoritos."
        case .limitReached:
            return "Llegaste al límite de favoritos. Quita alguna para agregar otra."
        }
    }
}
