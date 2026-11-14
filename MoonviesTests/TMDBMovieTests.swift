import Foundation
import Testing
@testable import Moonvies

/// Pruebas de la decodificación del JSON de TMDB y de su conversión a `Movie`
@MainActor
struct TMDBMovieTests {

    private func decode(_ json: String) throws -> TMDBMoviesResponse {
        let data = Data(json.utf8)
        return try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
    }

    @Test
    func decodesMoviesAndConvertsThemToMovie() throws {
        // Arrange
        let json = """
        {
          "page": 1,
          "total_pages": 500,
          "results": [
            {
              "id": 550,
              "title": "El club de la pelea",
              "original_title": "Fight Club",
              "overview": "Un oficinista insomne conoce a un vendedor de jabón.",
              "release_date": "1999-10-15",
              "vote_average": 8.4,
              "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"
            }
          ]
        }
        """

        // Act
        let movies = try decode(json).results.map { $0.toMovie() }

        // Assert
        #expect(movies.count == 1)
        #expect(movies[0].id == "550")
        #expect(movies[0].title == "El club de la pelea")
        #expect(movies[0].originalTitle == "Fight Club")
        #expect(movies[0].year == "1999")
        #expect(movies[0].releaseDate == "1999-10-15")
        #expect(movies[0].rating == 4.2)
        #expect(movies[0].posterPath == "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg")
        #expect(movies[0].posterURL?.absoluteString == "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg")
    }

    @Test
    func convertsTheResponseToAPageWithItsNumbers() throws {
        // Arrange
        let json = #"{ "page": 3, "total_pages": 500, "results": [] }"#

        // Act
        let page = try decode(json).toPage()

        // Assert
        #expect(page.page == 3)
        #expect(page.totalPages == 500)
        #expect(page.movies.isEmpty)
    }

    @Test
    func usesDefaultsWhenOptionalFieldsAreMissing() throws {
        // Arrange: solo vienen los campos obligatorios
        let json = """
        { "page": 1, "total_pages": 1, "results": [ { "id": 1, "title": "Sin datos" } ] }
        """

        // Act
        let movie = try decode(json).results[0].toMovie()

        // Assert
        #expect(movie.year == "s/f")
        #expect(movie.releaseDateText == "Fecha de estreno no disponible")
        #expect(movie.rating == 0)
        #expect(movie.synopsis == "Sin sinopsis disponible.")
        #expect(movie.originalTitle == "Sin datos")
        #expect(movie.posterURL == nil)
    }

    @Test
    func emptyResultsDecodeToAnEmptyList() throws {
        // Arrange
        let json = #"{ "page": 1, "total_pages": 1, "results": [] }"#

        // Act
        let response = try decode(json)

        // Assert
        #expect(response.results.isEmpty)
    }

    @Test
    func invalidJSONThrowsAnError() {
        // Arrange: falta "results"
        let json = #"{ "page": 1 }"#

        // Act + Assert
        #expect(throws: DecodingError.self) {
            try decode(json)
        }
    }
}
