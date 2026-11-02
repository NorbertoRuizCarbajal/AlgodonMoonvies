import SwiftUI

/// Header cian de Home: logo, ajustes y barra de búsqueda
struct HomeHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                MoonviesLogoView()

                HStack {
                    Spacer()
                    CircleIconView(systemName: "slider.vertical.3")
                        .accessibilityLabel("Ajustes")
                }
            }

            // Diagrama: "Tocar barra de búsqueda" → Buscar
            NavigationLink(value: Route.search) {
                SearchBarView()
            }
            .accessibilityLabel("Buscar películas")
            .accessibilityHint("Abre el buscador")
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

/// Barra de búsqueda de Home. No es un TextField: solo abre la pantalla Buscar
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
    }
}

#Preview {
    NavigationStack {
        HomeHeaderView()
    }
}
