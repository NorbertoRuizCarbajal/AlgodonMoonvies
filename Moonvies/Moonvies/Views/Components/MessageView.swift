import SwiftUI


struct MessageView: View {
    let iconName: String
    let title: String
    let message: String
    let buttonTitle: String?
    let action: (() -> Void)?

    init(
        iconName: String,
        title: String,
        message: String,
        buttonTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            Text(title)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if let buttonTitle, let action {
                PrimaryButton(title: buttonTitle, action: action)
                    .padding(.horizontal, 40)
                    .padding(.top, 8)
            }
        }
        .padding(.horizontal, AppTheme().screenPadding)
        .padding(.top, 60)
    }
}

#Preview {
    MessageView(
        iconName: "film.stack",
        title: "No se encontraron resultados",
        message: "No hay películas que coincidan con “Kuan”.",
        buttonTitle: "Intentar nuevamente"
    ) {}
}
