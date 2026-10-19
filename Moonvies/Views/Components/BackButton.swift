import SwiftUI

/// Botón circular de regresar. Antes estaba repetido igual en Buscar y en Detalle.
struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            CircleIconView(systemName: "arrow.left", showsBadge: false)
        }
        .accessibilityLabel("Regresar")
        .accessibilityHint("Vuelve a la pantalla anterior")
    }
}

#Preview {
    BackButton {}
        .padding()
        .background(AppTheme().header)
}
