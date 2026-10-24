import SwiftUI

/// Pantalla Buscar. El filtrado lo hace `SearchViewModel`; la vista solo lo muestra.
struct SearchView: View {
    @State private var viewModel: SearchViewModel

    @Environment(\.dismiss) private var dismiss

    init(viewModel: SearchViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            SearchHeaderView(text: $viewModel.query) {
                dismiss()
            }

            ScrollView {
                SearchResultsView(result: viewModel.result) {
                    viewModel.clearSearch()
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
        SearchView(viewModel: SearchViewModel(moviesStore: .preview()))
    }
}
