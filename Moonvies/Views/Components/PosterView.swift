import SwiftUI

/// Póster de TMDB. Mientras carga o si falla, se dibuja un color con un ícono
/// Si `width` es `nil`, el póster toma el ancho que le dé la vista padre
struct PosterView: View {
    let movie: Movie
    let width: CGFloat?
    let height: CGFloat
    let showsTitle: Bool

    var body: some View {
        placeholder
            .overlay {
                AsyncImage(url: movie.posterURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    }
                }
            }
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme().cornerRadius))
    }

    private var placeholder: some View {
        ZStack {
            Color(hue: movie.posterHue, saturation: 0.6, brightness: 0.75)

            Image(systemName: movie.posterSymbol)
                .font(.system(size: height * 0.3))
                .foregroundStyle(Color.white.opacity(0.35))
                .accessibilityHidden(true)

            if showsTitle {
                VStack {
                    Spacer()
                    Text(movie.title)
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .shadow(radius: 3)
                        .padding(8)
                }
            }
        }
    }
}

#Preview {
    PosterView(movie: .sample, width: 140, height: 210, showsTitle: true)
}
