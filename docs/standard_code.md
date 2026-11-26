# Estándar de código · RutaViva

Las reglas con las que se escribe el código de esta app. Parte del estándar del
curso (`.agents/skills/sdd-implementar/assets/standard_code.md`) y lo ajusta a lo
que el equipo ya construyó en la Entrega 2. El implementador las sigue siempre, y si
una spec técnica dice otra cosa, gana este archivo.

## Carpetas

- `lib/main.dart`: arranque de Supabase, el `MaterialApp` y la tabla de rutas nombradas.
- `lib/config.dart`: la URL y la publishable key, leídas de `env.json` (AD-06).
- `lib/models/`: los modelos, con `fromMap` (y `toMap` cuando se escriben).
- `lib/services/`: las únicas clases que hablan con Supabase o con el dispositivo (la galería).
- `lib/state/`: `AppStore`, el estado compartido de la sesión, y `DatosIniciales`.
- `lib/components/`: widgets reutilizables.
- `lib/screens/`: `XxxScreen`, pantallas anfitrionas con estado y navegación.
- `lib/pages/`: `XxxPage`, la vista de una Screen. No guardan datos de la app.
- `lib/utils/`: formato es-CO, colores por estado y mensajes de error.

## Quién guarda estado

1. Las **Screens** (`StatefulWidget` cuando tienen estado propio: filtros, cargando, error).
2. Los **formularios** y diálogos con campos de texto, que guardan solo su borrador.
3. `AppStore` (un `ChangeNotifier`), que guarda los datos de la flota de la sesión.
   Lo crea y lo posee `HomeScreen` (estado elevado) y lo reparte a las Screens de
   cada sección por el constructor. Ninguna Page ni componente lo recibe.

Las Pages y los componentes son `StatelessWidget`.

## Cómo se mueve el estado

- Los datos **bajan** por el constructor. Los eventos **suben** con funciones.
- En código nuevo los eventos son `Function()` o `Function(Tipo)`. Los componentes
  de la Entrega 2 usan `VoidCallback` y `ValueChanged`: no se cambian por cambiar.
- `AppStore` cambia sus listas solo después de que Supabase confirmó la operación,
  y avisa con `notifyListeners()`.

## Supabase

- Las Screens (o `AccionesMantenimiento`, que actúa por ellas) llaman a los
  servicios; los servicios llaman a Supabase. Solo los servicios usan
  `Supabase.instance.client`.
- Los métodos que van a Supabase devuelven un `Future` y se usan con `await`, dentro
  de `try`/`catch`. El error se muestra con `mensajeDeError(e)` de
  `lib/utils/errores.dart`, en un `SnackBar` o en la pantalla.
- Mientras una operación está en curso, su botón se deshabilita (`onPressed: null`).
- Después de un `await`, `if (!mounted) return;` (o `if (!context.mounted) return;`)
  antes de usar `context` o `setState`.

## Navegación

- Rutas nombradas en `routes:` del `MaterialApp`: `/login`, `/registro`, `/home`,
  `/evidencias`. Un dato viaja en `arguments`.
- La ruta inicial depende de la sesión; al cerrar sesión, `pushNamedAndRemoveUntil`.
- El detalle de vehículo se abre con `MaterialPageRoute` porque recibe el `AppStore`.

## Escritura

- Nombres en español, como el modelo de datos y el código de la Entrega 2
  (excepción al estándar del curso, que pide inglés). Los textos de la interfaz, en
  español de Colombia (RNF-03).
- Imports relativos dentro de `lib/`, como en la Entrega 2.
- Una línea `///` que describe cada clase pública. Comentarios solo donde una
  decisión no se entiende leyendo el código.
- Columnas de Supabase en `snake_case`; propiedades de Dart en `camelCase`.
