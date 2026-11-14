import Foundation

/// Contrato para obtener películas de TMDB
protocol MovieServiceProtocol {
    func fetchMovies(page: Int) async throws -> MoviesPage
    func searchMovies(query: String) async throws -> [Movie]
}

/// Consulta la API de TMDB:
/// - `GET /3/movie/popular` para el catálogo
/// - `GET /3/search/movie` para la búsqueda
struct MovieService: MovieServiceProtocol {

    func fetchMovies(page: Int) async throws -> MoviesPage {
        let request = try makeRequest(
            path: "movie/popular",
            queryItems: [URLQueryItem(name: "page", value: String(page))]
        )

        return try await sendAndDecode(request).toPage()
    }

    func searchMovies(query: String) async throws -> [Movie] {
        let request = try makeRequest(
            path: "search/movie",
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "include_adult", value: "false")
            ]
        )

        return try await sendAndDecode(request).toPage().movies
    }

    // MARK: - Pasos de la solicitud

    private func makeRequest(path: String, queryItems: [URLQueryItem]) throws -> URLRequest {
        guard Secrets.tmdbToken != "PEGA_AQUI_TU_TOKEN", !Secrets.tmdbToken.isEmpty else {
            throw MovieError.missingAPIKey
        }

        guard var components = URLComponents(string: "https://api.themoviedb.org/3/" + path) else {
            throw MovieError.invalidURL
        }

        components.queryItems = [URLQueryItem(name: "language", value: "es-MX")] + queryItems

        guard let url = components.url else {
            throw MovieError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Secrets.tmdbToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }

    /// Ejecuta la solicitud, valida el código HTTP y decodifica el JSON
    private func sendAndDecode(_ request: URLRequest) async throws -> TMDBMoviesResponse {
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

        do {
            return try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
        } catch {
            throw MovieError.decodingFailed
        }
    }
}
