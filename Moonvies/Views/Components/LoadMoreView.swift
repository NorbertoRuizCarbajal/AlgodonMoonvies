import SwiftUI

/// Pie de la pestaña Todo: botón para pedir la siguiente página
struct LoadMoreView: View {
    let isLoading: Bool
    let errorMessage: String?
    let onLoadMore: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            if let errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if isLoading {
                ProgressView()
            } else {
                Button {
                    onLoadMore()
                } label: {
                    Text(errorMessage == nil ? "Cargar más" : "Reintentar")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppTheme().accent)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .padding(.horizontal, AppTheme().screenPadding)
    }
}

#Preview {
    LoadMoreView(isLoading: false, errorMessage: nil, onLoadMore: {})
}
