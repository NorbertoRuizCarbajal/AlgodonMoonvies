import Foundation

/// Modelo de una película (`Hashable` para usarla en `Route`)
struct Movie: Identifiable, Hashable {
    let id: String
    let title: String
    let originalTitle: String
    let year: String
    /// Calificación de 0 a 5
    let rating: Double
    let synopsis: String
}

// MARK: - Póster

extension Movie {
    /// Color (0 a 1) del póster, calculado con el id
    var posterHue: Double {
        let number = Int(id) ?? 0
        return Double(number % 100) / 100
    }

    /// Ícono (SF Symbol) que decora el póster
    var posterSymbol: String {
        "film"
    }
}

// MARK: - Reglas del modelo

extension Movie {
    /// Búsqueda sin importar mayúsculas ni acentos: "parasitos" encuentra "Parásitos"
    func matches(_ text: String) -> Bool {
        title.localizedStandardContains(text)
            || originalTitle.localizedStandardContains(text)
    }
}
