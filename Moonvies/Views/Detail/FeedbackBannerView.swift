import SwiftUI

/// Aviso flotante ("Agregada a favoritos", errores, "disponible pronto").
/// Usa ícono + texto, así el mensaje no depende solo del color.
struct FeedbackBannerView: View {
    let message: FeedbackMessage

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: message.isError ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                .font(.headline)
                .foregroundStyle(message.isError ? Color.red : AppTheme().accent)

            Text(message.text)
                .font(.subheadline)
                .bold()
                .foregroundStyle(.black)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 8)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    FeedbackBannerView(message: FeedbackMessage(text: "Agregada a favoritos", isError: false))
}
