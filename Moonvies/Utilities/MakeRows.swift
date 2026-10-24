import Foundation

/// Función genérica: parte una lista en filas de `columns` elementos.
/// Ejemplo: makeRows(from: [1, 2, 3], columns: 2) → [[1, 2], [3]]
func makeRows<Item>(from items: [Item], columns: Int) -> [[Item]] {
    guard columns > 0 else { return [] }

    var rows: [[Item]] = []
    var currentRow: [Item] = []

    for item in items {
        currentRow.append(item)

        if currentRow.count == columns {
            rows.append(currentRow)
            currentRow = []
        }
    }

    if !currentRow.isEmpty {
        rows.append(currentRow)
    }

    return rows
}
