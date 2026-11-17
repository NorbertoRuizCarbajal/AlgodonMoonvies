import SwiftUI

/// Pantalla Buscar. La búsqueda la hace `SearchViewModel`; la vista solo la muestra
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
                LoadStateView(state: viewModel.loadState, onRetry: retry) {
                    SearchResultsView(
                        result: viewModel.result,
                        onClear: { viewModel.clearSearch() },
                        onRetrySearch: retrySearch
                    )
                }
                .padding(.bottom, 32)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        // Cada vez que cambia el texto se busca de nuevo; la búsqueda anterior se cancela sola
        .task(id: viewModel.query) {
            await viewModel.search()
        }
    }

    private func retry() {
        Task {
            await viewModel.retryLoading()
        }
    }

    private func retrySearch() {
        Task {
            await viewModel.search()
        }
    }
}

/// Muestra una cosa distinta para cada caso de `SearchResult`
struct SearchResultsView: View {
    let result: SearchResult
    /// "Intentar nuevamente": regresa a Buscar limpiando el texto
    let onClear: () -> Void
    /// "Reintentar": vuelve a consultar TMDB con el mismo texto
    let onRetrySearch: () -> Void

    var body: some View {
        switch result {
        case .popular(let movies):
            VStack(alignment: .leading, spacing: 12) {
                SectionTitleView(title: "Populares en Moonvies")
                MovieGridView(movies: movies)
            }

        case .searching:
            LoadingView(title: "Buscando películas...")

        case .found(let movies):
            VStack(alignment: .leading, spacing: 12) {
                SectionTitleView(title: movies.count == 1 ? "1 resultado" : "\(movies.count) resultados")
                MovieGridView(movies: movies)
            }

        case .notFound:
            MessageView(
                title: "No se encontraron resultados",
                buttonTitle: "Intentar nuevamente",
                action: onClear
            )

        case .error(let movieError):
            MessageView(
                title: movieError.message,
                buttonTitle: "Reintentar",
                action: onRetrySearch
            )
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(viewModel: SearchViewModel(moviesStore: .preview()))
    }
}
