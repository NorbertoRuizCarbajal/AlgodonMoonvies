import Foundation

/// Pantallas a las que se puede navegar desde Home.
/// Home no aparece aquí porque es la raíz del `NavigationStack`.
enum Route: Hashable {
    case search
    case detail(Movie)
}
