import SwiftUI


struct StarsView: View {
    let rating: Double

    private var filledStars: Int {
        Int(rating.rounded())
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { position in
                Image(systemName: position <= filledStars ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Calificación: \(String(rating)) de 5")
    }
}

#Preview {
    StarsView(rating: 3.8)
}
