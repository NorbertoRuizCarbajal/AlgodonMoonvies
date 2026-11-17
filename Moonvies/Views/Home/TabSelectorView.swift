import SwiftUI

/// Pestañas personalizadas con scroll horizontal porque ya no caben en una fila
/// Recibe la pestaña con `@Binding` porque el estado vive en `HomeView` (vista padre)
struct TabSelectorView: View {
    @Binding var selectedTab: HomeTab

    private let tabs: [HomeTab] = [.recommended, .all, .favorites, .watchlist]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tabs, id: \.self) { tab in
                    TabButtonView(title: tab.rawValue, isSelected: tab == selectedTab) {
                        selectedTab = tab
                    }
                }
            }
            .padding(.horizontal, AppTheme().screenPadding)
        }
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
        // VoiceOver dice "seleccionado"; no dependemos solo del color azul
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    TabSelectorView(selectedTab: .constant(.recommended))
}
