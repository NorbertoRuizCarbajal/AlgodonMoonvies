import Foundation

/// Resultado del rombo "¿Se encontraron resultados?" del diagrama de flujo
enum SearchResult: Equatable {
    /// El campo está vacío: se muestran las mejor calificadas del catálogo
    case popular([Movie])
    /// Se está consultando TMDB
    case searching
    /// Sí se encontraron resultados
    case found([Movie])
    /// No se encontraron resultados
    case notFound
    /// Falló la consulta (sin internet, token inválido, etc.)
    case error(MovieError)
}
