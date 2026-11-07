import Foundation
@testable import Moonvies

/// Películas de prueba con calificaciones distintas para poder comprobar el orden
@MainActor
enum TestMovies {

    static var interstellar: Movie { movie(id: "interestelar", title: "Interestelar", originalTitle: "Interstellar", rating: 4.6) }
    static var inception: Movie { movie(id: "inception", title: "El origen", originalTitle: "Inception", rating: 4.7) }
    static var parasite: Movie { movie(id: "parasitos", title: "Parásitos", originalTitle: "Parasite", rating: 4.8) }
    static var coco: Movie { movie(id: "coco", title: "Coco", originalTitle: "Coco", rating: 4.5) }
    static var roma: Movie { movie(id: "roma", title: "Roma", originalTitle: "Roma", rating: 4.3) }
    static var faultInOurStars: Movie { movie(id: "bajo-la-misma-estrella", title: "Bajo la misma estrella", originalTitle: "The Fault in Our Stars", rating: 4.0) }
    static var eightBelow: Movie { movie(id: "bajo-cero", title: "Bajo cero", originalTitle: "Eight Below", rating: 3.9) }
    static var spongeBob: Movie { movie(id: "bob-esponja", title: "Bob Esponja: La película", originalTitle: "The SpongeBob SquarePants Movie", rating: 3.8) }

    static var all: [Movie] {
        [interstellar, inception, parasite, coco, roma, faultInOurStars, eightBelow, spongeBob]
    }

    static func movie(
        id: String,
        title: String,
        originalTitle: String = "",
        rating: Double = 4.0
    ) -> Movie {
        Movie(
            id: id,
            title: title,
            originalTitle: originalTitle,
            year: "2020",
            rating: rating,
            synopsis: "Sinopsis de prueba"
        )
    }
}
