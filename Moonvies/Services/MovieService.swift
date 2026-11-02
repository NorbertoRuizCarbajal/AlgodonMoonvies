import Foundation

/// Contrato para obtener el catálogo de películas
/// La app solo conoce este protocolo, así se puede cambiar el origen de los datos
/// (datos locales, la API de TMDB o un mock en los tests) sin tocar ViewModels ni vistas
protocol MovieServiceProtocol {
    func fetchMovies() async throws -> [Movie]
}

/// Servicio actual: regresa el catálogo local y simula el tiempo de respuesta de una API
struct MovieService: MovieServiceProtocol {

    func fetchMovies() async throws -> [Movie] {
        try await Task.sleep(for: .milliseconds(500))

        return MockMovies().all
    }
}
