import SwiftUI

/// Póster grande con el ícono de Play al centro.
struct PosterHeroView: View {
    let movie: Movie

    var body: some View {
        ZStack {
            PosterView(movie: movie, width: nil, height: 220, showsTitle: false)

            Image(systemName: "play.fill")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .frame(width: 76, height: 76)
                .background(Color.black.opacity(0.35))
                .clipShape(Circle())
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Póster de \(movie.title)")
    }
}

#Preview {
    PosterHeroView(movie: MockMovies().all[17])
        .padding()
}
