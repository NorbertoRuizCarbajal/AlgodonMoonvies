import Foundation

/// Contrato para obtener el catálogo de películas
protocol MovieServiceProtocol {
    func fetchMovies() async throws -> [Movie]
}

/// Consulta `GET /3/movie/popular` de TMDB
struct MovieService: MovieServiceProtocol {

    func fetchMovies() async throws -> [Movie] {
        let request = try makePopularMoviesRequest()

        let data = try await send(request)

        let result: TMDBMoviesResponse
        do {
            result = try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
        } catch {
            throw MovieError.decodingFailed
        }

        return result.results.map { $0.toMovie() }
    }

    // MARK: - Pasos de la solicitud

    private func makePopularMoviesRequest() throws -> URLRequest {
        guard Secrets.tmdbToken != "PEGA_AQUI_TU_TOKEN", !Secrets.tmdbToken.isEmpty else {
            throw MovieError.missingAPIKey
        }

        guard var components = URLComponents(string: "https://api.themoviedb.org/3/movie/popular") else {
            throw MovieError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "language", value: "es-MX"),
            URLQueryItem(name: "page", value: "1")
        ]

        guard let url = components.url else {
            throw MovieError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Secrets.tmdbToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }

    /// Ejecuta la solicitud y valida el código HTTP
    private func send(_ request: URLRequest) async throws -> Data {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw MovieError.noConnection
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw MovieError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw MovieError.httpStatus(httpResponse.statusCode)
        }

        return data
    }
}
