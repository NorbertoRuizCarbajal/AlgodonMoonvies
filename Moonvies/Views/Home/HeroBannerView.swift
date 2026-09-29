import SwiftUI

struct HeroBannerView: View {
    let movie: Movie

    private let theme = AppTheme()

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PosterView(movie: movie, width: nil, height: 210, showsTitle: false)

            Color.black
                .opacity(0.3)

            HStack(alignment: .bottom) {
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

                Spacer()

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
        }
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius))
        .padding(.horizontal, theme.screenPadding)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    HeroBannerView(movie: MockMovies().all[0])
}
