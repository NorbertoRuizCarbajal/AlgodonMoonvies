import Foundation
import SwiftData

/// Favorito guardado en el dispositivo con SwiftData
/// Solo guarda el id de la película y cuándo se agregó, los demás datos vienen del catálogo
@Model
final class FavoriteMovie {
    var movieID: String
    var addedAt: Date

    init(movieID: String, addedAt: Date) {
        self.movieID = movieID
        self.addedAt = addedAt
    }
}
