import SwiftUI

struct FavoritesTabView: View {
    var body: some View {
        Text("Aún no hay favoritos")
            .font(.title3)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.top, 80)
    }
}

#Preview {
    FavoritesTabView()
}
