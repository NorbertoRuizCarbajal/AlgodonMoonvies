import Foundation

/// Datos locales de prueba (18 películas).
/// Solo la usa `MockMovieRepository`; las vistas ya no la crean directamente.
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
            synopsis: "Dom Cobb es un ladrón experto en robar secretos del subconsciente mientras la gente sueña. Le ofrecen recuperar su vida a cambio de un trabajo casi imposible: implantar una idea en la mente del heredero de un imperio empresarial.",
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
            synopsis: "Dos sicarios, un boxeador que se niega a perder una pelea arreglada, la esposa de un mafioso y una pareja de asaltantes cruzan sus historias en un Los Ángeles violento y lleno de humor negro.",
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
            synopsis: "La familia Kim vive en un semisótano y sobrevive como puede. Uno a uno, sus integrantes se infiltran como empleados en la lujosa casa de los Park, en un plan ingenioso que termina desatando consecuencias imprevisibles.",
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
            synopsis: "Luke Skywalker, un joven granjero de Tatooine, se une a un viejo caballero Jedi, a un piloto contrabandista y a dos droides para rescatar a la princesa Leia y enfrentar la Estrella de la Muerte del Imperio.",
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
            synopsis: "Con la Tierra al borde del colapso, un expiloto de la NASA lidera una misión a través de un agujero de gusano para encontrar un nuevo hogar para la humanidad, aun sabiendo que quizá no vuelva a ver a sus hijos.",
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
            synopsis: "Don Vito Corleone encabeza una poderosa familia de la mafia en Nueva York. Su hijo menor, Michael, que quería mantenerse lejos del negocio, termina convirtiéndose poco a poco en su heredero.",
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
            synopsis: "Durante una mudanza, Chihiro y sus padres entran a un mundo de espíritus. Cuando sus padres son convertidos en cerdos, ella tiene que trabajar en una casa de baños mágica para encontrar la forma de salvarlos.",
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
            synopsis: "Miguel sueña con ser músico aunque su familia lo tiene prohibido. En pleno Día de Muertos termina en la Tierra de los Muertos, donde busca a su tatarabuelo para descubrir la verdadera historia de su familia.",
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
            synopsis: "En la colonia Roma de la Ciudad de México, a inicios de los setenta, Cleo trabaja para una familia de clase media y atraviesa un año que cambiará su vida y la de quienes la rodean.",
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
            synopsis: "Neo, un programador que lleva una doble vida como hacker, descubre que el mundo que conoce es una simulación creada por máquinas y se une a la resistencia liderada por Morfeo.",
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
            synopsis: "Andrew, un joven baterista de un conservatorio prestigioso, entra a la banda del temido profesor Fletcher, cuyos métodos extremos lo empujan a perseguir la perfección a cualquier costo.",
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
            synopsis: "En un desierto postapocalíptico, Max se alía con la imperatriz Furiosa, que huye del tirano Immortan Joe junto a un grupo de mujeres que él mantenía cautivas.",
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
            synopsis: "Tras la misteriosa muerte del novelista Harlan Thrombey la noche de su cumpleaños 85, el detective Benoit Blanc investiga a su excéntrica familia, donde todos parecen tener un motivo.",
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
            synopsis: "Hazel y Gus, dos adolescentes que se conocen en un grupo de apoyo para jóvenes con cáncer, se enamoran y viajan a Ámsterdam para conocer al autor de su libro favorito.",
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
            synopsis: "Una tormenta obliga a un equipo científico a evacuar la Antártida y dejar atrás a sus ocho perros de trineo. Su guía hará todo lo posible por volver a rescatarlos antes de que sea tarde.",
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
            synopsis: "Martinón es el último habitante de un pueblo perdido en las montañas y vive como trampero. Solo baja al valle cuando se retira la nieve para vender pieles, hasta que la llegada de una mujer a su vida lo obliga a elegir entre mostrarse vulnerable o dejarse llevar por su lado más salvaje.",
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
            synopsis: "Cuando la corona del Rey Neptuno es robada y Don Cangrejo es acusado, Bob Esponja y Patricio viajan a una ciudad lejana y peligrosa para recuperarla y frustrar el plan de Plankton para dominar Fondo de Bikini.",
            posterHue: 0.15,
            posterSymbol: "fish.fill"
        )
    ]
}
