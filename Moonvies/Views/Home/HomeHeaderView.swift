import SwiftUI

/// Header cian de Home: logo, notificaciones y barra de búsqueda
struct HomeHeaderView: View {
    /// Recordatorios pendientes; se muestra como número rojo sobre la campana
    let remindersCount: Int

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                MoonviesLogoView()

                HStack {
                    Spacer()
                    NotificationsButtonView(remindersCount: remindersCount)
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

/// Campana que abre la pantalla Notificaciones
struct NotificationsButtonView: View {
    let remindersCount: Int

    private var accessibilityText: String {
        switch remindersCount {
        case 0:
            return "Notificaciones, sin recordatorios"
        case 1:
            return "Notificaciones, 1 recordatorio"
        default:
            return "Notificaciones, \(remindersCount) recordatorios"
        }
    }

    var body: some View {
        NavigationLink(value: Route.notifications) {
            CircleIconView(systemName: remindersCount > 0 ? "bell.badge" : "bell")
                .overlay(alignment: .topTrailing) {
                    if remindersCount > 0 {
                        Text("\(remindersCount)")
                            .font(.caption2)
                            .bold()
                            .foregroundStyle(.white)
                            .frame(minWidth: 18, minHeight: 18)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 4, y: -4)
                    }
                }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
        .accessibilityHint("Abre tus recordatorios de Por ver")
        .accessibilityAddTraits(.isButton)
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
        HomeHeaderView(remindersCount: 2)
    }
}
