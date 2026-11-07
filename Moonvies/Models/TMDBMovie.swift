import Foundation

/// Respuesta de `GET /3/movie/popular`
struct TMDBMoviesResponse: Decodable {
    let results: [TMDBMovie]
}

/// Película como la manda TMDB
struct TMDBMovie: Decodable {
    let id: Int
    let title: String
    let originalTitle: String?
    let overview: String?
    let releaseDate: String?
    /// TMDB califica de 0 a 10
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }

    func toMovie() -> Movie {
        let overviewText = overview ?? ""
        // "2024-05-01" → "2024"
        let yearText = String((releaseDate ?? "").prefix(4))

        return Movie(
            id: String(id),
            title: title,
            originalTitle: originalTitle ?? title,
            year: yearText.isEmpty ? "s/f" : yearText,
            // Escala de 0-10 a 0-5
            rating: (voteAverage ?? 0) / 2,
            synopsis: overviewText.isEmpty ? "Sin sinopsis disponible." : overviewText
        )
    }
}
