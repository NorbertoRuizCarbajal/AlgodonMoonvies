import SwiftUI

/// Las acciones del detalle: favoritos y Por ver
struct ActionsBarView: View {
    let isFavorite: Bool
    let isInWatchlist: Bool
    let onFavorite: () -> Void
    let onWatchlist: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // El texto cambia junto con el color, así no dependemos solo del rojo
            ActionButtonView(
                iconName: isFavorite ? "heart.fill" : "heart",
                title: isFavorite ? "En favoritos" : "Agregar a favoritos",
                iconColor: isFavorite ? AppTheme().favorite : .primary,
                action: onFavorite
            )
            .accessibilityAddTraits(isFavorite ? .isSelected : [])

            ActionButtonView(
                iconName: isInWatchlist ? "bookmark.fill" : "bookmark",
                title: isInWatchlist ? "En Por ver" : "Agregar a Por ver",
                iconColor: isInWatchlist ? AppTheme().accent : .primary,
                action: onWatchlist
            )
            .accessibilityAddTraits(isInWatchlist ? .isSelected : [])
        }
    }
}

/// Un ícono con su texto abajo. Se reutiliza para cada acción (composición)
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
    ActionsBarView(isFavorite: true, isInWatchlist: false, onFavorite: {}, onWatchlist: {})
        .padding()
}
