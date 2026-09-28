import SwiftUI


struct RecommendedTabView: View {
    @Environment(MoviesViewModel.self) private var moviesViewModel
    @Environment(FeedbackCenter.self) private var feedbackCenter

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            if let movie = moviesViewModel.topRatedToday {
                VStack(alignment: .leading, spacing: 12) {
                    SectionTitleView(title: "Mejor valorada hoy", subtitle: "Cambia cada día")

                    HeroBannerView(
                        movie: movie,
                        onOpen: { feedbackCenter.showComingSoon("El detalle") },
                        onPlay: { feedbackCenter.showPlaybackDemo(for: movie) }
                    )
                }
            }

            MovieRowView(title: "Top de la semana", movies: moviesViewModel.weeklyTop) { _ in
                feedbackCenter.showComingSoon("El detalle")
            }
        }
    }
}

#Preview {
    ScrollView {
        RecommendedTabView()
    }
    .previewEnvironment()
}
