import Foundation

/// Contrato para obtener las películas.
/// Hoy lo cumple un mock con datos locales; después podría ser una API
/// sin cambiar ningún ViewModel ni ninguna vista.
protocol MovieRepository {
    func fetchMovies() async throws -> [Movie]
}

/// Implementación con los datos locales de `MockMovies`.
struct MockMovieRepository: MovieRepository {
    func fetchMovies() async throws -> [Movie] {
        MockMovies().all
    }
}
