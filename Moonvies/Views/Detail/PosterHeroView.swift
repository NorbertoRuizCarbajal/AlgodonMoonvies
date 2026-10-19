import SwiftUI

/// Póster grande de la película en el detalle.
struct PosterHeroView: View {
    let movie: Movie

    var body: some View {
        PosterView(movie: movie, width: nil, height: 220, showsTitle: false)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Póster de \(movie.title)")
    }
}

#Preview {
    PosterHeroView(movie: MockMovies().all[17])
        .padding()
}
