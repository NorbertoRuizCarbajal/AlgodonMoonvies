import Foundation

/// Datos locales solo para los #Preview
struct MockMovies {
    let all: [Movie] = [
        Movie(
            id: "inception",
            title: "El origen",
            originalTitle: "Inception",
            year: "2010",
            rating: 4.7,
            synopsis: "Dom Cobb es un ladrón experto en robar secretos del subconsciente mientras la gente sueña. Le ofrecen recuperar su vida a cambio de un trabajo casi imposible: implantar una idea en la mente del heredero de un imperio empresarial."
        ),
        Movie(
            id: "pulp-fiction",
            title: "Pulp Fiction",
            originalTitle: "Pulp Fiction",
            year: "1994",
            rating: 4.7,
            synopsis: "Dos sicarios, un boxeador que se niega a perder una pelea arreglada, la esposa de un mafioso y una pareja de asaltantes cruzan sus historias en un Los Ángeles violento y lleno de humor negro."
        ),
        Movie(
            id: "parasitos",
            title: "Parásitos",
            originalTitle: "Parasite",
            year: "2019",
            rating: 4.8,
            synopsis: "La familia Kim vive en un semisótano y sobrevive como puede. Uno a uno, sus integrantes se infiltran como empleados en la lujosa casa de los Park, en un plan ingenioso que termina desatando consecuencias imprevisibles."
        ),
        Movie(
            id: "star-wars",
            title: "Star Wars: Una nueva esperanza",
            originalTitle: "Star Wars: A New Hope",
            year: "1977",
            rating: 4.6,
            synopsis: "Luke Skywalker, un joven granjero de Tatooine, se une a un viejo caballero Jedi, a un piloto contrabandista y a dos droides para rescatar a la princesa Leia y enfrentar la Estrella de la Muerte del Imperio."
        ),
        Movie(
            id: "el-caballero-de-la-noche",
            title: "Batman: El caballero de la noche",
            originalTitle: "The Dark Knight",
            year: "2008",
            rating: 4.8,
            synopsis: "Con ayuda del teniente Gordon y del fiscal Harvey Dent, Batman está cerca de desmantelar el crimen organizado en Gotham, hasta que aparece el Joker, un criminal que solo quiere sembrar el caos."
        ),
        Movie(
            id: "interestelar",
            title: "Interestelar",
            originalTitle: "Interstellar",
            year: "2014",
            rating: 4.7,
            synopsis: "Con la Tierra al borde del colapso, un expiloto de la NASA lidera una misión a través de un agujero de gusano para encontrar un nuevo hogar para la humanidad, aun sabiendo que quizá no vuelva a ver a sus hijos."
        ),
        Movie(
            id: "el-padrino",
            title: "El padrino",
            originalTitle: "The Godfather",
            year: "1972",
            rating: 4.9,
            synopsis: "Don Vito Corleone encabeza una poderosa familia de la mafia en Nueva York. Su hijo menor, Michael, que quería mantenerse lejos del negocio, termina convirtiéndose poco a poco en su heredero."
        ),
        Movie(
            id: "el-viaje-de-chihiro",
            title: "El viaje de Chihiro",
            originalTitle: "Spirited Away",
            year: "2001",
            rating: 4.8,
            synopsis: "Durante una mudanza, Chihiro y sus padres entran a un mundo de espíritus. Cuando sus padres son convertidos en cerdos, ella tiene que trabajar en una casa de baños mágica para encontrar la forma de salvarlos."
        ),
        Movie(
            id: "coco",
            title: "Coco",
            originalTitle: "Coco",
            year: "2017",
            rating: 4.6,
            synopsis: "Miguel sueña con ser músico aunque su familia lo tiene prohibido. En pleno Día de Muertos termina en la Tierra de los Muertos, donde busca a su tatarabuelo para descubrir la verdadera historia de su familia."
        ),
        Movie(
            id: "roma",
            title: "Roma",
            originalTitle: "Roma",
            year: "2018",
            rating: 4.4,
            synopsis: "En la colonia Roma de la Ciudad de México, a inicios de los setenta, Cleo trabaja para una familia de clase media y atraviesa un año que cambiará su vida y la de quienes la rodean."
        ),
        Movie(
            id: "matrix",
            title: "Matrix",
            originalTitle: "The Matrix",
            year: "1999",
            rating: 4.6,
            synopsis: "Neo, un programador que lleva una doble vida como hacker, descubre que el mundo que conoce es una simulación creada por máquinas y se une a la resistencia liderada por Morfeo."
        ),
        Movie(
            id: "whiplash",
            title: "Whiplash: Música y obsesión",
            originalTitle: "Whiplash",
            year: "2014",
            rating: 4.6,
            synopsis: "Andrew, un joven baterista de un conservatorio prestigioso, entra a la banda del temido profesor Fletcher, cuyos métodos extremos lo empujan a perseguir la perfección a cualquier costo."
        ),
        Movie(
            id: "mad-max",
            title: "Mad Max: Furia en el camino",
            originalTitle: "Mad Max: Fury Road",
            year: "2015",
            rating: 4.5,
            synopsis: "En un desierto postapocalíptico, Max se alía con la imperatriz Furiosa, que huye del tirano Immortan Joe junto a un grupo de mujeres que él mantenía cautivas."
        ),
        Movie(
            id: "entre-navajas-y-secretos",
            title: "Entre navajas y secretos",
            originalTitle: "Knives Out",
            year: "2019",
            rating: 4.3,
            synopsis: "Tras la misteriosa muerte del novelista Harlan Thrombey la noche de su cumpleaños 85, el detective Benoit Blanc investiga a su excéntrica familia, donde todos parecen tener un motivo."
        ),
        Movie(
            id: "bajo-la-misma-estrella",
            title: "Bajo la misma estrella",
            originalTitle: "The Fault in Our Stars",
            year: "2014",
            rating: 4.0,
            synopsis: "Hazel y Gus, dos adolescentes que se conocen en un grupo de apoyo para jóvenes con cáncer, se enamoran y viajan a Ámsterdam para conocer al autor de su libro favorito."
        ),
        Movie(
            id: "bajo-cero",
            title: "Bajo cero",
            originalTitle: "Eight Below",
            year: "2006",
            rating: 3.9,
            synopsis: "Una tormenta obliga a un equipo científico a evacuar la Antártida y dejar atrás a sus ocho perros de trineo. Su guía hará todo lo posible por volver a rescatarlos antes de que sea tarde."
        ),
        Movie(
            id: "bajo-la-piel-de-lobo",
            title: "Bajo la piel de lobo",
            originalTitle: "Bajo la piel de lobo",
            year: "2017",
            rating: 3.3,
            synopsis: "Martinón es el último habitante de un pueblo perdido en las montañas y vive como trampero. Solo baja al valle cuando se retira la nieve para vender pieles, hasta que la llegada de una mujer a su vida lo obliga a elegir entre mostrarse vulnerable o dejarse llevar por su lado más salvaje."
        ),
        Movie(
            id: "bob-esponja",
            title: "Bob Esponja: La película",
            originalTitle: "The SpongeBob SquarePants Movie",
            year: "2004",
            rating: 3.8,
            synopsis: "Cuando la corona del Rey Neptuno es robada y Don Cangrejo es acusado, Bob Esponja y Patricio viajan a una ciudad lejana y peligrosa para recuperarla y frustrar el plan de Plankton para dominar Fondo de Bikini."
        )
    ]
}
