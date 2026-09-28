import SwiftUI


struct HomeHeaderView: View {
    let showsNotificationBadge: Bool
    let onSearchTap: () -> Void
   
    let onIconTap: (String) -> Void

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                MoonviesLogoView()

                HStack(spacing: 10) {
                    CircleIconButton(systemName: "person.fill", accessibilityText: "Perfil") {
                        onIconTap("Tu perfil")
                    }

                    Spacer()

                    CircleIconButton(systemName: "slider.vertical.3", accessibilityText: "Ajustes") {
                        onIconTap("Ajustes")
                    }

                    CircleIconButton(
                        systemName: "bell",
                        accessibilityText: "Notificaciones",
                        showsBadge: showsNotificationBadge
                    ) {
                        onIconTap("Notificaciones")
                    }
                }
            }

            SearchBarButton(action: onSearchTap)
        }
        .headerStyle()
    }
}

struct MoonviesLogoView: View {
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "moon.stars.fill")
            Text("Moonvies")
                .font(.title2)
                .bold()
        }
        .foregroundStyle(.black)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

/// No es un TextField: es un botón con forma de barra.
/// En la siguiente entrega abrirá la pantalla Buscar.
struct SearchBarButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                Text("Buscar películas...")
                Spacer()
            }
            .foregroundStyle(.gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .accessibilityLabel("Buscar películas")
        .accessibilityHint("Abre el buscador")
    }
}

#Preview {
    HomeHeaderView(showsNotificationBadge: true, onSearchTap: {}, onIconTap: { _ in })
}
