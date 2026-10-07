import SwiftUI

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
                        PosterView(
                            movie: movie,
                            width: posterWidth,
                            height: posterWidth * 1.5,
                            showsTitle: true
                        )
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(movie.title), \(movie.year)")
                    }
                }
                .padding(.horizontal, AppTheme().screenPadding)
            }
        }
    }
}

#Preview {
    MovieRowView(title: "Top de la semana", movies: MockMovies().all)
}
