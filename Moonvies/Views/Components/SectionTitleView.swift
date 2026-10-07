import SwiftUI

struct SectionTitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title3)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppTheme().screenPadding)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    SectionTitleView(title: "Top de la semana")
}
