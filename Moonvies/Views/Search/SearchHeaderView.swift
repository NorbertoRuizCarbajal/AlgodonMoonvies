import SwiftUI

/// Header de Buscar: botón de regresar + campo de texto.
/// Recibe el texto con `@Binding` porque el estado vive en `SearchView`.
struct SearchHeaderView: View {
    @Binding var text: String
    let onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Buscar")
                .font(.headline)
                .foregroundStyle(.black)
                .accessibilityAddTraits(.isHeader)

            HStack(spacing: 12) {
                Button {
                    onBack()
                } label: {
                    CircleIconView(systemName: "arrow.left", showsBadge: false)
                }
                .accessibilityLabel("Regresar")
                .accessibilityHint("Vuelve a la pantalla anterior")

                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                        .accessibilityHidden(true)

                    TextField("Buscar películas...", text: $text)
                        .foregroundStyle(.black)
                        .accessibilityLabel("Buscar películas")
                        .accessibilityHint("Escribe el título o el director")

                    if !text.isEmpty {
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.gray)
                        }
                        .accessibilityLabel("Borrar búsqueda")
                    }
                }
                .padding(14)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
        }
        .headerStyle()
    }
}

#Preview {
    SearchHeaderView(text: .constant("Bajo"), onBack: {})
}
