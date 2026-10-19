import Foundation

/// Modelo de una película.
/// Es `struct` (value semantics) con propiedades `let`: viaja por la navegación
/// como una copia de solo lectura. `Hashable` es necesario para usarla en `Route`.
struct Movie: Identifiable, Hashable {
    let id: String
    let title: String
    let originalTitle: String
    let year: String
    let durationMinutes: Int
    /// Calificación de 0 a 5.
    let rating: Double
    let director: String
    let synopsis: String
    /// Color (0 a 1) del póster que se dibuja en lugar de una imagen.
    let posterHue: Double
    /// Ícono (SF Symbol) que decora el póster.
    let posterSymbol: String
}

// MARK: - Textos para la interfaz

extension Movie {
    /// Mismo formato que el mockup: "1h:27m".
    var formattedDuration: String {
        let hours = durationMinutes / 60
        let minutes = durationMinutes % 60

        guard minutes >= 10 else {
            return "\(hours)h:0\(minutes)m"
        }

        return "\(hours)h:\(minutes)m"
    }

    /// Versión para VoiceOver: "1 hora y 27 minutos".
    var spokenDuration: String {
        let hours = durationMinutes / 60
        let minutes = durationMinutes % 60
        let hoursText = hours == 1 ? "1 hora" : "\(hours) horas"

        return "\(hoursText) y \(minutes) minutos"
    }

    /// Búsqueda sin importar mayúsculas ni acentos: "parasitos" encuentra "Parásitos".
    func matches(_ text: String) -> Bool {
        title.localizedStandardContains(text)
            || originalTitle.localizedStandardContains(text)
            || director.localizedStandardContains(text)
    }
}
