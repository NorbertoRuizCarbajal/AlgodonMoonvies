import SwiftUI

/// Fecha de estreno, estrellas y sinopsis
struct MovieInfoView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(movie.releaseDateText, systemImage: "calendar")
                .font(.headline)
                .accessibilityLabel("Estreno: \(movie.releaseDateText)")

            HStack(spacing: 8) {
                StarsView(rating: movie.rating)

                Text(ratingDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }

            Text("Sinopsis")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            Text(movie.synopsis)
                .font(.body)
        }
    }

    private var ratingDescription: String {
        movie.rating > 0 ? "\(movie.ratingText) / 5 en TMDB" : "Sin calificaciones en TMDB"
    }
}

#Preview {
    MovieInfoView(movie: .sample)
        .padding()
}
