import SwiftUI

struct HomeHeaderView: View {
    private let theme = AppTheme()

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                MoonviesLogoView()

                HStack(spacing: 10) {
                    CircleIconView(systemName: "person.fill", accessibilityText: "Perfil", showsBadge: false)
                    Spacer()
                    CircleIconView(systemName: "slider.vertical.3", accessibilityText: "Ajustes", showsBadge: false)
                    CircleIconView(systemName: "bell", accessibilityText: "Notificaciones", showsBadge: true)
                }
            }

            SearchBarView()
        }
        .padding(theme.screenPadding)
        .background(theme.header)
        .clipShape(RoundedRectangle(cornerRadius: 36))
        .padding(.horizontal, 8)
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

// Barra de búsqueda
struct SearchBarView: View {
    var body: some View {
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
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    HomeHeaderView()
}
