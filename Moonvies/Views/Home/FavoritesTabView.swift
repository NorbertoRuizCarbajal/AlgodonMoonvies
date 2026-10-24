import SwiftUI

/// Pestaña "Favoritos". Recibe las películas ya convertidas por el ViewModel.
struct FavoritesTabView: View {
    let movies: [Movie]

    var body: some View {
        if movies.isEmpty {
            MessageView(title: "Aún no hay favoritos")
        } else {
            MovieGridView(movies: movies)
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            FavoritesTabView(movies: Array(MockMovies().all.prefix(3)))
        }
    }
}
