import SwiftUI

/// Fila horizontal de pósters con scroll ("Top de la semana", "Sugerencias").
/// Cada póster navega al detalle con `NavigationLink(value:)`.
struct MovieRowView: View {
    let title: String
    let movies: [Movie]

    private let posterWidth: CGFloat = 120

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitleView(title: title)

            ScrollView(.horizontal) {
                HStack(spacing: 14) {
                    ForEach(movies) { movie in
                        NavigationLink(value: Route.detail(movie)) {
                            PosterView(
                                movie: movie,
                                width: posterWidth,
                                height: posterWidth * 1.5,
                                showsTitle: true
                            )
                        }
                        .accessibilityLabel("\(movie.title), \(movie.year)")
                        .accessibilityHint("Toca dos veces para ver el detalle")
                    }
                }
                .padding(.horizontal, AppTheme().screenPadding)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieRowView(title: "Top de la semana", movies: MockMovies().all)
    }
}
