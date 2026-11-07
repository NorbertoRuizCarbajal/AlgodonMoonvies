import Foundation

/// Estados de la carga del catálogo
enum LoadState: Equatable {
    case idle
    case loading
    case loaded([Movie])
    /// Consulta exitosa sin películas
    case empty
    case error(MovieError)
}
