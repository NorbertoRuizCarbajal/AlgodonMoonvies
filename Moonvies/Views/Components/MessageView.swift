import SwiftUI

/// Mensaje centrado, con botón opcional.
/// Se usa para "Aún no hay favoritos" y "No se encontraron resultados".
struct MessageView: View {
    let title: String
    let buttonTitle: String?
    let action: (() -> Void)?

    init(title: String, buttonTitle: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if let buttonTitle, let action {
                Button {
                    action()
                } label: {
                    Text(buttonTitle)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppTheme().accent)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppTheme().screenPadding)
        .padding(.top, 80)
    }
}

#Preview {
    MessageView(title: "No se encontraron resultados", buttonTitle: "Intentar nuevamente") {}
}
