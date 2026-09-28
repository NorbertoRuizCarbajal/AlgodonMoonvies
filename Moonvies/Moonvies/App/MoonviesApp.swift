import SwiftUI

@main
struct MoonviesApp: App {
    
    @State private var moviesViewModel = MoviesViewModel(repository: MockMovieRepository(shouldFail: false))
    @State private var feedbackCenter = FeedbackCenter()

    var body: some Scene {
    WindowGroup {
    RootView()
        .environment(moviesViewModel)
        .environment(feedbackCenter)
        }
    }
}
