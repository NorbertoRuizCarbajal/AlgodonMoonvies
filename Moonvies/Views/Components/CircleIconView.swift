import SwiftUI

/// Ícono dentro de un círculo blanco (ajustes, regresar, inicio)
/// Solo dibuja el círculo: cada pantalla decide si lo envuelve en un botón
struct CircleIconView: View {
    let systemName: String

    var body: some View {
        Image(systemName: systemName)
            .font(.headline)
            .foregroundStyle(.black)
            .frame(width: 44, height: 44)
            .background(.white)
            .clipShape(Circle())
    }
}

#Preview {
    CircleIconView(systemName: "slider.vertical.3")
        .padding()
        .background(AppTheme().header)
}
