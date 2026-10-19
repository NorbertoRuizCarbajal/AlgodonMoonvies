import SwiftUI

/// Pestaña "Recomendado": la mejor valorada + top de la semana.
struct RecommendedTabView: View {
    private let movies = MockMovies().all

    private var bestRatedMovie: Movie? {
        movies.max { $0.rating < $1.rating }
    }

    private var weeklyTop: [Movie] {
        Array(movies.sorted { $0.rating > $1.rating }.prefix(8))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            if let bestRatedMovie {
                VStack(alignment: .leading, spacing: 12) {
                    SectionTitleView(title: "Mejor valorada hoy")
                    HeroBannerView(movie: bestRatedMovie)
                }
            }

            MovieRowView(title: "Top de la semana", movies: weeklyTop)
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            RecommendedTabView()
        }
    }
}
