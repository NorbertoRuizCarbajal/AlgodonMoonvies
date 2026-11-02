# Testing, persistencia y servicio de películas — Moonvies

## 1. Cambios en Home

Se quitaron los íconos de **perfil** y **notificaciones** del header, porque la app no va a tener esas funciones. El header queda con el logo, el ícono de ajustes y la barra de búsqueda. Como el punto rojo de `CircleIconView` solo existía para notificaciones, también se quitó, junto con el color `badge` de `AppTheme`.

## 2. Servicio de películas

El catálogo se obtiene a través de un servicio, siguiendo la estructura vista en clase:

- **`MovieServiceProtocol`** define el contrato `fetchMovies() async throws -> [Movie]`. La app solo conoce este protocolo, así que el origen de los datos se puede cambiar (datos locales, la API de TMDB o un mock en los tests) sin tocar ViewModels ni vistas.
- **`MovieService`** es la implementación actual. Regresa el catálogo local y simula el tiempo de respuesta de una API con una espera de 500 ms.
- **`MoviesStore`** controla la llamada: pasa de `loading` a `loaded` si el servicio responde, o a `error` si falla. Home usa ese estado para mostrar "Cargando películas..." o el error con el botón "Reintentar".

`MovieRepository` y `MockMovieRepository` se reemplazaron por `MovieServiceProtocol` y `MovieService`, para usar los mismos nombres que en clase.

## 3. Persistencia de favoritos con SwiftData

Los favoritos ya no se pierden al cerrar la app.

- **`FavoriteMovie`** (`@Model`) es lo que se guarda en el dispositivo: el id de la película y la fecha en que se agregó. Los demás datos vienen del catálogo, para no duplicarlos.
- **`FavoritesServiceProtocol`** define tres operaciones: `fetchFavoriteIDs()`, `saveFavorite(movieID:)` y `removeFavorite(movieID:)`. Guardar y quitar son `throws`, para poder avisar si algo falla.
- **`FavoritesService`** las implementa con un `ModelContext`:
  - `fetch` con `FetchDescriptor` ordenado del más reciente al más antiguo.
  - `insert` para guardar.
  - `#Predicate` para encontrar el favorito a borrar.
  - `save()` después de cada cambio.
- **`PersistenceController`** crea el `ModelContainer`. La app lo usa guardando en disco; los `#Preview` y los tests lo usan en memoria, para no tocar los favoritos reales.

**Flujo:**

1. Al abrir la app, `FavoritesStore` carga los favoritos guardados.
2. Al tocar el corazón, primero se guarda con el servicio y **solo si funcionó** se actualiza la lista.
3. Si falla, se lanza `FavoriteError.saveFailed` (o `removeFailed`) y el Detalle muestra el mensaje de error. Es la rama "No" del rombo "¿Se agregó a favoritos?".

## 4. Pruebas

Los tests están en `MoonviesTests` y siguen el patrón **Arrange / Act / Assert**. Para no depender de datos reales se usan mocks de los servicios:

- **`MockMovieService`** regresa las películas que se le pasan o un error.
- **`MockFavoritesService`** guarda los ids en un arreglo y puede simular que guardar falla.
- **`TestMovies`** contiene películas de prueba con calificaciones distintas, para comprobar el orden.

| Archivo | Framework | Qué prueba |
|---|---|---|
| `MoviesStoreTests` | XCTest | Estado inicial, carga correcta, error del servicio y búsqueda por id |
| `SearchViewModelTests` | Swift Testing | Populares con el campo vacío, resultados de "Bajo", búsqueda sin importar mayúsculas ni acentos (con `@Test(arguments:)`), "No se encontraron resultados" e "Intentar nuevamente" |
| `HomeViewModelTests` | Swift Testing | Top de la semana ordenado y con máximo 8, mejor valorada del día entre las 5 mejores, orden de favoritos y estado de error |
| `FavoritesStoreTests` | Swift Testing | Carga inicial, agregar, repetida, límite, falla al guardar y quitar |
| `MovieDetailViewModelTests` | Swift Testing | Mensajes de agregar, quitar y error; que un favorito agregado en Detalle aparezca en Home; sugerencias |
| `FavoritesServiceTests` | Swift Testing + SwiftData en memoria | Guardar, orden, borrar y que los favoritos sigan ahí con un contexto nuevo (como al volver a abrir la app) |

**Para correrlos:** en Xcode, **Cmd + U**. Los resultados aparecen en el navegador de pruebas (**Cmd + 6**).
