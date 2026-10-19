import SwiftUI

/// Detalle de una película. Recibe la película por la navegación (`Route.detail`)
/// y lee/modifica los favoritos compartidos.
struct MovieDetailView: View {
    let movie: Movie
    /// "Regresar a Home": lo resuelve `RootView` vaciando la pila.
    let onGoHome: () -> Void

    @Environment(FavoritesStore.self) private var favoritesStore
    @Environment(\.dismiss) private var dismiss

    /// Estado local: el aviso solo existe en esta pantalla.
    @State private var message: FeedbackMessage?

    private var suggestions: [Movie] {
        let otherMovies = MockMovies().all.filter { $0.id != movie.id }
        return Array(otherMovies.sorted { $0.rating > $1.rating }.prefix(6))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 16) {
                DetailHeaderView(
                    title: movie.title,
                    onBack: { dismiss() },
                    onGoHome: onGoHome
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        VStack(alignment: .leading, spacing: 20) {
                            PosterHeroView(movie: movie)

                            MovieInfoView(movie: movie)

                            WatchNowButton {
                                showMessage("La reproducción estará disponible pronto", isError: false)
                            }

                            ActionsBarView(
                                isFavorite: favoritesStore.isFavorite(movie),
                                onFavorite: toggleFavorite,
                                onRate: { showMessage("Calificar estará disponible pronto", isError: false) },
                                onDownload: { showMessage("Descargar estará disponible pronto", isError: false) }
                            )
                        }
                        .padding(.horizontal, AppTheme().screenPadding)

                        MovieRowView(title: "Sugerencias", movies: suggestions)
                    }
                    .padding(.bottom, 32)
                }
            }

            if let message {
                FeedbackBannerView(message: message)
                    .padding(.horizontal, AppTheme().screenPadding)
                    .padding(.bottom, 16)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Favoritos (sub-flujo del diagrama)

    /// Tocar "Agregar a favoritos" → ¿Se agregó?
    ///   Sí → corazón rojo + "Agregada a favoritos"
    ///   No → mensaje de error
    private func toggleFavorite() {
        guard !favoritesStore.isFavorite(movie) else {
            favoritesStore.remove(movie)
            showMessage("Eliminada de favoritos", isError: false)
            return
        }

        do {
            try favoritesStore.add(movie)
            showMessage("Agregada a favoritos", isError: false)
        } catch let favoriteError as FavoriteError {
            showMessage(favoriteError.message, isError: true)
        } catch {
            showMessage("No se pudo agregar a favoritos.", isError: true)
        }
    }

    // MARK: - Avisos

    private func showMessage(_ text: String, isError: Bool) {
        let newMessage = FeedbackMessage(text: text, isError: isError)
        message = newMessage

        Task {
            try? await Task.sleep(for: .seconds(2.5))

            // Si mientras tanto llegó otro aviso, ese no se toca.
            guard message?.id == newMessage.id else { return }
            message = nil
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(movie: MockMovies().all[17], onGoHome: {})
    }
    .environment(FavoritesStore())
}
