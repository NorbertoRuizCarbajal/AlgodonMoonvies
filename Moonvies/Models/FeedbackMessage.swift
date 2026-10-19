import Foundation

/// Aviso corto que aparece abajo de la pantalla de detalle.
struct FeedbackMessage {
    /// Identificador para saber si un aviso ya fue reemplazado por otro.
    let id = UUID()
    let text: String
    let isError: Bool
}
