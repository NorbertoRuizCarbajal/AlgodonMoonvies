# AlgodonMoonvies

Aplicación iOS de películas con la API de **TMDB** (Opción A del proyecto integrador).

**Objetivo:** permitir explorar películas, buscar una película, consultar su información, administrar favoritas y recordar las películas pendientes por ver.

**Equipo 14:**

- Sánchez Baños Lizeth Marisol
- Ruiz Carbajal Norberto

---

## Cómo ejecutar el proyecto

1. Abre `Moonvies.xcodeproj` en **Xcode 26** o superior (deployment target iOS 26.5).
2. Crea el archivo `Moonvies/Config/Secrets.swift` (ya está en el `.gitignore`, el token no se sube al repositorio):

   ```swift
   import Foundation

   enum Secrets {
       static let tmdbToken = "TU_TOKEN"
   }
   ```

3. Pega tu **API Read Access Token** de TMDB en `tmdbToken` (se obtiene en themoviedb.org → Ajustes → API).
4. Elige un simulador de iPhone y corre la app con **Cmd + R**.
5. Para correr las pruebas: **Cmd + U** (resultados en el navegador de pruebas, **Cmd + 6**).

Si falta el token, la app muestra el mensaje "Falta el token de TMDB" en lugar de fallar en silencio.

---

## Flujos

<img width="1536" height="1024" alt="Diagrama de flujo" src="https://github.com/user-attachments/assets/18f0b106-2b1c-4435-8905-de3b22de47f9" />

| # | Flujo | Cómo se recorre en la app |
|---|---|---|
| 1 | Inicio → lista de películas → detalle | Home → pestaña **Recomendado** o **Todo** → tocar una película |
| 2 | Inicio → búsqueda → resultados → detalle | Home → barra de búsqueda → escribir → tocar un resultado |
| 3 | Búsqueda sin resultados | Buscar → escribir algo que no existe → "No se encontraron resultados" → **Intentar nuevamente** |
| 4 | Inicio → favoritos → película guardada → detalle | Home → pestaña **Favoritos** → tocar una película |
| 5 | Detalle → agregar a favoritos | Detalle → **Agregar a favoritos** → aparece en la pestaña Favoritos |
| 6 | Detalle → Por ver → recordatorio | Detalle → **Agregar a Por ver** → a las 2 semanas llega la notificación → Home → campana → recordatorio → detalle |

---

## Funcionalidades

### MVP (rúbrica)

- **Lista de películas desde TMDB** (`GET /3/movie/popular`) con póster, título, año y calificación.
- **Búsqueda en TMDB** (`GET /3/search/movie`) con resultados en tiempo real mientras se escribe.
- **Búsqueda sin resultados:** mensaje y botón "Intentar nuevamente".
- **Detalle** con póster, título, **fecha de estreno**, calificación de TMDB, sinopsis y sugerencias.
- **Agregar y quitar favoritas**, con límite de 20 y mensajes de confirmación o error.
- **Persistencia local** de favoritos y de Por ver con **SwiftData** (no se pierden al cerrar la app).
- **Estados de UI:** cargando, error con "Reintentar", catálogo vacío, sin resultados, favoritos vacíos y Por ver vacío.

### Funcionalidades adicionales

- **Paginación:** botón "Cargar más" en la pestaña Todo (sin repetir películas).
- **Por ver:** lista de películas para ver después, guardada en el dispositivo.
- **Notificaciones de Por ver:** recordatorio cuando una película lleva 2 semanas pendiente (ver abajo).

---

## Pantallas

### 1. Home
- Header cian con el logo **Moonvies**, la **campana de notificaciones** y la barra de búsqueda.
- La campana muestra un número rojo con los recordatorios pendientes.
- Pestañas: **Recomendado** (mejor valorada hoy + top de la semana), **Todo** (catálogo con paginación), **Favoritos** y **Por ver**.

### 2. Buscar
- Botón de regresar y campo de texto.
- Campo vacío → "Populares en Moonvies".
- Con texto → busca en TMDB: "Buscando películas...", resultados, "No se encontraron resultados" o el error con "Reintentar".

### 3. Detalle de película
- Botón de regresar y botón para volver a Home.
- Póster, fecha de estreno, estrellas con la calificación de TMDB y sinopsis.
- Acciones: **Agregar a favoritos** y **Agregar a Por ver**.
- Sugerencias: otras películas bien calificadas del catálogo.

### 4. Notificaciones
- Se abre con la campana de Home.
- Lista de películas que llevan 2 semanas o más en Por ver, con el mensaje
  *"Hace 2 semanas tienes pendiente por ver …"*. Tocar una abre su detalle.
- Si no hay pendientes, muestra "No tienes películas pendientes por ahora".

---

## Notificaciones de "Por ver"

Cuando el usuario agrega una película a **Por ver**:

1. `WatchlistStore` guarda la película **con la fecha** en SwiftData.
2. Si se guardó bien, pide a `NotificationService` programar una **notificación local** para dentro de 14 días:
   *"Hace 2 semanas tienes pendiente por ver Coco"*. La primera vez, iOS pide permiso al usuario.
3. Si la película se quita de Por ver, el recordatorio se cancela.
4. La pantalla **Notificaciones** calcula, con la fecha guardada, qué películas llevan 14 días o más pendientes.

No se necesita servidor: son notificaciones locales (`UserNotifications`). `NotificationDelegate` permite que también se vean si la app está abierta.

**Cómo probarlo en clase sin esperar 2 semanas:** en `Models/WatchlistReminder.swift` cambia `minimumDays` de `14` a `0`. Al agregar una película a Por ver, la notificación llega a los 5 segundos y la película aparece de inmediato en la pantalla Notificaciones. Después regrésalo a `14`.

---

## Tecnologías

| Tema | Cómo se usa |
|---|---|
| **SwiftUI** | Toda la interfaz, con componentes reutilizables (`PosterView`, `MessageView`, `LoadStateView`, etc.) |
| **Navegación** | `NavigationStack` con `path` y el enum `Route` (`search`, `notifications`, `detail`) en `RootView` |
| **Estado** | `@Observable`, `@State`, `@Binding`, `@Environment` y stores compartidos como fuente única de verdad |
| **Networking** | `URLSession` + `async/await` en `MovieService`, con token Bearer y validación del código HTTP |
| **Codable** | `TMDBMoviesResponse` y `TMDBMovie` (`Decodable` + `CodingKeys`), convertidos al modelo `Movie` |
| **Persistencia** | SwiftData: `FavoriteMovie` y `WatchlistMovie` (`@Model`), `ModelContext`, `FetchDescriptor` y `#Predicate` |
| **Concurrencia** | `async/await`, `Task`, `.task(id:)` para cancelar búsquedas viejas, `@MainActor` |
| **Errores** | `MovieError`, `FavoriteError` y `WatchlistError` con mensajes claros para el usuario |
| **Notificaciones** | `UserNotifications` (`UNTimeIntervalNotificationTrigger`) |
| **Pruebas** | XCTest y Swift Testing, con mocks de todos los servicios |

---

## Arquitectura (MVVM + servicios)

```
Views ──▶ ViewModels ──▶ Stores (estado compartido) ──▶ Services (protocolos) ──▶ TMDB / SwiftData / iOS
```

| Capa | Archivos | Responsabilidad |
|---|---|---|
| **Models** | `Movie`, `TMDBMovie`, `FavoriteMovie`, `WatchlistMovie`, `WatchlistItem`, `WatchlistReminder`, `LoadState`, `SearchResult`, errores | Datos y reglas puras (fecha en español, texto de los recordatorios) |
| **Services** | `MovieService`, `FavoritesService`, `WatchlistService`, `NotificationService`, `PersistenceController` | Acceso a la API, a SwiftData y a las notificaciones. Cada uno tiene su **protocolo** |
| **State** | `MoviesStore`, `FavoritesStore`, `WatchlistStore` | Fuente única de verdad, compartida por todas las pantallas |
| **ViewModels** | `HomeViewModel`, `SearchViewModel`, `MovieDetailViewModel`, `NotificationsViewModel` | Preparan los datos de cada pantalla y reaccionan a las acciones del usuario |
| **Views** | `Views/Home`, `Search`, `Detail`, `Notifications`, `Components` | Solo dibujan y avisan al ViewModel |
| **Navigation** | `RootView`, `Route` | Pila de navegación y creación de cada ViewModel con sus dependencias |

### Decisiones técnicas

- **Inyección de dependencias por protocolo:** los stores reciben `MovieServiceProtocol`, `FavoritesServiceProtocol`, `WatchlistServiceProtocol` y `NotificationServiceProtocol`. Así los tests usan mocks y no tocan internet, la base de datos ni las notificaciones reales.
- **Stores compartidos:** Home, Detalle y Notificaciones leen el mismo `FavoritesStore` y `WatchlistStore`, por eso un favorito agregado en Detalle aparece al instante en Home.
- **Guardar primero, actualizar después:** la lista en memoria solo cambia si SwiftData guardó bien. Si falla, se muestra el error y la interfaz no queda inconsistente.
- **Se guarda la película completa** en favoritos y Por ver, porque el catálogo popular de TMDB cambia cada día.
- **La búsqueda usa la API**, no solo las películas cargadas, para encontrar cualquier película de TMDB. Espera 400 ms después de la última letra para no hacer una solicitud por cada tecla.
- **Las reglas de los recordatorios son funciones puras** (`WatchlistReminder.makeReminders(from:today:)`): reciben la fecha de hoy, por eso se pueden probar sin esperar 2 semanas.

### Estructura de carpetas

```
Moonvies/
├── Config/          Secrets.swift (no se sube)
├── Models/
├── Navigation/
├── Services/
├── State/
├── Utilities/       AppTheme, makeRows
├── ViewModels/
└── Views/
    ├── Components/
    ├── Detail/
    ├── Home/
    ├── Notifications/
    └── Search/
MoonviesTests/
└── Mocks/           MockMovieService, MockFavoritesService, MockWatchlistService, MockNotificationService, TestMovies
```

---

## Pruebas

Siguen el patrón **Arrange / Act / Assert**.

| Archivo | Qué prueba |
|---|---|
| `MoviesStoreTests` (XCTest) | Estado inicial, carga, vacío, errores específicos, recuperación y paginación |
| `HomeViewModelTests` | Top de la semana, mejor valorada del día, favoritos, Por ver, error y "Cargar más" |
| `SearchViewModelTests` | Populares con campo vacío, buscando, resultados, mayúsculas/acentos/espacios, sin resultados, error y "Intentar nuevamente" |
| `MovieDetailViewModelTests` | Agregar/quitar favoritos y Por ver, errores al guardar, sincronización con Home, sugerencias y recordatorio programado |
| `FavoritesStoreTests` | Carga, agregar, repetida, límite de 20, fallas al guardar y al quitar |
| `WatchlistStoreTests` | Agregar, repetida, falla al guardar, quitar, programar y cancelar recordatorios |
| `WatchlistReminderTests` | Texto "Hace 2 semanas…", días/semanas, películas recientes vs. antiguas y orden |
| `NotificationsViewModelTests` | Recordatorios de la pantalla y número de la campana |
| `FavoritesServiceTests`, `WatchlistServiceTests` | Persistencia real con SwiftData en memoria |
| `TMDBMovieTests` | Decodificación del JSON, valores por defecto y JSON inválido |
| `MovieTests` | Fecha de estreno en español y fecha inválida |

---

## Fuera del alcance

Siguiendo la rúbrica, no se incluyen login/perfiles, reseñas ni calificaciones propias del usuario, recomendaciones personalizadas, trailers ni funciones sociales.
