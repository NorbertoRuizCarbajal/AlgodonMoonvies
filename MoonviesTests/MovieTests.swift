import Testing
@testable import Moonvies

/// Pruebas de las reglas del modelo `Movie`
@MainActor
struct MovieTests {

    private func movie(releaseDate: String) -> Movie {
        Movie(id: "1", title: "Coco", originalTitle: "Coco", year: "2017",
              releaseDate: releaseDate, rating: 4.1, synopsis: "", posterPath: nil)
    }

    @Test
    func releaseDateIsShownInSpanish() {
        #expect(movie(releaseDate: "2017-10-27").releaseDateText == "27 de octubre de 2017")
    }

    @Test(arguments: ["", "fecha-rara", "2017"])
    func invalidReleaseDateShowsAFriendlyText(releaseDate: String) {
        #expect(movie(releaseDate: releaseDate).releaseDateText == "Fecha de estreno no disponible")
    }

    @Test
    func ratingTextHasOneDecimal() {
        #expect(movie(releaseDate: "").ratingText == "4.1")
    }
}
