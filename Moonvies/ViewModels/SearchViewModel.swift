import Foundation
import Observation

/// Lógica de la pantalla Buscar. Antes vivía completa dentro de `SearchView`.
@Observable
class SearchViewModel {
    /// Texto escrito por el usuario. Se conserva al ir al detalle y regresar.
    var query = ""

    private let moviesStore: MoviesStore

    init(moviesStore: MoviesStore) {
        self.moviesStore = moviesStore
    }

    /// No se guarda: se calcula cada vez a partir del texto, por eso filtra en tiempo real.
    var result: SearchResult {
        let cleanQuery = query.trimmingCharacters(in: .whitespaces)

        guard !cleanQuery.isEmpty else {
            let popularMovies = moviesStore.movies.sorted { $0.rating > $1.rating }
            return .popular(Array(popularMovies.prefix(6)))
        }

        let matchingMovies = moviesStore.movies.filter { $0.matches(cleanQuery) }

        guard !matchingMovies.isEmpty else {
            return .notFound
        }

        return .found(matchingMovies)
    }

    /// "Intentar nuevamente": regresa al estado inicial de Buscar.
    func clearSearch() {
        query = ""
    }
}
