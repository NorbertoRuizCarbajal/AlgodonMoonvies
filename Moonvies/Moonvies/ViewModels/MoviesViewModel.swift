import Foundation
import Observation

// Carga el catálogo y prepara las secciones de Home.
@Observable
class MoviesViewModel {
    private(set) var state: LoadState = .idle
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

   

    func loadMovies() async {
        state = .loading

        do {
            let movies = try await repository.fetchMovies()
            state = .loaded(movies)
        } catch let movieError as MovieError {
            state = .error(movieError)
        } catch {
            state = .error(.unknown)
        }
    }

   

    var movies: [Movie] {
        switch state {
        case .loaded(let movies):
            return movies
        case .idle, .loading, .error:
            return []
        }
    }

    //  5 mejor calificadas según el día
    var topRatedToday: Movie? {
        let bestMovies = Array(moviesSortedByRating().prefix(5))
        guard !bestMovies.isEmpty else { return nil }

        let dayOfMonth = Calendar.current.component(.day, from: Date())
        return bestMovies[dayOfMonth % bestMovies.count]
    }

    var weeklyTop: [Movie] {
        Array(moviesSortedByRating().prefix(8))
    }

    
   

    private func moviesSortedByRating() -> [Movie] {
        movies.sorted { $0.rating > $1.rating }
    }
}
