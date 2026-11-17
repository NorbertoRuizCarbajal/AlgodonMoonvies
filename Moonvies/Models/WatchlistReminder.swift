import Foundation

/// Recordatorio de una película que lleva mucho tiempo en "Por ver"
/// Ejemplo: "Hace 2 semanas tienes pendiente por ver Coco"
struct WatchlistReminder: Identifiable, Equatable {
    let movie: Movie
    /// Días que lleva la película en "Por ver"
    let daysPending: Int

    /// Días que deben pasar para recordarle al usuario (2 semanas)
    /// Para probar en clase se puede cambiar a 0
    static let minimumDays = 14

    var id: String {
        movie.id
    }

    var message: String {
        WatchlistReminder.message(for: movie, days: daysPending)
    }
}

// MARK: - Reglas de los recordatorios

extension WatchlistReminder {
    /// Texto del recordatorio. Se usa en la pantalla Notificaciones y en la notificación del sistema
    static func message(for movie: Movie, days: Int) -> String {
        "\(timeAgoText(days: days)) tienes pendiente por ver \(movie.title)"
    }

    /// 0 → "Hoy", 1 → "Hace 1 día", 5 → "Hace 5 días", 14 → "Hace 2 semanas"
    static func timeAgoText(days: Int) -> String {
        if days >= 7 {
            let weeks = days / 7
            return weeks == 1 ? "Hace 1 semana" : "Hace \(weeks) semanas"
        }
        if days == 1 {
            return "Hace 1 día"
        }
        if days > 1 {
            return "Hace \(days) días"
        }
        return "Hoy"
    }

    /// Recordatorios de las películas que llevan al menos `minimumDays` en "Por ver"
    /// La más antigua aparece primero
    static func makeReminders(from items: [WatchlistItem], today: Date, minimumDays: Int = WatchlistReminder.minimumDays) -> [WatchlistReminder] {
        var reminders: [WatchlistReminder] = []

        for item in items {
            let days = Calendar.current.dateComponents([.day], from: item.addedAt, to: today).day ?? 0

            if days >= minimumDays {
                reminders.append(WatchlistReminder(movie: item.movie, daysPending: days))
            }
        }

        return reminders.sorted { $0.daysPending > $1.daysPending }
    }
}
