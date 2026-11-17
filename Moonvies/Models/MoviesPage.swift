import Foundation

/// Una página del catálogo de TMDB
struct MoviesPage: Equatable {
    let movies: [Movie]
    let page: Int
    let totalPages: Int
}
