import Foundation

/// Estados de la carga del catálogo: cargando, éxito o error
enum LoadState: Equatable {
    case idle
    case loading
    case loaded([Movie])
    case error(MovieError)
}
