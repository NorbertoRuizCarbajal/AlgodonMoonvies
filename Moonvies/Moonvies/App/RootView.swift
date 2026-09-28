import SwiftUI

/// Muestra Home 
struct RootView: View {
    @Environment(MoviesViewModel.self) private var moviesViewModel
    @Environment(FeedbackCenter.self) private var feedbackCenter

    var body: some View {
        ZStack(alignment: .bottom) {
            HomeView()

            if let message = feedbackCenter.currentMessage {
                FeedbackBannerView(message: message)
                    .padding(.horizontal, AppTheme().screenPadding)
                    .padding(.bottom, 16)
            }
        }
        .onAppear {
            Task {
                await moviesViewModel.loadMovies()
            }
        }
    }
}

#Preview {
    RootView()
        .previewEnvironment()
}
