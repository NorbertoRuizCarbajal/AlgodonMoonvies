import SwiftUI

/// Cuadrícula de películas, o un mensaje si la lista está vacía
/// Se usa en las pestañas Todo, Favoritos y Por ver
struct MovieListTabView: View {
    let movies: [Movie]
    let emptyTitle: String

    var body: some View {
        if movies.isEmpty {
            MessageView(title: emptyTitle)
        } else {
            MovieGridView(movies: movies)
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            MovieListTabView(movies: Movie.samples, emptyTitle: "Aún no hay películas")
        }
    }
}
