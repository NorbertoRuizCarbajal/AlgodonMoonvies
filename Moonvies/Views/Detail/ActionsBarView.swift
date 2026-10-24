import SwiftUI

/// Las acciones del detalle: agregar a favoritos y calificar.
struct ActionsBarView: View {
    let isFavorite: Bool
    let onFavorite: () -> Void
    let onRate: () -> Void

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
        }
    }
}

/// Un ícono con su texto abajo. Se reutiliza para cada acción (composición).
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
    ActionsBarView(isFavorite: true, onFavorite: {}, onRate: {})
        .padding()
}
