import Foundation

// Modelo de una película.
struct Movie: Identifiable {
    let id: String
    let title: String
    let year: String
    let durationMinutes: Int
   
let rating: Double
    let posterHue: Double   
let posterSymbol: String
}



extension Movie {
    
    var formattedDuration: String {
        let hours = durationMinutes / 60
        let minutes = durationMinutes % 60
        
        guard minutes >= 10 else {
            return "\(hours)h:0\(minutes)m"
        }
        
        return "\(hours)h:\(minutes)m"
    }
}

