import SwiftUI

/// Año, estrellas y sinopsis
struct MovieInfoView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(movie.year)
                .font(.headline)
                .accessibilityLabel("Estreno \(movie.year)")

            StarsView(rating: movie.rating)

            Text(movie.synopsis)
                .font(.body)
        }
    }
}

#Preview {
    MovieInfoView(movie: MockMovies().all[17])
        .padding()
}
