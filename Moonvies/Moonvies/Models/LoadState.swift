import Foundation

// estados de  carga 
enum LoadState {
    case idle
    case loading
    case loaded([Movie])
    case error(MovieError)
}
