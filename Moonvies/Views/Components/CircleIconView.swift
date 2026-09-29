import SwiftUI

struct CircleIconView: View {
    let systemName: String
    let accessibilityText: String
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }
}

#Preview {
    CircleIconView(systemName: "bell", accessibilityText: "Notificaciones", showsBadge: true)
        .padding()
        .background(AppTheme().header)
}
