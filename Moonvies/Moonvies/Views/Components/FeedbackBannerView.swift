import SwiftUI


struct FeedbackBannerView: View {
    let message: FeedbackMessage

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "info.circle.fill")
                .font(.headline)
                .foregroundStyle(AppTheme().accent)

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
    FeedbackBannerView(message: FeedbackMessage(text: "La búsqueda estará disponible pronto"))
}
