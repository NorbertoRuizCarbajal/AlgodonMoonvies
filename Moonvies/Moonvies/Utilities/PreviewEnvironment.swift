import SwiftUI

extension View {
    
    func previewEnvironment() -> some View {
        let moviesViewModel = MoviesViewModel(repository: MockMovieRepository(shouldFail: false))

        return self
            .environment(moviesViewModel)
            .environment(FeedbackCenter())
            .onAppear {
                Task {
                    await moviesViewModel.loadMovies()
                }
            }
    }
}
