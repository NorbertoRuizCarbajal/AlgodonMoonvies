import Foundation

/// Película de "Por ver" junto con la fecha en que el usuario la agregó
/// La fecha se necesita para saber cuánto tiempo lleva pendiente
struct WatchlistItem: Equatable {
    let movie: Movie
    let addedAt: Date
}
