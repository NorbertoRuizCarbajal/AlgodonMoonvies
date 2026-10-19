import SwiftUI

/// Cuadrícula de 2 columnas hecha con VStack + HStack y la función genérica `makeRows`.
/// Se usa en Buscar y en la pestaña Favoritos.
struct MovieGridView: View {
    let movies: [Movie]

    private let columns = 2

    private var rows: [[Movie]] {
        makeRows(from: movies, columns: columns)
    }

    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<rows.count, id: \.self) { index in
                HStack(alignment: .top, spacing: 16) {
                    ForEach(rows[index]) { movie in
                        MovieGridItemView(movie: movie)
                    }

                    // Si la última fila tiene una sola película, este espacio la mantiene del mismo ancho.
                    if rows[index].count < columns {
                        Color.clear
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, AppTheme().screenPadding)
    }
}

/// Una celda de la cuadrícula: póster + título + año y duración.
struct MovieGridItemView: View {
    let movie: Movie

    var body: some View {
        NavigationLink(value: Route.detail(movie)) {
            VStack(alignment: .leading, spacing: 6) {
                PosterView(movie: movie, width: nil, height: 220, showsTitle: false)

                Text(movie.title)
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text("\(movie.year) | \(movie.formattedDuration)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(movie.title), \(movie.year), \(movie.spokenDuration)")
        .accessibilityHint("Toca dos veces para ver el detalle")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            MovieGridView(movies: MockMovies().all)
        }
    }
}
