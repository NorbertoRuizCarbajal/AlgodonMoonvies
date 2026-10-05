# AlgodonMoonvies
Aplicación de películas con TMDB

Objetivo: Permitir explorar películas, buscar una película, consultar su información y administrar favoritas.


Equipo 14: 

-Sánchez Baños Lizeth Marisol

-Ruiz Carbajal Norberto 


# Flujos

<img width="1536" height="1024" alt="1000045697" src="https://github.com/user-attachments/assets/18f0b106-2b1c-4435-8905-de3b22de47f9" />


1.- Home → Buscar → Resultados → Seleccionar película → Detalle

2.- Home → Buscar → Introducir búsqueda → No hay resultados → Regresar

3.- Home → Favoritos → Seleccionar película → Detalle

4.- Home → Película → Detalle → Agregar a Favoritos → Favoritos


# Especificación de pantallas

##  1. Pantalla Principal

**Descripción:**
La pantalla principal de la aplicación, desde donde el usuario puede explorar películas, realizar búsquedas y acceder a sus diferentes secciones.

###  Elementos
* **Encabezado:** Color turquesa.
* **Marca:** Nombre/logotipo de la aplicación *TMDB Movies*.
* **Controles principales:**
  * Botón para acceder a listas personalizadas.
  * Botón de Favoritos.
  * Botón de cuenta/perfil.
  * Barra de búsqueda.
* **Organización de contenido:**
  * Sección de películas populares de la semana.
  * Sección de películas por género (Ej. Acción y otros géneros disponibles).
  * Flechas para desplazarse horizontalmente entre las películas de cada sección.
* **Tarjetas de películas:** Cada una cuenta con:
  * Imagen
  * Título
  * Descripción

###  Interacciones
* **Al seleccionar la barra de búsqueda**  Dirige a la *Pantalla de búsqueda*.
* **Al seleccionar una película**  Dirige a *Detalle de película*.
* **Al seleccionar Favoritos**  Dirige a la pantalla de *Favoritos*.
* **Al seleccionar Listas**  Dirige a *Listas personalizadas*.
* **Al seleccionar Perfil**  Dirige a la *Cuenta del usuario*.
* **Al interactuar con las flechas**  Permite navegar/desplazarse entre las películas de cada categoría.
  <img width="594" height="1184" alt="1000045641" src="https://github.com/user-attachments/assets/3545a10a-e94a-4e2c-aeba-cd8ba1468925" />


## 2. Buscar película

**Descripción:**
Pantalla destinada a que el usuario introduzca el nombre de una película y consulte los resultados disponibles.

### Elementos
* **Encabezado:** Color turquesa con el título "Buscar".
* **Controles principales:**
  * Botón de regreso.
  * Barra de búsqueda con icono de búsqueda.
  * Botones de configuración/notificaciones.

### Interacciones
* **Al introducir el nombre de una película** -> El sistema procesa la búsqueda.
  * **Si existen coincidencias** -> Dirige a *Resultados de búsqueda*.
  * **Si no existen coincidencias** -> Dirige a *No se encontraron resultados*.
* **Al seleccionar el botón de regreso** -> Devuelve a la pantalla *Home*.
<img width="577" height="1184" alt="1000045644" src="https://github.com/user-attachments/assets/69e3184a-04c3-4207-9afa-be4654d88520" />

---

## 3. No se encontraron resultados

**Descripción:**
Pantalla que informa al usuario cuando la búsqueda realizada no devuelve ninguna película.

### Elementos
* **Encabezado:** Color turquesa.
* **Navegación:** Botón de regreso.
* **Búsqueda:** Barra de búsqueda con el término introducido.
* **Aviso:** Mensaje central indicando: *“No se encontraron resultados”*.

### Interacciones
* **En la barra de búsqueda** -> El usuario puede modificar o realizar una nueva búsqueda.
* **Al seleccionar el botón de regreso** -> Permite regresar a la pantalla anterior.

### Flujo
Buscar -> Introducir película -> No se encontraron resultados -> Nueva búsqueda / Regresar
<img width="573" height="1172" alt="1000045647" src="https://github.com/user-attachments/assets/b88b0e6d-8478-4179-b304-357f1f5ad20e" />

---

## 4. Favoritos

**Descripción:**
Pantalla donde el usuario puede consultar las películas que ha marcado como favoritas.

### Elementos
* **Encabezado:** Barra superior turquesa.
* **Búsqueda:** Barra de búsqueda.
* **Pestañas de navegación:**
  * Recomendado
  * Todo
  * **Favoritos** (Esta pestaña aparece seleccionada).
* **Contenido:** Cuadrícula de películas favoritas mostrando el póster de cada película.

### Interacciones
* **Al seleccionar una película** -> Dirige a *Detalle de película*.
* **En las pestañas** -> El usuario puede consultar diferentes categorías.
* **En la barra de búsqueda** -> Permite localizar películas específicas.
* **Sincronización:** Una película agregada desde la pantalla de detalle aparecerá automáticamente en esta sección.

### Flujo
Home -> Favoritos -> Seleccionar película -> Detalle

<img width="580" height="1176" alt="1000045650" src="https://github.com/user-attachments/assets/ef32b797-8def-4dae-b33f-e0deb013f754" />

---

## 5. Detalle de película

**Descripción:**
Pantalla que presenta la información completa de una película seleccionada.

### Elementos
* **Navegación:** Botón para regresar.
* **Cabecera:** 
  * Nombre de la película.
  * Imagen/video de portada con botón de reproducción.
* **Información técnica:** Año de estreno, duración y calificación mediante estrellas.
* **Sinopsis:** Descripción de la trama.
* **Acciones principales:**
  * Botón *Ver ahora*.
  * Opción *Agregar a Favoritos*.
  * Opción *Calificar*.
  * Opción *Descargar*.
* **Sección de Sugerencias:** Películas recomendadas relacionadas.

### Interacciones
* **Botón "Ver ahora"** -> Inicia la reproducción de la película.
* **Opción "Agregar a Favoritos"** -> Agrega la película a la lista de favoritos del usuario.
* **Opción "Calificar"** -> Permite registrar una valoración.
* **Opción "Descargar"** -> Inicia la descarga del contenido.
* **Al seleccionar una sugerencia** -> Abre el *Detalle de película* de esa recomendación.
* **Botón de regresar** -> Vuelve a la pantalla anterior.

### Flujo
Seleccionar película -> Detalle -> Ver ahora / Favoritos / Calificar / Descargar
<img width="563" height="1167" alt="1000045653" src="https://github.com/user-attachments/assets/542aa4fe-b827-41a1-9f12-59f4ac1ad3c2" />


6. Calificar película

Descripción: Ventana emergente que aparece sobre la pantalla de Detalle de película cuando el usuario selecciona la opción "Calificar", permitiéndole asignar una puntuación con estrellas.

Elementos

Fondo: La pantalla de Detalle de película se desenfoca (pierde nitidez) para dar contexto visual detrás del modal.
Modal emergente:
Texto "Toca para calificar".
Cinco estrellas seleccionables.
Botón "Enviar".


Interacciones

Al tocar una estrella -> Se marca la calificación correspondiente (1 a 5).
Al presionar "Enviar" -> Se guarda la calificación y se cierra el modal, regresando a la pantalla de Detalle.

Flujo

Detalle de película -> Calificar -> Se desenfoca el fondo y aparece el modal -> Tocar estrellas -> Enviar -> Regresa a Detalle


<img width="414" height="896" alt="PHOTO-2026-09-25-11-52-48" src="https://github.com/user-attachments/assets/66026066-63a4-4944-af14-be5d69ea4d9d" />


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
