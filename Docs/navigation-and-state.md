# Navegación y estado de Moonvies

## 1. Pantallas del MVP

1. Home. Pantalla principal y raíz donde empieza la navegación. Tiene tres pestañas: Recomendado, Todo y Favoritos. Las pestañas son secciones de la misma pantalla, no pantallas separadas.
2. Buscar. Permite filtrar el catálogo de películas por título en tiempo real. Tiene dos estados visibles: con resultados y sin resultados.
3. Detalle de película. Muestra toda la información de una película y las acciones sobre ella: ver ahora, agregar a favoritos, calificar y descargar.
4. Calificar. Ventana emergente que aparece encima del Detalle, con el fondo borroso. No es una pantalla de la pila de navegación, sino una presentación temporal.

## 2. Mapa de navegación

Home es la base de la navegación. Buscar y Detalle se apilan encima de ella: el usuario entra tocando elementos y regresa en orden inverso. Desde Detalle, el botón de regresar lleva a la pantalla anterior, que puede ser Home o Buscar según por dónde entró. Una sugerencia abre otro Detalle encima del actual. Calificar se abre sobre el Detalle y, al cerrarse, el usuario sigue en el mismo Detalle.

## 3. Información por pantalla

### Home

Muestra: el header con el logo, la barra de búsqueda y las pestañas. En Recomendado, la película mejor valorada del día y el top de la semana. En Todo, filas de películas por categoría. En Favoritos, la cuadrícula de películas guardadas o el texto "Aún no hay favoritos". También muestra los estados de carga y de error del catálogo.

Recibe: nada por navegación, porque es la pantalla raíz. Lee del estado compartido el catálogo de películas y la lista de favoritos.

Modifica:la pestaña seleccionada. También inicia la carga del catálogo al abrir la app y la vuelve a intentar si hubo un error.

Conserva:la pestaña seleccionada mientras el usuario entra a Buscar o a un Detalle y regresa. Como Home permanece en la base de la pila, su estado no se pierde.

### Buscar

Muestra:el campo de texto y, según lo que busque, una de tres cosas: las películas populares cuando el campo está vacío, la lista de coincidencias (título, año y duración), o el mensaje "No se encontraron resultados".

Recibe:el catálogo de películas, desde el estado compartido.

Modifica: el texto de búsqueda. 

Necesita conservar: el texto escrito mientras el usuario abre un Detalle y regresa, para que vea los mismos resultados. Los resultados no se guardan: se calculan cada vez a partir del texto y del catálogo.

### Detalle de película

Muestra: título, póster, año, duración, calificación, sinopsis, director, los botones Ver ahora, Agregar a favoritos, Calificar y Descargar, y una fila de sugerencias.

Recibe: la película seleccionada, que llega por la navegación como un valor de solo lectura. También lee del estado compartido si la película está en favoritos, la calificación que el usuario le dio y el catálogo para armar las sugerencias.

Modifica: la lista de favoritos (agregar o quitar), la calificación del usuario, si la ventana de calificar está abierta y el mensaje de confirmación o error.

Necesita conservar: al salir no guarda nada propio. Lo importante, como el favorito y la calificación, ya quedó en el estado compartido, así que al volver a abrir la misma película se ve actualizado. La ventana abierta, el borrador de estrellas y los mensajes son temporales.

### Calificar

Muestra: el título "Toca para calificar", las cinco estrellas y el botón "Enviar", que solo se activa con al menos una estrella elegida.

Recibe: desde el Detalle, el número de estrellas seleccionadas y si la ventana está abierta. Si el usuario ya había calificado la película, la ventana abre con esa calificación.

Modifica: las estrellas elegidas como borrador y el cierre de la ventana. Al tocar "Enviar", el Detalle guarda la calificación en el estado compartido y muestra la confirmación.

Necesita conservar: nada. Es temporal, si se cierra sin enviar, el borrador se descarta.

## 4. Organización del estado

Pusimos tres reglas:

1. Una sola fuente de verdad. Cada dato tiene un solo dueño. Las demás vistas lo leen o lo modifican a través de él, sin hacer copias.
2. El estado vive lo más abajo posible.** Un dato sube a un nivel superior solo si varias pantallas lo comparten o si debe sobrevivir a la navegación.
3. **Lo que se puede calcular no se guarda.** Los datos derivados se calculan a partir de otros, para que nunca se desincronicen.

### Estado compartido (vive en `MoonviesApp`)

Se crea una sola vez con `@State` en la App y se reparte a todas las vistas con `.environment(...)`. Cada vista lo lee con `@Environment(Tipo.self)`.

- **Catálogo de películas y estado de carga.** Viven en un `MoviesStore` (`@Observable`), que guarda un `LoadState` con los casos idle, loading, loaded y error. Lo usan Home, Buscar y Detalle. Cargarlo una sola vez evita que cada pantalla tenga su propia copia y que puedan mostrar datos distintos.
- **Favoritos.** Viven en un `FavoritesStore` (`@Observable`) como una lista de identificadores de película. Detalle los modifica y la pestaña Favoritos los lee. Al ser una sola fuente, el corazón del Detalle y la pestaña Favoritos siempre coinciden. Se guardan los identificadores y no copias de las películas, para no duplicar datos del catálogo.
- **Calificaciones del usuario.** Viven en un `RatingsStore` (`@Observable`) como un diccionario de identificador a número de estrellas. Deben sobrevivir cuando el usuario sale del Detalle y vuelve a entrar. Están separadas de los favoritos porque son una responsabilidad distinta.

En el MVP estos datos viven en memoria y se pierden al cerrar la app. Guardarlos de forma permanente (con UserDefaults o SwiftData) queda para una etapa posterior.

### Estado de navegación (vive en `RootView`)

- **Ruta de navegación.** Un arreglo de rutas (`[Route]`) guardado con `@State` en la vista raíz. Es el único lugar que conoce todas las pantallas, y desde ahí se puede regresar a Home vaciando el arreglo.

### Estado local de cada pantalla

- **Pestaña seleccionada.** `@State` en `HomeView`. Solo le importa a Home. El selector de pestañas la recibe con `@Binding` para poder cambiarla.
- **Texto de búsqueda.** `@State` en `SearchView`. Solo lo usa Buscar. Con una navegación de pila, Buscar sigue existiendo mientras el usuario está en el Detalle, así que el texto se conserva sin subirlo a la App. Al salir de Buscar se descarta, que es lo esperado.
- **Resultados de búsqueda.** No se guardan. Se calculan a partir del texto y del catálogo, y se representan con un enum de tres casos: populares, encontrados y sin resultados.
- **Película del Detalle.** No se guarda en ningún store. Viaja como valor dentro de la ruta. `Movie` es un `struct` inmutable y el Detalle solo la lee. Una "película actual" global causaría problemas al abrir un Detalle encima de otro desde las sugerencias.
- **Ventana de calificar abierta y estrellas en borrador.** `@State` en el Detalle. La ventana las recibe con `@Binding`. El borrador solo pasa al `RatingsStore` cuando el usuario toca "Enviar".
- **Mensaje de confirmación o error.** `@State` en el Detalle, porque es la única pantalla del MVP que produce estos mensajes.
- **Favorito guardándose.** Vive en `FavoritesStore`, porque la operación de guardar ocurre ahí. El Detalle lo lee para desactivar el botón mientras termina.

## 5. Estrategia de navegación

### Cómo se mueve el usuario

- **Navegación en pila para Buscar y Detalle.** El usuario avanza tocando elementos y regresa con el botón de regresar o deslizando desde el borde izquierdo. Este patrón es el que espera un usuario de iOS y coincide con el diagrama de flujo.
- **Presentación modal para Calificar.** La ventana aparece encima del Detalle, con el fondo borroso, y se cierra al enviar o al tocar fuera. No forma parte de la pila, porque al cerrarla el usuario debe seguir exactamente donde estaba.
- **Pestañas de Home como estado local.** Cambiar de pestaña no es navegar a otra pantalla: solo cambia el contenido de Home según la pestaña seleccionada.

### Mecanismos de SwiftUI evaluados

**`NavigationStack` con `NavigationLink(value:)` y `navigationDestination(for:)` (elegido).** Se define un enum con las rutas posibles y la pila guarda un arreglo de ellas:

```swift
enum Route: Hashable {
    case search
    case detail(Movie)
}
```

**Enum + `switch` en un `@State`.** Una propiedad guarda la pantalla actual y la vista raíz hace un `switch` para mostrarla. Usa solo temas vistos en clase, pero no tiene gesto de regresar y el historial se maneja a mano. Además, cada pantalla se destruye al cambiar, así que pierde su estado; por ejemplo, el texto de búsqueda tendría que subirse a la App. Lo descartamos porque complica justo lo que `NavigationStack` resuelve.

**`TabView`.** Crea una barra de pestañas en la parte inferior. Lo descartamos porque en el diseño las pestañas están debajo del header de Home y no son secciones independientes de la app.

**`NavigationSplitView`.** Muestra columnas lado a lado, pensado para iPad. No aplica a una app de iPhone con flujo lineal.

**Presentaciones modales: `.sheet`, `.fullScreenCover` o una capa con `ZStack`.** Para Calificar elegimos una capa con `ZStack` y `.blur` sobre el contenido, porque el mockup muestra una tarjeta en la parte inferior con el fondo borroso visible. Un `.sheet` con altura reducida es una alternativa válida si se prefiere el comportamiento estándar del sistema.

### Cómo se conecta cada paso

- **Home a Buscar.** La barra de búsqueda es un `NavigationLink(value: Route.search)`.
- **Home, Favoritos, Buscar o Sugerencias a Detalle.** Cada póster o resultado es un `NavigationLink(value: Route.detail(movie))`. La película viaja dentro de la ruta.
- **Detalle a Calificar.** Un botón cambia a `true` el `@State` que controla la ventana.
- **Calificar a Detalle.** Enviar o tocar fuera cambia ese estado a `false` a través del `@Binding`.
- **Regresar.** Botón de regresar con `@Environment(\.dismiss)` o gesto de deslizar.
- **Regresar a Home.** Vaciar el arreglo de rutas con `path.removeAll()`.


### Cómo llega la información a cada pantalla

- **Por la ruta:** la película que se va a mostrar en el Detalle.
- **Por el entorno (`@Environment`):** el catálogo, los favoritos y las calificaciones, que comparten varias pantallas.
- **Por `@Binding`:** el estado que una vista hija necesita leer y cambiar, como la pestaña seleccionada o las estrellas de la ventana de calificar.

## 6. Siguientes pasos

La implementación seguirá este orden:

1. Crear los stores compartidos.
2. Montar el `NavigationStack` con el enum `Route`.
3. Conectar Home con Buscar y Detalle.
4. Agregar favoritos y la ventana de calificar.
5. En una etapa después, guardar favoritos y calificaciones de forma permanente.
