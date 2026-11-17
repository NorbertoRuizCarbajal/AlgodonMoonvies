import Foundation
import SwiftData

/// Favorito guardado en el dispositivo con SwiftData
/// Guarda la película completa porque el catálogo de TMDB cambia cada día
@Model
final class FavoriteMovie {
    var movieID: String
    var addedAt: Date
    // Los valores por defecto permiten migrar favoritos guardados con el esquema anterior
    var title: String = ""
    var originalTitle: String = ""
    var year: String = ""
    var releaseDate: String = ""
    var rating: Double = 0
    var synopsis: String = ""
    var posterPath: String?

    init(movie: Movie, addedAt: Date) {
        self.movieID = movie.id
        self.addedAt = addedAt
        self.title = movie.title
        self.originalTitle = movie.originalTitle
        self.year = movie.year
        self.releaseDate = movie.releaseDate
        self.rating = movie.rating
        self.synopsis = movie.synopsis
        self.posterPath = movie.posterPath
    }

    var movie: Movie {
        Movie(
            id: movieID,
            title: title,
            originalTitle: originalTitle,
            year: year,
            releaseDate: releaseDate,
            rating: rating,
            synopsis: synopsis,
            posterPath: posterPath
        )
    }
}
