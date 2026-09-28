import Foundation
import Observation

/// Muestra avisos cortos como y después los desvanece

@Observable
class FeedbackCenter {
    private(set) var currentMessage: FeedbackMessage?

    func show(_ text: String) {
        let message = FeedbackMessage(text: text)
        currentMessage = message

        Task {
            await hide(message)
        }
    }

    private func hide(_ message: FeedbackMessage) async {
        do {
            try await Task.sleep(for: .seconds(2.5))
        } catch {
            return
        }

        // Si mientras tanto llegó otro mensaje, ese no se toca.
        guard currentMessage?.id == message.id else { return }
        currentMessage = nil
    }
}



extension FeedbackCenter {
   
    func showPlaybackDemo(for movie: Movie) {
        show("Reproduciendo “\(movie.title)” (demo)")
    }

    func showComingSoon(_ feature: String) {
        show("\(feature) estará disponible pronto")
    }
}
