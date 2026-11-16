# Accesibilidad

Moonvies incorpora soporte de accesibilidad mediante **VoiceOver**, definiendo para cada elemento:

- **Etiqueta (`label`):** texto que VoiceOver lee en voz alta.
- **Trait:** identifica el tipo de elemento, como botón, encabezado, texto o campo de búsqueda.
- **Hint:** describe qué sucede al interactuar con el elemento cuando es necesario.

## 1. Home

### Header

- El **logo de Moonvies** se define como un **encabezado**, permitiendo identificar que el usuario se encuentra dentro de la aplicación.
- Los tres íconos del header funcionan como botones:
  - **Perfil:** se anuncia como `Perfil`, con el hint `Abre tu perfil`.
  - **Ajustes:** se anuncia como `Ajustes`, con el hint `Abre la configuración`.
  - **Notificaciones:** se anuncia como `Notificaciones`. Cuando existen avisos nuevos, se agrega el valor `Tienes notificaciones nuevas`.

### Búsqueda y pestañas

- La barra de búsqueda funciona como un botón con la etiqueta `Buscar películas` y el hint `Abre el buscador`.
- Las pestañas **Recomendado**, **Todo** y **Favoritos** funcionan como botones.
- La pestaña activa se anuncia adicionalmente como **seleccionada**.

### Contenido principal

- Los títulos **Mejor valorada hoy** y **Top de la semana** se definen como encabezados.
- El banner principal se anuncia como `Mejor valorada hoy`, seguido del título y año de la película.
- El botón **VER AHORA** se anuncia como `Ver ahora`, seguido del título de la película.
- Las estrellas se agrupan en un único texto accesible, por ejemplo: `Calificación 4.8 de 5`.
- Cada póster se anuncia con el título y año de la película y funciona como botón para acceder al detalle.
- En la pestaña **Favoritos**, cuando no existen películas guardadas, VoiceOver anuncia `Aún no hay favoritos`.

## 2. Buscar

La pantalla de búsqueda comienza con el título **Buscar**, definido como encabezado.

### Controles

- El botón de regreso se anuncia como `Regresar`.
- El campo de texto se identifica como un **campo de búsqueda** con la etiqueta `Buscar películas`.
- Cuando existe texto en el campo, aparece el botón **Borrar búsqueda**.

### Resultados

Cuando existen coincidencias:

1. VoiceOver anuncia primero la cantidad de resultados, por ejemplo: `3 resultados`.
2. Después anuncia cada película con su título, año y duración.
3. Cada resultado funciona como botón para acceder al detalle.

Cuando no existen coincidencias:

- Se anuncia el encabezado `No se encontraron resultados`.
- Aparece el botón **Intentar nuevamente**.

## 3. Detalle de película

### Encabezado y reproducción

- Se encuentra el botón **Regresar**.
- El título de la película se muestra como **encabezado**.
- El botón **Reproducir** permite iniciar la película.

### Información de la película

- El año y la duración se presentan en un formato natural para VoiceOver.
- La calificación se anuncia, por ejemplo, como `Calificación 4 de 5`.
- La sinopsis completa se presenta como texto accesible.

### Acciones

- **Ver ahora:** reproduce la película.
- **Agregar a favoritos:** aparece cuando la película no está guardada.
- **En favoritos:** aparece cuando la película ya está guardada.
- **Calificar:** permite abrir la ventana de calificación.
- **Descargar:** permite guardar la película para verla sin conexión.

### Sugerencias

**Sugerencias** se define como encabezado y cada película sugerida funciona como botón para acceder a su detalle.

## 4. Ventana de calificar

### Control de calificación

Las cinco estrellas se agrupan en un único control ajustable denominado **Calificación**.

- El valor indica la cantidad de estrellas seleccionadas, por ejemplo: `3 de 5 estrellas`.
- El hint indica: `Desliza hacia arriba o abajo para cambiar`.

### Botones

- **Enviar:** envía la calificación.
- El botón se muestra como atenuado mientras no se haya seleccionado ninguna estrella.
- El área de fondo funciona como botón **Cerrar sin calificar**.

## 5. Orden de navegación

VoiceOver recorre cada pantalla siguiendo un orden lógico, generalmente **de arriba hacia abajo y de izquierda a derecha**.

El orden general de navegación es:

1. **Encabezado:** logo o título de la pantalla.
2. **Botones del header.**
3. **Búsqueda o pestañas.**
4. **Contenido principal.**
5. **Botones y acciones.**
6. **Elementos secundarios**, como sugerencias.

En las filas horizontales de pósters, el foco de VoiceOver avanza **de izquierda a derecha**.

