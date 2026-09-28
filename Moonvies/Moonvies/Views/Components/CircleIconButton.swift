import SwiftUI


struct CircleIconButton: View {
    let systemName: String
    let accessibilityText: String
    let showsBadge: Bool
    let action: () -> Void

    private let theme = AppTheme()

    init(
        systemName: String,
        accessibilityText: String,
        showsBadge: Bool = false,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.accessibilityText = accessibilityText
        self.showsBadge = showsBadge
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: systemName)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(width: 44, height: 44)
                    .background(.white)
                    .clipShape(Circle())

                if showsBadge {
                    theme.badge
                        .frame(width: 10, height: 10)
                        .clipShape(Circle())
                        .padding(8)
                }
            }
        }
        .accessibilityLabel(accessibilityText)
    }
}

#Preview {
    HStack {
        CircleIconButton(systemName: "arrow.left", accessibilityText: "Regresar") {}
        CircleIconButton(systemName: "bell", accessibilityText: "Notificaciones", showsBadge: true) {}
    }
    .padding()
    .background(AppTheme().header)
}
