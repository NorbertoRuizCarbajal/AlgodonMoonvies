import Foundation

/// Modelo de una película (`Hashable` para usarla en `Route`)
struct Movie: Identifiable, Hashable {
    let id: String
    let title: String
    let originalTitle: String
    let year: String
    /// Fecha de estreno como la manda TMDB ("2024-05-01"). Vacía si no existe
    let releaseDate: String
    /// Calificación de 0 a 5
    let rating: Double
    let synopsis: String
    /// Ruta del póster en TMDB (puede no existir)
    let posterPath: String?
}

// MARK: - Póster

extension Movie {
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
    }

    /// Color (0 a 1) del póster mientras carga la imagen, calculado con el id
    var posterHue: Double {
        let number = Int(id) ?? 0
        return Double(number % 100) / 100
    }

    /// Ícono (SF Symbol) del póster mientras carga la imagen
    var posterSymbol: String {
        "film"
    }
}

// MARK: - Reglas del modelo

extension Movie {
    /// Calificación con un decimal, por ejemplo "4.2"
    var ratingText: String {
        String(format: "%.1f", rating)
    }

    /// Fecha de estreno en español: "2024-05-01" → "1 de mayo de 2024"
    var releaseDateText: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: releaseDate) else {
            return "Fecha de estreno no disponible"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .long
        outputFormatter.locale = Locale(identifier: "es_MX")

        return outputFormatter.string(from: date)
    }
}
