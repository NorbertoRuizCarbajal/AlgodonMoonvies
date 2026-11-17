import SwiftUI

/// Muestra Loading, Empty o Error según el estado; en Content dibuja `content`
/// Lo comparten Home y Buscar para no repetir el mismo `switch`
struct LoadStateView<Content: View>: View {
    let state: LoadState
    let onRetry: () -> Void
    let content: () -> Content

    init(state: LoadState, onRetry: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.state = state
        self.onRetry = onRetry
        self.content = content
    }

    var body: some View {
        switch state {
        case .idle, .loading:
            LoadingView(title: "Cargando películas...")

        case .empty:
            MessageView(title: "No hay películas para mostrar por ahora.", buttonTitle: "Actualizar", action: onRetry)

        case .error(let movieError):
            MessageView(title: movieError.message, buttonTitle: "Reintentar", action: onRetry)

        case .loaded:
            content()
        }
    }
}

#Preview {
    LoadStateView(state: .error(.noConnection), onRetry: {}) {
        Text("Contenido")
    }
}
