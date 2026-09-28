import SwiftUI

// Fila horizontal de top de la semana
struct MovieRowView: View {
    let title: String
    let movies: [Movie]
    let onSelect: (Movie) -> Void

    private let posterWidth: CGFloat = 120

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitleView(title: title)

            ScrollView(.horizontal) {
                HStack(spacing: 14) {
                    ForEach(movies) { movie in
                        Button {
                            onSelect(movie)
                        } label: {
                            PosterView(
                                movie: movie,
                                width: posterWidth,
                                height: posterWidth * 1.5,
                                showsTitle: true
                            )
                        }
                        .accessibilityLabel("\(movie.title), \(movie.year)")
                    }
                }
                .padding(.horizontal, AppTheme().screenPadding)
            }
        }
    }
}

#Preview {
    MovieRowView(title: "Top de la semana", movies: MockMovies().all) { _ in }
}
