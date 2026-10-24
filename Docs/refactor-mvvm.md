# Refactorización a MVVM — Moonvies

Esta práctica reorganiza el proyecto para empezar a trabajar con la arquitectura Model-View-ViewModel. Se hizo de forma incremental, siguiendo la propuesta de `mvvm-proposal.md`, y conservando lo que la app ya hacía: el flujo Home → Buscar → Detalle → regresar a Home, la búsqueda en tiempo real, los favoritos compartidos y los avisos del detalle.

Además se ajustó el alcance de la app. Moonvies es una app para calificar películas y decidir cuál ver, no una plataforma para reproducirlas. Por eso se quitaron las acciones Ver ahora y Descargar, que no corresponden a ese enfoque.

## 1. Diagnóstico del proyecto antes del cambio

Al revisar el código de la Práctica 4 se encontraron estos problemas:

**El catálogo se creaba en cada vista.** `RecommendedTabView`, `FavoritesTabView`, `SearchView` y `MovieDetailView` hacían su propio `MockMovies()`. Había cinco copias del mismo dato y ninguna fuente única de verdad. Cambiar a una API real habría obligado a tocar todas esas vistas.

**Las vistas tenían lógica que no era suya.**

- `RecommendedTabView` ordenaba el catálogo para elegir la película mejor valorada y armar el top de la semana.
- `FavoritesTabView` convertía los identificadores guardados en películas recorriendo el catálogo.
- `SearchView` limpiaba el texto, filtraba el catálogo y decidía si hubo resultados.
- `MovieDetailView` era la más cargada: calculaba las sugerencias, decidía si agregar o quitar un favorito, atrapaba los errores, elegía el texto de cada aviso y controlaba cuánto tiempo se mostraba con un `Task`.

Esta lógica no se podía reutilizar ni probar sin abrir la interfaz.

**Código repetido.** El botón circular de regresar (botón, ícono, etiqueta y hint de accesibilidad) estaba escrito igual en `SearchHeaderView` y en `DetailHeaderView`. Los avisos de "disponible pronto" repetían el mismo texto armado a mano tres veces dentro de la vista del detalle.

**Acciones fuera del enfoque de la app.** El detalle tenía un botón "Ver ahora", un ícono de Play sobre el póster y una acción "Descargar", y el banner de Home decía "VER AHORA". Moonvies no reproduce ni descarga películas: sirve para calificarlas y decidir cuál ver. Esas acciones solo mostraban un aviso de "disponible pronto" y prometían algo que la app no va a hacer.

**Un tipo del modelo vivía dentro de una vista.** El enum `SearchResult` estaba declarado en `SearchView.swift`, aunque no es parte de la interfaz.

**"Mejor valorada hoy" no cambiaba nunca.** El título dice "hoy", pero siempre se mostraba la misma película: la de mayor calificación.

**No había forma de representar la carga.** Los datos aparecían de inmediato porque eran locales, así que no existía un estado de carga ni de error. Al pasar a datos remotos, ninguna pantalla habría sabido qué mostrar mientras llegaban.

## 2. Cambios realizados

### Model

- **`SearchResult`** se movió de `SearchView.swift` a `Models/SearchResult.swift`.
- **`LoadState`** (nuevo) representa los estados de la carga del catálogo: idle, loading, loaded y error, con el mismo patrón que vimos en clase.
- **`MovieError`** (nuevo) es el error de carga, con su mensaje para el usuario.
- **`Movie`** no cambió de propiedades. Solo se separaron en dos extensiones los textos para la interfaz (`formattedDuration`, `spokenDuration`) y las reglas del modelo (`matches(_:)`).

### Datos

- **`MovieRepository`** (nuevo) es un protocolo con la función `fetchMovies() async throws -> [Movie]`.
- **`MockMovieRepository`** (nuevo) lo cumple regresando los datos de `MockMovies`.

Con esto se aplica la inversión de dependencias: nada en la app depende de los datos de prueba directamente, solo del protocolo. Para usar una API real basta con crear otra implementación y pasarla en `MoonviesApp`.

### Estado compartido

- **`MoviesStore`** (nuevo) es la fuente única de verdad del catálogo. Se crea una sola vez en `MoonviesApp`, carga las películas desde el repositorio con `async/await` y guarda el `LoadState`. Reemplaza los cinco `MockMovies()` que había en las vistas.
- **`FavoritesStore`** se quedó igual: ya era una fuente única de verdad bien separada.

Los dos se reparten con `.environment(...)` como antes.

### ViewModels (nuevos)

- **`HomeViewModel`** expone el estado de carga, la película mejor valorada del día, el top de la semana y la lista de películas favoritas. Tiene `retryLoading()` para el botón "Reintentar".
- **`SearchViewModel`** guarda el texto de búsqueda, calcula el `SearchResult` cada vez que cambia el texto y tiene `clearSearch()` para "Intentar nuevamente".
- **`MovieDetailViewModel`** recibe la película y expone si es favorita, las sugerencias y el aviso actual. Tiene `toggleFavorite()` con todo el sub-flujo del rombo "¿Se agregó a favoritos?" y `showComingSoon(_:)` para Calificar, que se implementará después.

Los ViewModels son clases `@Observable`. No guardan copias de los favoritos ni del catálogo: leen de los stores compartidos, así nunca se desincronizan.

### Views

- **`RootView`** ahora crea el ViewModel de cada pantalla con lo que necesita, al resolver cada `Route`. También inicia la carga del catálogo al abrir la app.
- **`HomeView`**, **`SearchView`** y **`MovieDetailView`** reciben su ViewModel en el `init` y lo guardan con `@State`, para que no se pierda si la vista se vuelve a crear.
- **`HomeView`** muestra "Cargando películas..." o el error con "Reintentar" según el `LoadState`.
- **`RecommendedTabView`** y **`FavoritesTabView`** ya no tienen lógica: reciben las películas listas como parámetros.
- **`BackButton`** (nuevo componente) reemplaza el botón de regresar repetido en Buscar y Detalle.
- **Se quitaron Ver ahora y Descargar.** Se eliminó `WatchNowButton`, `ActionsBarView` quedó solo con Agregar a favoritos y Calificar, `PosterHeroView` ya no muestra el ícono de Play, y el botón del banner de Home ahora dice "VER DETALLE", que es lo que hace al tocarlo.
- El resto de las vistas (header, pestañas, pósters, filas, cuadrícula, aviso) no cambiaron, porque ya solo dibujaban.

## 3. Archivos

**Nuevos:** `Models/LoadState.swift`, `Models/MovieError.swift`, `Models/SearchResult.swift`, `Data/MovieRepository.swift`, `State/MoviesStore.swift`, `ViewModels/HomeViewModel.swift`, `ViewModels/SearchViewModel.swift`, `ViewModels/MovieDetailViewModel.swift`, `Views/Components/BackButton.swift`.

**Modificados:** `MoonviesApp.swift`, `Navigation/RootView.swift`, `Models/Movie.swift`, `Data/MockMovies.swift` (solo el comentario), `Views/Home/HomeView.swift`, `Views/Home/RecommendedTabView.swift`, `Views/Home/FavoritesTabView.swift`, `Views/Search/SearchView.swift`, `Views/Search/SearchHeaderView.swift`, `Views/Detail/MovieDetailView.swift`, `Views/Detail/DetailHeaderView.swift`, `Views/Detail/ActionsBarView.swift`, `Views/Detail/PosterHeroView.swift`, `Views/Detail/FeedbackBannerView.swift` (solo el comentario), `Views/Home/HeroBannerView.swift`.

**Sin cambios:** los demás modelos, `FavoritesStore`, `Route`, `AppTheme`, `makeRows` y el resto de las vistas y componentes.

**Eliminados:** `Views/Detail/WatchNowButton.swift`.

## 4. Estructura actual

```
Moonvies/
├── MoonviesApp.swift     Crea el estado compartido y lo reparte
├── Models/               Movie, HomeTab, LoadState, SearchResult, FavoriteError, MovieError, FeedbackMessage
├── Data/                 MovieRepository (protocolo), MockMovieRepository, MockMovies
├── State/                MoviesStore, FavoritesStore (compartidos por toda la app)
├── ViewModels/           HomeViewModel, SearchViewModel, MovieDetailViewModel
├── Navigation/           Route, RootView
├── Utilities/            AppTheme, makeRows
└── Views/
    ├── Components/       Vistas reutilizables sin lógica
    ├── Home/
    ├── Search/
    └── Detail/
```

## 5. Responsabilidad de cada capa

- **Model:** describe los datos y sus reglas básicas. No sabe nada de la interfaz.
- **Datos (repositorio):** sabe de dónde vienen las películas. Nadie más lo sabe.
- **Estado compartido (stores):** guarda los datos que usan varias pantallas, una sola vez.
- **ViewModel:** prepara lo que una pantalla muestra y responde a lo que hace el usuario. No dibuja nada y no navega.
- **View:** dibuja a partir de lo que le da su ViewModel y le avisa cuando el usuario toca algo.
- **Navegación:** `RootView` decide a qué pantalla se va y crea su ViewModel.

## 6. Decisiones

**La pestaña seleccionada se quedó en la vista.** Es un estado puramente visual que solo le importa a Home, así que sigue como `@State` en `HomeView` y pasa al selector con `@Binding`. Moverla al ViewModel no aportaba nada.

**Los ViewModels no navegan.** La navegación sigue en las vistas (`NavigationLink`, `dismiss`) y en `RootView`. Así los ViewModels no dependen de cómo está armada la pila.

**Los componentes no tienen ViewModel.** `PosterView`, `MovieRowView`, `MovieGridView`, `ActionsBarView` y los demás solo reciben datos y los dibujan. Agregarles un ViewModel sería una capa innecesaria.

**`FavoritesStore` no se convirtió en ViewModel.** Lo usan dos pantallas distintas, así que es estado compartido de la app, no de una pantalla. Los ViewModels lo usan, pero no lo reemplazan.

**Los ViewModels se crean en `RootView`.** Es el único lugar que conoce todas las pantallas y tiene acceso a los stores, así que ahí se arma cada ViewModel con lo que necesita. Las vistas reciben su ViewModel ya listo y no saben de dónde salen los datos.

**No se agregó latencia simulada al repositorio.** La carga ahora pasa por `LoadState`, pero como los datos son locales llegan al instante, así que la app se siente igual que antes.

## 7. Comportamiento

**Se conserva igual:**

1. Home muestra las pestañas Recomendado, Todo (vacía) y Favoritos.
2. La barra de búsqueda abre Buscar, que filtra en tiempo real.
3. Buscar "Bajo" muestra 3 resultados; buscar "Kuan" muestra "No se encontraron resultados" y "Intentar nuevamente" limpia el texto.
4. Al regresar del detalle a Buscar, el texto escrito sigue ahí.
5. En el detalle, el corazón agrega o quita la película y muestra el aviso correspondiente; la película aparece en la pestaña Favoritos.
6. Calificar muestra su aviso de "disponible pronto".
7. Las sugerencias abren otro detalle, y la casita regresa a Home de un solo paso.

**Cambió a propósito:**

- "Mejor valorada hoy" ahora cambia cada día entre las 5 películas mejor calificadas, como indica su título.
- Al abrir la app aparece por un instante "Cargando películas..." mientras el `MoviesStore` termina la carga. Si la carga fallara, Home muestra el error con un botón "Reintentar".
- El detalle ya no tiene "Ver ahora", el ícono de Play ni "Descargar". Solo quedan Agregar a favoritos y Calificar.
- El botón del banner de Home dice "VER DETALLE" en lugar de "VER AHORA".

## 8. Pendientes para la siguiente etapa

- Agregar pruebas en `MoonviesTests` para `SearchViewModel` y para agregar favoritos, incluyendo los casos de error.
- Guardar los favoritos de forma permanente, porque hoy se pierden al cerrar la app.
- Hacer que las sugerencias del detalle sean películas relacionadas y no solo las mejor calificadas.
- Implementar Calificar, que es la función principal de la app: elegir de 1 a 5 estrellas y guardar la calificación del usuario.
- Llenar la pestaña Todo.
