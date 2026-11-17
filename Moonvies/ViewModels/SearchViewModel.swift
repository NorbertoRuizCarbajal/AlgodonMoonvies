import Foundation
import Observation

/// Lógica de la pantalla Buscar
/// - Campo vacío: muestra las mejor calificadas del catálogo
/// - Con texto: busca en TMDB y decide si hay resultados, no hay o hubo un error
@MainActor
@Observable
final class SearchViewModel {
    /// Texto escrito por el usuario. Se conserva al ir al detalle y regresar
    var query = ""

    /// Resultado de la última búsqueda en TMDB
    private(set) var searchResult: SearchResult = .searching

    private let moviesStore: MoviesStore
    /// Espera antes de llamar a la API, para no hacer una solicitud por cada letra
    private let typingDelay: Duration

    init(moviesStore: MoviesStore, typingDelay: Duration = .milliseconds(400)) {
        self.moviesStore = moviesStore
        self.typingDelay = typingDelay
    }

    var loadState: LoadState {
        moviesStore.state
    }

    var cleanQuery: String {
        query.trimmingCharacters(in: .whitespaces)
    }

    /// Lo que debe mostrar la pantalla
    var result: SearchResult {
        guard !cleanQuery.isEmpty else {
            let popularMovies = moviesStore.movies.sorted { $0.rating > $1.rating }
            return .popular(Array(popularMovies.prefix(6)))
        }

        return searchResult
    }

    /// Controla la llamada al servicio: buscando → resultados, sin resultados o error
    /// La vista la llama cada vez que cambia el texto con `.task(id:)`,
    /// que cancela la búsqueda anterior si el usuario sigue escribiendo
    func search() async {
        let text = cleanQuery
        guard !text.isEmpty else { return }

        searchResult = .searching

        try? await Task.sleep(for: typingDelay)
        guard !Task.isCancelled else { return }

        do {
            let movies = try await moviesStore.searchMovies(query: text)
            guard !Task.isCancelled else { return }

            searchResult = movies.isEmpty ? .notFound : .found(movies)
        } catch let movieError as MovieError {
            // Si se canceló porque el usuario siguió escribiendo, no es un error real
            guard !Task.isCancelled else { return }
            searchResult = .error(movieError)
        } catch {
            guard !Task.isCancelled else { return }
            searchResult = .error(.loadFailed)
        }
    }

    func retryLoading() async {
        await moviesStore.loadMovies()
    }

    /// "Intentar nuevamente": regresa al estado inicial de Buscar
    func clearSearch() {
        query = ""
    }
}
