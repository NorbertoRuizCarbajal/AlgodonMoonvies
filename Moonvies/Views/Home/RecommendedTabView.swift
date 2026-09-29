import SwiftUI

struct RecommendedTabView: View {
    private let movies = MockMovies().all

    private var bestRatedMovie: Movie? {
        movies.max { $0.rating < $1.rating }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            if let bestRatedMovie {
                VStack(alignment: .leading, spacing: 12) {
                    SectionTitleView(title: "Mejor valorada hoy")
                    HeroBannerView(movie: bestRatedMovie)
                }
            }

            MovieRowView(title: "Top de la semana", movies: movies)
        }
    }
}

#Preview {
    ScrollView {
        RecommendedTabView()
    }
}
