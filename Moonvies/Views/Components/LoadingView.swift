import SwiftUI

/// Indicador de carga con texto
struct LoadingView: View {
    let title: String

    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .controlSize(.large)

            Text(title)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppTheme().screenPadding)
        .padding(.top, 80)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    LoadingView(title: "Cargando películas...")
}
