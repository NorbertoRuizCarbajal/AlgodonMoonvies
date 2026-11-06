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
          "results": [
            {
              "id": 550,
              "title": "El club de la pelea",
              "original_title": "Fight Club",
              "overview": "Un oficinista insomne conoce a un vendedor de jabón.",
              "release_date": "1999-10-15",
              "vote_average": 8.4
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
        #expect(movies[0].rating == 4.2)
    }

    @Test
    func usesDefaultsWhenOptionalFieldsAreMissing() throws {
        // Arrange: solo vienen los campos obligatorios
        let json = """
        { "results": [ { "id": 1, "title": "Sin datos" } ] }
        """

        // Act
        let movie = try decode(json).results[0].toMovie()

        // Assert
        #expect(movie.year == "s/f")
        #expect(movie.rating == 0)
        #expect(movie.synopsis == "Sin sinopsis disponible.")
        #expect(movie.originalTitle == "Sin datos")
    }

    @Test
    func emptyResultsDecodeToAnEmptyList() throws {
        // Arrange
        let json = #"{ "results": [] }"#

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
