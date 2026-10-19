import SwiftUI

/// Año, duración, estrellas, sinopsis y director.
struct MovieInfoView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(movie.year) | \(movie.formattedDuration)")
                .font(.headline)
                .accessibilityLabel("Estreno \(movie.year), duración \(movie.spokenDuration)")

            StarsView(rating: movie.rating)

            Text(movie.synopsis)
                .font(.body)

            Text("Dirección: \(movie.director)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    MovieInfoView(movie: MockMovies().all[17])
        .padding()
}
