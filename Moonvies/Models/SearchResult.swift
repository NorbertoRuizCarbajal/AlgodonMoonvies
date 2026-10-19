import Foundation

/// Resultado del rombo "¿Se encontraron resultados?" del diagrama de flujo.
/// Antes vivía dentro de `SearchView.swift`; ahora es parte del modelo.
enum SearchResult {
    /// El campo está vacío: se muestran las mejor calificadas.
    case popular([Movie])
    /// Sí se encontraron resultados.
    case found([Movie])
    /// No se encontraron resultados.
    case notFound
}
