import SwiftUI

/// Header del detalle: regresar, título de la película y botón para volver a Home.
struct DetailHeaderView: View {
    let title: String
    let onBack: () -> Void
    let onGoHome: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button {
                onBack()
            } label: {
                CircleIconView(systemName: "arrow.left", showsBadge: false)
            }
            .accessibilityLabel("Regresar")
            .accessibilityHint("Vuelve a la pantalla anterior")

            Text(title)
                .font(.title3)
                .bold()
                .foregroundStyle(.black)
                .lineLimit(2)
                .accessibilityAddTraits(.isHeader)

            Spacer()

            Button {
                onGoHome()
            } label: {
                CircleIconView(systemName: "house.fill", showsBadge: false)
            }
            .accessibilityLabel("Inicio")
            .accessibilityHint("Regresa a la pantalla principal")
        }
        .headerStyle()
    }
}

#Preview {
    DetailHeaderView(title: "Bob Esponja: La película", onBack: {}, onGoHome: {})
}
