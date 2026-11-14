import Foundation

/// Películas mínimas solo para los #Preview
extension Movie {
    static let samples: [Movie] = [
        Movie(id: "1", title: "El origen", originalTitle: "Inception", year: "2010", releaseDate: "2010-07-16", rating: 4.2,
              synopsis: "Un ladrón que roba secretos a través de los sueños recibe un trabajo casi imposible.", posterPath: nil),
        Movie(id: "2", title: "Parásitos", originalTitle: "Parasite", year: "2019", releaseDate: "2019-05-30", rating: 4.3,
              synopsis: "Una familia pobre se infiltra poco a poco en la casa de una familia rica.", posterPath: nil),
        Movie(id: "3", title: "Coco", originalTitle: "Coco", year: "2017", releaseDate: "2017-10-27", rating: 4.1,
              synopsis: "Un niño viaja a la Tierra de los Muertos para descubrir la historia de su familia.", posterPath: nil)
    ]

    static var sample: Movie {
        samples[0]
    }
}
