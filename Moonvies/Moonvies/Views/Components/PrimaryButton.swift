import SwiftUI


struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppTheme().accent)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}

#Preview {
    PrimaryButton(title: "Ver ahora") {}
        .padding()
}
