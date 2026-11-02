import Foundation
@testable import Moonvies

/// Películas de prueba con calificaciones distintas para poder comprobar el orden
@MainActor
enum TestMovies {

    static var interstellar: Movie { movie(id: "interestelar", title: "Interestelar", originalTitle: "Interstellar", rating: 4.6, director: "Christopher Nolan") }
    static var inception: Movie { movie(id: "inception", title: "El origen", originalTitle: "Inception", rating: 4.7, director: "Christopher Nolan") }
    static var parasite: Movie { movie(id: "parasitos", title: "Parásitos", originalTitle: "Parasite", rating: 4.8, director: "Bong Joon-ho") }
    static var coco: Movie { movie(id: "coco", title: "Coco", originalTitle: "Coco", rating: 4.5, director: "Lee Unkrich") }
    static var roma: Movie { movie(id: "roma", title: "Roma", originalTitle: "Roma", rating: 4.3, director: "Alfonso Cuarón") }
    static var faultInOurStars: Movie { movie(id: "bajo-la-misma-estrella", title: "Bajo la misma estrella", originalTitle: "The Fault in Our Stars", rating: 4.0, director: "Josh Boone") }
    static var eightBelow: Movie { movie(id: "bajo-cero", title: "Bajo cero", originalTitle: "Eight Below", rating: 3.9, director: "Frank Marshall") }
    static var spongeBob: Movie { movie(id: "bob-esponja", title: "Bob Esponja: La película", originalTitle: "The SpongeBob SquarePants Movie", rating: 3.8, director: "Stephen Hillenburg") }

    static var all: [Movie] {
        [interstellar, inception, parasite, coco, roma, faultInOurStars, eightBelow, spongeBob]
    }

    static func movie(
        id: String,
        title: String,
        originalTitle: String = "",
        rating: Double = 4.0,
        director: String = "Director de prueba"
    ) -> Movie {
        Movie(
            id: id,
            title: title,
            originalTitle: originalTitle,
            year: "2020",
            durationMinutes: 120,
            rating: rating,
            director: director,
            synopsis: "Sinopsis de prueba",
            posterHue: 0.5,
            posterSymbol: "film"
        )
    }
}
