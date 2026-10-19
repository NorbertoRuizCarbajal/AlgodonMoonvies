import SwiftUI

/// Detalle de una película. Solo dibuja la pantalla y avisa al ViewModel
/// cuando el usuario toca algo; la lógica vive en `MovieDetailViewModel`.
struct MovieDetailView: View {
    @State private var viewModel: MovieDetailViewModel
    /// "Regresar a Home": lo resuelve `RootView` vaciando la pila.
    let onGoHome: () -> Void

    @Environment(\.dismiss) private var dismiss

    init(viewModel: MovieDetailViewModel, onGoHome: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onGoHome = onGoHome
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 16) {
                DetailHeaderView(
                    title: viewModel.movie.title,
                    onBack: { dismiss() },
                    onGoHome: onGoHome
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        VStack(alignment: .leading, spacing: 20) {
                            PosterHeroView(movie: viewModel.movie)

                            MovieInfoView(movie: viewModel.movie)

                            ActionsBarView(
                                isFavorite: viewModel.isFavorite,
                                onFavorite: { viewModel.toggleFavorite() },
                                onRate: { viewModel.showComingSoon("Calificar") }
                            )
                        }
                        .padding(.horizontal, AppTheme().screenPadding)

                        MovieRowView(title: "Sugerencias", movies: viewModel.suggestions)
                    }
                    .padding(.bottom, 32)
                }
            }

            if let message = viewModel.message {
                FeedbackBannerView(message: message)
                    .padding(.horizontal, AppTheme().screenPadding)
                    .padding(.bottom, 16)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(
            viewModel: MovieDetailViewModel(
                movie: MockMovies().all[17],
                moviesStore: .preview(),
                favoritesStore: FavoritesStore()
            ),
            onGoHome: {}
        )
    }
}
