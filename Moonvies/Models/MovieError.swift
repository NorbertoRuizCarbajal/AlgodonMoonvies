import Foundation

/// Errores al cargar el catálogo
enum MovieError: Error, Equatable {
    /// Todavía no se pegó el token en `Secrets.swift`
    case missingAPIKey
    /// No se pudo construir la URL de la solicitud
    case invalidURL
    /// Sin internet o sin conexión con el servidor
    case noConnection
    /// La respuesta no es HTTP
    case invalidResponse
    /// Código HTTP fuera de 200...299
    case httpStatus(Int)
    /// El JSON no tiene la forma esperada
    case decodingFailed
    /// Cualquier otro fallo
    case loadFailed

    var message: String {
        switch self {
        case .missingAPIKey:
            return "Falta el token de TMDB. Pégalo en Secrets.swift."
        case .invalidURL:
            return "La dirección del servicio no es válida."
        case .noConnection:
            return "No hay conexión con el servidor. Revisa tu internet e intenta de nuevo."
        case .invalidResponse:
            return "El servidor respondió algo inesperado. Intenta de nuevo."
        case .httpStatus(let code) where code == 401:
            return "El token de TMDB no es válido (error 401)."
        case .httpStatus(let code):
            return "El servidor respondió con el error \(code). Intenta de nuevo."
        case .decodingFailed:
            return "No se pudo leer la información que mandó el servidor."
        case .loadFailed:
            return "No se pudieron cargar las películas. Intenta de nuevo."
        }
    }
}
