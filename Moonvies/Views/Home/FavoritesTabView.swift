import SwiftUI

/// Pestaña "Favoritos".
/// Lee el MISMO `FavoritesStore` que modifica el detalle, así que se actualiza sola.
struct FavoritesTabView: View {
    @Environment(FavoritesStore.self) private var favoritesStore

    private let movies = MockMovies().all

    /// Convierte los identificadores guardados en películas, respetando su orden.
    private var favoriteMovies: [Movie] {
        var result: [Movie] = []

        for id in favoritesStore.favoriteIDs {
            guard let movie = movies.first(where: { $0.id == id }) else {
                continue
            }
            result.append(movie)
        }

        return result
    }

    var body: some View {
        if favoriteMovies.isEmpty {
            MessageView(title: "Aún no hay favoritos")
        } else {
            MovieGridView(movies: favoriteMovies)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesTabView()
    }
    .environment(FavoritesStore())
}
