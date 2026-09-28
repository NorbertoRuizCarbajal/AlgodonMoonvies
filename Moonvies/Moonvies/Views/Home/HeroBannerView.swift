import SwiftUI


struct HeroBannerView: View {
    let movie: Movie
    let onOpen: () -> Void
    let onPlay: () -> Void

    private let theme = AppTheme()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Button {
                onOpen()
            } label: {
                ZStack(alignment: .bottomLeading) {
                    PosterView(movie: movie, width: nil, height: 210, showsTitle: false)

                    // Oscurece el póster para que el texto blanco se lea bien.
                    Color.black
                        .opacity(0.3)
                        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .font(.title3)
                            .bold()
                            .lineLimit(2)

                        HStack(spacing: 6) {
                            StarsView(rating: movie.rating)
                            Text("\(movie.year) | \(movie.formattedDuration)")
                                .font(.caption)
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(16)
                    .padding(.trailing, 130) // espacio para el botón "VER AHORA"
                }
            }
            .accessibilityLabel("Mejor valorada hoy: \(movie.title), \(movie.year)")

            Button {
                onPlay()
            } label: {
                Text("VER AHORA")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(16)
            .accessibilityLabel("Ver ahora \(movie.title)")
        }
        .padding(.horizontal, theme.screenPadding)
    }
}

#Preview {
    HeroBannerView(movie: MockMovies().all[2], onOpen: {}, onPlay: {})
}
