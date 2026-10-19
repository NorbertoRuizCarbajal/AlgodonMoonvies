import SwiftUI

/// Ícono dentro de un círculo blanco (perfil, ajustes, notificaciones, regresar).
/// Solo dibuja el círculo: cada pantalla decide si lo envuelve en un botón.
struct CircleIconView: View {
    let systemName: String
    let showsBadge: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: systemName)
                .font(.headline)
                .foregroundStyle(.black)
                .frame(width: 44, height: 44)
                .background(.white)
                .clipShape(Circle())

            if showsBadge {
                AppTheme().badge
                    .frame(width: 10, height: 10)
                    .clipShape(Circle())
                    .padding(8)
            }
        }
    }
}

#Preview {
    CircleIconView(systemName: "bell", showsBadge: true)
        .padding()
        .background(AppTheme().header)
}
