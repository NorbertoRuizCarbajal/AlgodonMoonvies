import Foundation

//errores al cargar las películas
enum MovieError: Error {
    case internetError
    case unknown

    var message: String {
        switch self {
        case .internetError:
            return "Revisa tu conexión a internet e intenta de nuevo."
        case .unknown:
            return "Ocurrió un error inesperado. Intenta de nuevo."
        }
    }
}
