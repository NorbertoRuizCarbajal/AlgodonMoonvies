import SwiftUI

// iconos posters

struct PosterView: View {
    let movie: Movie
    let width: CGFloat?
    let height: CGFloat
    let showsTitle: Bool

    var body: some View {
        ZStack {
            Color(hue: movie.posterHue, saturation: 0.6, brightness: 0.75)

            Image(systemName: movie.posterSymbol)
                .font(.system(size: height * 0.3))
                .foregroundStyle(Color.white.opacity(0.35))

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
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme().cornerRadius))
    }
}

#Preview {
    PosterView(movie: MockMovies().all[0], width: 140, height: 210, showsTitle: true)
}
