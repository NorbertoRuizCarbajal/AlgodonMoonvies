import SwiftUI

/// Pestaña "Recomendado": la mejor valorada del día + top de la semana.
/// Ya no ordena ni elige películas: recibe los datos listos del ViewModel.
struct RecommendedTabView: View {
    let bestRatedMovie: Movie?
    let weeklyTop: [Movie]

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
            RecommendedTabView(
                bestRatedMovie: MockMovies().all[2],
                weeklyTop: MockMovies().all
            )
        }
    }
}
