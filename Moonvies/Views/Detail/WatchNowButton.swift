import SwiftUI

/// Botón azul ancho "Ver ahora".
struct WatchNowButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text("Ver ahora")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppTheme().accent)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .accessibilityHint("Reproduce la película")
    }
}

#Preview {
    WatchNowButton {}
        .padding()
}
