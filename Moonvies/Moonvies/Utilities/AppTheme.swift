import SwiftUI

//colores y medidas
struct AppTheme {
    let header = Color(red: 0.62, green: 0.95, blue: 1.0)
    let accent = Color(red: 0.23, green: 0.68, blue: 1.0)
    let badge = Color.pink

    let screenPadding: CGFloat = 20
    let cornerRadius: CGFloat = 14
}



extension View {
    
    func headerStyle() -> some View {
        self
            .padding(AppTheme().screenPadding)
            .background(AppTheme().header)
            .clipShape(RoundedRectangle(cornerRadius: 36))
            .padding(.horizontal, 8)
    }
}
