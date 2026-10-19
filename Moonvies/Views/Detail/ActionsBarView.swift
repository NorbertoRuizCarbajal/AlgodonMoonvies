import SwiftUI

/// Los 3 íconos del detalle: favoritos, calificar y descargar.
struct ActionsBarView: View {
    let isFavorite: Bool
    let onFavorite: () -> Void
    let onRate: () -> Void
    let onDownload: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // El texto cambia junto con el color, así no dependemos solo del rojo.
            ActionButtonView(
                iconName: isFavorite ? "heart.fill" : "heart",
                title: isFavorite ? "En favoritos" : "Agregar a favoritos",
                iconColor: isFavorite ? AppTheme().favorite : .primary,
                action: onFavorite
            )
            .accessibilityAddTraits(isFavorite ? .isSelected : [])

            ActionButtonView(
                iconName: "hand.thumbsup",
                title: "Calificar",
                iconColor: .primary,
                action: onRate
            )

            ActionButtonView(
                iconName: "arrow.down.circle",
                title: "Descargar",
                iconColor: .primary,
                action: onDownload
            )
        }
    }
}

/// Un ícono con su texto abajo. Se reutiliza 3 veces (composición).
struct ActionButtonView: View {
    let iconName: String
    let title: String
    let iconColor: Color
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundStyle(iconColor)
                    .frame(width: 56, height: 56)
                    .background(AppTheme().accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    ActionsBarView(isFavorite: true, onFavorite: {}, onRate: {}, onDownload: {})
        .padding()
}
