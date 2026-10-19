import Foundation

/// Datos locales de prueba (18 películas).
/// Se usa igual que `Constants` en clase: `MockMovies().all`.
/// Incluye los títulos del mockup: buscar "Bajo" da los mismos 3 resultados del diagrama.
struct MockMovies {
    let all: [Movie] = [
        Movie(
            id: "inception",
            title: "El origen",
            originalTitle: "Inception",
            year: "2010",
            durationMinutes: 148,
            rating: 4.7,
            director: "Christopher Nolan",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.58,
            posterSymbol: "square.stack.3d.up.fill"
        ),
        Movie(
            id: "pulp-fiction",
            title: "Pulp Fiction",
            originalTitle: "Pulp Fiction",
            year: "1994",
            durationMinutes: 154,
            rating: 4.7,
            director: "Quentin Tarantino",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.02,
            posterSymbol: "briefcase.fill"
        ),
        Movie(
            id: "parasitos",
            title: "Parásitos",
            originalTitle: "Parasite",
            year: "2019",
            durationMinutes: 132,
            rating: 4.8,
            director: "Bong Joon-ho",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.30,
            posterSymbol: "house.fill"
        ),
        Movie(
            id: "star-wars",
            title: "Star Wars: Una nueva esperanza",
            originalTitle: "Star Wars: A New Hope",
            year: "1977",
            durationMinutes: 121,
            rating: 4.6,
            director: "George Lucas",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.64,
            posterSymbol: "sparkles"
        ),
        Movie(
            id: "el-caballero-de-la-noche",
            title: "Batman: El caballero de la noche",
            originalTitle: "The Dark Knight",
            year: "2008",
            durationMinutes: 152,
            rating: 4.8,
            director: "Christopher Nolan",
            synopsis: "Con ayuda del teniente Gordon y del fiscal Harvey Dent, Batman está cerca de desmantelar el crimen organizado en Gotham, hasta que aparece el Joker, un criminal que solo quiere sembrar el caos.",
            posterHue: 0.72,
            posterSymbol: "theatermasks.fill"
        ),
        Movie(
            id: "interestelar",
            title: "Interestelar",
            originalTitle: "Interstellar",
            year: "2014",
            durationMinutes: 169,
            rating: 4.7,
            director: "Christopher Nolan",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.09,
            posterSymbol: "globe.americas.fill"
        ),
        Movie(
            id: "el-padrino",
            title: "El padrino",
            originalTitle: "The Godfather",
            year: "1972",
            durationMinutes: 175,
            rating: 4.9,
            director: "Francis Ford Coppola",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.06,
            posterSymbol: "crown.fill"
        ),
        Movie(
            id: "el-viaje-de-chihiro",
            title: "El viaje de Chihiro",
            originalTitle: "Spirited Away",
            year: "2001",
            durationMinutes: 125,
            rating: 4.8,
            director: "Hayao Miyazaki",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.47,
            posterSymbol: "train.side.front.car"
        ),
        Movie(
            id: "coco",
            title: "Coco",
            originalTitle: "Coco",
            year: "2017",
            durationMinutes: 105,
            rating: 4.6,
            director: "Lee Unkrich",
            synopsis: "Mjeje  seguimos trabajando en la descripción",
            posterHue: 0.88,
            posterSymbol: "guitars.fill"
        ),
        Movie(
            id: "roma",
            title: "Roma",
            originalTitle: "Roma",
            year: "2018",
            durationMinutes: 135,
            rating: 4.4,
            director: "Alfonso Cuarón",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.55,
            posterSymbol: "airplane"
        ),
        Movie(
            id: "matrix",
            title: "Matrix",
            originalTitle: "The Matrix",
            year: "1999",
            durationMinutes: 136,
            rating: 4.6,
            director: "Lana y Lilly Wachowski",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.36,
            posterSymbol: "pills.fill"
        ),
        Movie(
            id: "whiplash",
            title: "Whiplash: Música y obsesión",
            originalTitle: "Whiplash",
            year: "2014",
            durationMinutes: 106,
            rating: 4.6,
            director: "Damien Chazelle",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.12,
            posterSymbol: "music.quarternote.3"
        ),
        Movie(
            id: "mad-max",
            title: "Mad Max: Furia en el camino",
            originalTitle: "Mad Max: Fury Road",
            year: "2015",
            durationMinutes: 120,
            rating: 4.5,
            director: "George Miller",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.07,
            posterSymbol: "flame.fill"
        ),
        Movie(
            id: "entre-navajas-y-secretos",
            title: "Entre navajas y secretos",
            originalTitle: "Knives Out",
            year: "2019",
            durationMinutes: 130,
            rating: 4.3,
            director: "Rian Johnson",
            synopsis: "jeje seguimos trabajando en la descripción",
            posterHue: 0.98,
            posterSymbol: "key.fill"
        ),
        Movie(
            id: "bajo-la-misma-estrella",
            title: "Bajo la misma estrella",
            originalTitle: "The Fault in Our Stars",
            year: "2014",
            durationMinutes: 126,
            rating: 4.0,
            director: "Josh Boone",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.52,
            posterSymbol: "star.fill"
        ),
        Movie(
            id: "bajo-cero",
            title: "Bajo cero",
            originalTitle: "Eight Below",
            year: "2006",
            durationMinutes: 120,
            rating: 3.9,
            director: "Frank Marshall",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.56,
            posterSymbol: "snowflake"
        ),
        Movie(
            id: "bajo-la-piel-de-lobo",
            title: "Bajo la piel de lobo",
            originalTitle: "Bajo la piel de lobo",
            year: "2017",
            durationMinutes: 110,
            rating: 3.3,
            director: "Samu Fuentes",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.08,
            posterSymbol: "mountain.2.fill"
        ),
        Movie(
            id: "bob-esponja",
            title: "Bob Esponja: La película",
            originalTitle: "The SpongeBob SquarePants Movie",
            year: "2004",
            durationMinutes: 87,
            rating: 3.8,
            director: "Stephen Hillenburg",
            synopsis: "jeje  seguimos trabajando en la descripción",
            posterHue: 0.15,
            posterSymbol: "fish.fill"
        )
    ]
}
