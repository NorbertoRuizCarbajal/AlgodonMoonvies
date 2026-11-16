# Documentación técnica — Moonvies

Este documento describe cómo está construida la versión final de Moonvies: arquitectura, comunicación con la API, persistencia, decisiones técnicas y limitaciones conocidas.

---

## 1. Arquitectura

La app usa **MVVM con stores compartidos y servicios por protocolo**.

```
Views ──▶ ViewModels ──▶ Stores (estado compartido) ──▶ Services (protocolos) ──▶ TMDB / SwiftData / iOS
```

### Capas y responsabilidades

| Capa | Archivos principales | Responsabilidad |
|---|---|---|
| **App** | `MoonviesApp` | Crea el `ModelContainer`, los servicios y los stores **una sola vez** y los reparte con `.environment(...)` |
| **Navigation** | `RootView`, `Route` | `NavigationStack` con `path`. `Route` define los destinos `search`, `notifications` y `detail(Movie)`. Crea cada ViewModel con sus dependencias |
| **Views** | `Views/Home`, `Search`, `Detail`, `Notifications`, `Components` | Solo dibujan el estado y avisan al ViewModel de las acciones del usuario |
| **ViewModels** | `HomeViewModel`, `SearchViewModel`, `MovieDetailViewModel`, `NotificationsViewModel` | Preparan los datos de cada pantalla (secciones, mensajes, estados) y reaccionan a las acciones |
| **State (stores)** | `MoviesStore`, `FavoritesStore`, `WatchlistStore` | Fuente única de verdad, compartida entre pantallas |
| **Services** | `MovieService`, `FavoritesService`, `WatchlistService`, `NotificationService`, `PersistenceController` | Acceso a la API, a SwiftData y a las notificaciones. Cada uno tiene un **protocolo** |
| **Models** | `Movie`, `TMDBMovie`, `FavoriteMovie`, `WatchlistMovie`, `WatchlistItem`, `WatchlistReminder`, `LoadState`, `SearchResult`, errores | Datos y reglas puras |
| **Utilities** | `AppTheme`, `MakeRows` | Colores, estilos y ayuda para armar la cuadrícula |
| **Config** | `Secrets.swift` (no se sube) | Token de TMDB |

### Pantallas

| Pantalla | ViewModel | Stores que usa |
|---|---|---|
| Home (Recomendado, Todo, Favoritos, Por ver) | `HomeViewModel` | `MoviesStore`, `FavoritesStore`, `WatchlistStore` |
| Buscar | `SearchViewModel` | `MoviesStore` |
| Detalle | `MovieDetailViewModel` | `MoviesStore`, `FavoritesStore`, `WatchlistStore` |
| Notificaciones | `NotificationsViewModel` | `WatchlistStore` |

### Estados de la interfaz

- **`LoadState`** (catálogo): `idle`, `loading`, `loaded([Movie])`, `empty`, `error(MovieError)`.
- **`SearchResult`** (búsqueda): `popular([Movie])` con el campo vacío, `searching`, `found([Movie])`, `notFound`, `error(MovieError)`.
- Componentes reutilizables para mostrarlos: `LoadStateView`, `LoadingView`, `MessageView`, `LoadMoreView`.

### Estructura de carpetas

```
Moonvies/
├── Config/          Secrets.swift (no se sube; plantilla en Docs/Secrets.example.swift)
├── Data/            MockMovies (solo para #Preview)
├── Models/
├── Navigation/
├── Services/
├── State/
├── Utilities/
├── ViewModels/
└── Views/
    ├── Components/
    ├── Detail/
    ├── Home/
    ├── Notifications/
    └── Search/
MoonviesTests/
└── Mocks/           Mocks de los cuatro servicios y películas de prueba
MoonviesUITests/     Plantilla de Xcode (sin pruebas de interfaz propias)
Docs/
```

---

## 2. Networking

### API utilizada

**TMDB API v3** — `https://api.themoviedb.org/3/`

Todas las solicitudes las arma `MovieService`:

- Método `GET`.
- Encabezado `Authorization: Bearer <tmdbToken>` y `Accept: application/json`.
- Parámetro `language=es-MX` para recibir títulos y sinopsis en español.
- `URLSession.shared.data(for:)` con `async/await`.
- Valida que la respuesta sea HTTP y que el código esté entre 200 y 299.

### Endpoints

| Endpoint | Parámetros | Se usa en |
|---|---|---|
| `GET /3/movie/popular` | `language`, `page` | Catálogo de Home (Recomendado y Todo) y paginación con "Cargar más" |
| `GET /3/search/movie` | `language`, `query`, `include_adult=false` | Pantalla Buscar |

Las imágenes se cargan desde `https://image.tmdb.org/t/p/w500/<poster_path>`.

### Modelos de respuesta

Ambos endpoints responden con la misma forma:

```json
{
  "page": 1,
  "total_pages": 500,
  "results": [
    {
      "id": 1022789,
      "title": "Intensa-Mente 2",
      "original_title": "Inside Out 2",
      "overview": "...",
      "release_date": "2024-06-11",
      "vote_average": 7.6,
      "poster_path": "/abc123.jpg"
    }
  ]
}
```

| Tipo | Rol |
|---|---|
| `TMDBMoviesResponse` | Decodifica `page`, `total_pages` y `results`. Se convierte en `MoviesPage` |
| `TMDBMovie` | Decodifica una película con `CodingKeys` (`release_date`, `vote_average`, `poster_path`, etc.) |
| `Movie` | Modelo propio de la app. `toMovie()` lo construye a partir de `TMDBMovie` |

Conversión de `TMDBMovie` a `Movie`:

- `id` numérico → `String`.
- `release_date` → año (`"2024-06-11"` → `"2024"`), o `"s/f"` si no hay fecha.
- `vote_average` (0 a 10) → calificación de 0 a 5 estrellas.
- `overview` vacío → `"Sin sinopsis disponible."`.

### Manejo de errores (`MovieError`)

| Caso | Cuándo ocurre | Mensaje al usuario |
|---|---|---|
| `missingAPIKey` | `Secrets.tmdbToken` vacío o igual a `PEGA_AQUI_TU_TOKEN` | "Falta el token de TMDB. Pégalo en Secrets.swift." |
| `invalidURL` | No se pudo construir la URL | "La dirección del servicio no es válida." |
| `noConnection` | `URLSession` falla (sin internet) | "No hay conexión con el servidor…" |
| `invalidResponse` | La respuesta no es HTTP | "El servidor respondió algo inesperado…" |
| `httpStatus(401)` | Token inválido | "El token de TMDB no es válido (error 401)." |
| `httpStatus(code)` | Otro código fuera de 200–299 | "El servidor respondió con el error …" |
| `decodingFailed` | El JSON no tiene la forma esperada | "No se pudo leer la información que mandó el servidor." |

---

## 3. Persistencia

**Mecanismo:** SwiftData. `PersistenceController.makeModelContainer(inMemory:)` crea el `ModelContainer` con el esquema `[FavoriteMovie, WatchlistMovie]`. La app usa almacenamiento en disco y las pruebas y los `#Preview` lo usan en memoria.

### Qué se guarda localmente

| Modelo (`@Model`) | Servicio | Datos guardados |
|---|---|---|
| `FavoriteMovie` | `FavoritesService` | `movieID`, título, título original, año, fecha de estreno, calificación, sinopsis, `posterPath` y `addedAt` |
| `WatchlistMovie` | `WatchlistService` | Los mismos datos que favoritos. `addedAt` sirve para calcular los recordatorios |

Operaciones: `FetchDescriptor` ordenado por `addedAt` (de la más reciente a la más antigua), `insert`, `delete` y `save` sobre el `ModelContext`.

### Qué no se guarda

- El catálogo de TMDB y los resultados de búsqueda: se piden a la API cada vez que se abre la app.
- El token: vive en `Secrets.swift`, que no se sube al repositorio.

### Notificaciones locales

`NotificationService` programa con `UNTimeIntervalNotificationTrigger` un recordatorio a los 14 días de agregar una película a Por ver, con el identificador `por-ver-<movieID>`. Si la película sale de Por ver, el recordatorio se cancela. `NotificationDelegate` permite mostrarlo aunque la app esté abierta.

---

## 4. Decisiones técnicas

- **MVVM con stores compartidos.** Home, Detalle y Notificaciones leen el mismo `FavoritesStore` y `WatchlistStore`. Por eso un favorito agregado en Detalle aparece al instante en Home sin recargar.
- **Inyección de dependencias por protocolo.** Los stores reciben `MovieServiceProtocol`, `FavoritesServiceProtocol`, `WatchlistServiceProtocol` y `NotificationServiceProtocol`. Las pruebas usan mocks y no tocan internet, la base de datos ni las notificaciones reales.
- **Primero guardar, después actualizar.** La lista en memoria solo cambia si SwiftData guardó bien. Si falla, se muestra el error y la interfaz no queda inconsistente.
- **Se guarda la película completa** en favoritos y Por ver, porque el catálogo popular de TMDB cambia cada día y la película podría dejar de aparecer en él.
- **Búsqueda contra la API**, no solo entre las películas cargadas, para encontrar cualquier película de TMDB. Espera 400 ms después de la última letra y usa `.task(id:)` para cancelar búsquedas anteriores.
- **Paginación sin duplicados.** "Cargar más" pide la siguiente página y descarta los `id` que ya estaban cargados. Si falla, conserva las películas existentes.
- **Reglas puras para los recordatorios.** `WatchlistReminder.makeReminders(from:today:)` recibe la fecha de hoy como parámetro, así se puede probar sin esperar 2 semanas.
- **Notificaciones locales**, no push: no se necesita servidor.
- **Token fuera del código.** `Secrets.swift` está en el `.gitignore`. Si falta, la app muestra un mensaje claro en lugar de fallar en silencio.
- **Idioma `es-MX`** en las solicitudes, porque la app está dirigida a usuarios en español.

---

## 5. Pruebas

74 pruebas unitarias (XCTest y Swift Testing) con el patrón **Arrange / Act / Assert**.

| Archivo | Pruebas | Qué cubre |
|---|---|---|
| `MoviesStoreTests` | 10 | Estado inicial, carga, vacío, errores, recuperación y paginación |
| `SearchViewModelTests` | 9 | Populares, buscando, resultados, mayúsculas/acentos, sin resultados, error, reintentar |
| `WatchlistStoreTests` | 9 | Agregar, repetida, error al guardar, quitar, programar y cancelar recordatorios |
| `HomeViewModelTests` | 8 | Top de la semana, mejor valorada, favoritos, Por ver, error, cargar más |
| `MovieDetailViewModelTests` | 8 | Favoritos y Por ver, errores, sincronización con Home, sugerencias |
| `FavoritesStoreTests` | 7 | Carga, agregar, repetida, límite de 20, errores |
| `TMDBMovieTests` | 5 | Decodificación del JSON, valores por defecto, JSON inválido |
| `WatchlistReminderTests` | 5 | Texto del recordatorio, cálculo de días y orden |
| `FavoritesServiceTests` | 4 | Persistencia real con SwiftData en memoria |
| `MovieTests` | 3 | Fecha de estreno en español y fecha inválida |
| `NotificationsViewModelTests` | 3 | Recordatorios y número de la campana |
| `WatchlistServiceTests` | 3 | Persistencia real con SwiftData en memoria |

---

## 6. Limitaciones conocidas

- **Requiere internet** para ver el catálogo y buscar. Solo favoritos y Por ver funcionan sin conexión, porque el catálogo no se guarda en caché.
- **Requiere iOS 26.5 y Xcode 26**, así que no corre en versiones anteriores ni en Windows.
- **El token viaja dentro de la app.** No hay un servidor intermedio, así que el token queda en el binario. Es aceptable para un proyecto escolar, no para una app publicada.
- **"Mejor valorada hoy" y "Top de la semana" se calculan localmente** a partir de la primera página de populares (las 5 y las 8 mejor calificadas). No usan el endpoint de tendencias de TMDB.
- **La búsqueda solo muestra la primera página** de resultados de TMDB (hasta 20 películas).
- **Las sugerencias del detalle** son las películas mejor calificadas del catálogo cargado, no recomendaciones de TMDB relacionadas con la película.
- **Límite de 20 favoritos.**
- **Recordatorio fijo de 14 días.** El usuario no puede cambiarlo, y si niega el permiso de notificaciones solo verá los recordatorios en la pantalla Notificaciones.
- **Algunas películas no tienen sinopsis en español**, y entonces se muestra "Sin sinopsis disponible.".
- **Sin pruebas de interfaz:** `MoonviesUITests` conserva la plantilla de Xcode.
