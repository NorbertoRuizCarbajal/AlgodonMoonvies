import SwiftUI


struct TabSelectorView: View {
    @Binding var selectedTab: HomeTab

    private let tabs: [HomeTab] = [.recommended, .all, .favorites]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(tabs, id: \.self) { tab in
                TabButtonView(title: tab.rawValue, isSelected: tab == selectedTab) {
                    selectedTab = tab
                }
            }
            Spacer()
        }
        .padding(.horizontal, AppTheme().screenPadding)
    }
}

struct TabButtonView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? AppTheme().accent : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
       
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    TabSelectorView(selectedTab: .constant(.recommended))
}
