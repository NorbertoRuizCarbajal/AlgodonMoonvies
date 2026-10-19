import SwiftUI

/// Resultado del rombo "¿Se encontraron resultados?" del diagrama de flujo.
enum SearchResult {
    /// El campo está vacío: se muestran las mejor calificadas.
    case popular([Movie])
    /// Sí se encontraron resultados.
    case found([Movie])
    /// No se encontraron resultados.
    case notFound
}

/// Pantalla Buscar. Filtra en tiempo real mientras escribes.
struct SearchView: View {
    /// Estado local: solo Buscar usa el texto. Como Buscar sigue en la pila
    /// mientras ves un detalle, el texto se conserva al regresar.
    @State private var query = ""

    @Environment(\.dismiss) private var dismiss

    private let movies = MockMovies().all

    /// No se guarda: se calcula cada vez a partir del texto.
    private var result: SearchResult {
        let cleanQuery = query.trimmingCharacters(in: .whitespaces)

        guard !cleanQuery.isEmpty else {
            let popularMovies = movies.sorted { $0.rating > $1.rating }
            return .popular(Array(popularMovies.prefix(6)))
        }

        let matchingMovies = movies.filter { $0.matches(cleanQuery) }

        guard !matchingMovies.isEmpty else {
            return .notFound
        }

        return .found(matchingMovies)
    }

    var body: some View {
        VStack(spacing: 16) {
            SearchHeaderView(text: $query) {
                dismiss()
            }

            ScrollView {
                SearchResultsView(result: result) {
                    query = ""
                }
                .padding(.bottom, 32)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

/// Muestra una cosa distinta para cada caso de `SearchResult`.
struct SearchResultsView: View {
    let result: SearchResult
    /// "Intentar nuevamente": regresa a Buscar limpiando el texto.
    let onRetry: () -> Void

    var body: some View {
        switch result {
        case .popular(let movies):
            VStack(alignment: .leading, spacing: 12) {
                SectionTitleView(title: "Populares en Moonvies")
                MovieGridView(movies: movies)
            }

        case .found(let movies):
            VStack(alignment: .leading, spacing: 12) {
                SectionTitleView(title: movies.count == 1 ? "1 resultado" : "\(movies.count) resultados")
                MovieGridView(movies: movies)
            }

        case .notFound:
            MessageView(
                title: "No se encontraron resultados",
                buttonTitle: "Intentar nuevamente",
                action: onRetry
            )
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
