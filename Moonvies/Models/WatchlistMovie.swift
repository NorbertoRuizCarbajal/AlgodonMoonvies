import Foundation
import SwiftData

/// Película guardada en "Por ver"
/// Guarda la película completa porque el catálogo de TMDB cambia cada día
@Model
final class WatchlistMovie {
    var movieID: String
    var title: String
    var originalTitle: String
    var year: String
    /// Valor por defecto para migrar lo guardado con el esquema anterior
    var releaseDate: String = ""
    var rating: Double
    var synopsis: String
    var posterPath: String?
    var addedAt: Date

    init(movie: Movie, addedAt: Date) {
        self.movieID = movie.id
        self.title = movie.title
        self.originalTitle = movie.originalTitle
        self.year = movie.year
        self.releaseDate = movie.releaseDate
        self.rating = movie.rating
        self.synopsis = movie.synopsis
        self.posterPath = movie.posterPath
        self.addedAt = addedAt
    }

    var item: WatchlistItem {
        WatchlistItem(movie: movie, addedAt: addedAt)
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
