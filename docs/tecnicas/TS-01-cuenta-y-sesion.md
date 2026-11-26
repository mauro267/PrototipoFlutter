---
id: TS-01
titulo: Cuenta y sesión
version: 1.0.0
fecha: 2026-11-26
estado: aprobada
funcional: F-01 1.0.0
responsable: Mauricio Marín
---

# TS-01 · Cuenta y sesión

## Resumen

Supabase Auth con correo y contraseña reemplaza el login simulado. `AuthService`
envuelve Auth y `UsuarioService` crea y lee la fila de `usuario` enlazada por
`auth_uuid` (AD-03). La ruta inicial depende de la sesión guardada.

## Preparación en Supabase

1. Proyecto del equipo creado; la Project URL y la publishable key en `env.json`
   (copia de `env.example.json`, que no se sube).
2. Migración `initial_schema` subida (`npx supabase db push --remote`): crea `usuario`.
3. *Authentication → Sign In / Providers → Email*: **Confirm email** apagado.

## Piezas

- `pubspec.yaml` · **cambia** (T-01) · `supabase_flutter: ^2.18.3`.
- `env.example.json` · **nueva** (T-01) · `SUPABASE_URL` y `SUPABASE_PUBLISHABLE_KEY` vacías.
- `lib/config.dart` · **nueva** (T-01) · `Config.supabaseUrl`, `Config.supabaseKey` con `String.fromEnvironment`; `Config.completa`.
- `lib/main.dart` · **cambia** (T-01) · `main` async con `Supabase.initialize`; si falta la configuración muestra `ConfigFaltanteApp`. Rutas `/login`, `/registro`, `/home`, `/evidencias`; `initialRoute` según `AuthService().haySesion()`.
- `lib/services/auth_service.dart` · **cambia** (T-02) · `registrar(correo, clave) → Future<String>` (el uuid), `iniciarSesion(correo, clave)`, `cerrarSesion()`, `haySesion() → bool`.
- `lib/services/usuario_service.dart` · **nueva** (T-02) · `crearUsuario(Usuario) → Future<void>`, `miUsuario() → Future<Usuario>`: lanza `ErrorApp` si no hay fila, si está inactivo o si el rol no es `coordinador`.
- `lib/utils/errores.dart` · **nueva** (T-02) · `ErrorApp` y `mensajeDeError(Object) → String`: traduce `AuthException`, `PostgrestException`, `StorageException` y fallas de red a español.
- `lib/models/models.dart` · **cambia** (T-02) · `Usuario.fromMap` y `toMap` (sin `id_usuario`, lo pone la base).
- `lib/screens/login_screen.dart` · **cambia** (T-02) · llama a `AuthService` y `UsuarioService`; `_cargando` y `_error`; navega con `pushNamedAndRemoveUntil('/home')`.
- `lib/pages/login_page.dart` · **cambia** (T-02, T-03) · recibe `cargando` (deshabilita el botón) y `onCrearCuenta`; se quita el texto del usuario de prueba.
- `lib/screens/registro_screen.dart` · **nueva** (T-03) · Screen con nombre, correo y clave; `signUp` y después `crearUsuario` (el orden importa).
- `lib/pages/registro_page.dart` · **nueva** (T-03) · la vista del formulario de registro.
- `lib/screens/home_screen.dart` · **cambia** (T-04) · ya no recibe el usuario: lo trae con `miUsuario()`; `_salir` hace `cerrarSesion()` y `pushNamedAndRemoveUntil('/login')`.
- `lib/services/simulated_data.dart` · **se mueve** (T-04) a `test/datos_simulados.dart`: solo lo usan las pruebas.

## Estado

- `LoginScreen`: `_cargando` (bool), `_error` (String?), `_verClave`.
- `RegistroScreen`: lo mismo, más los tres controladores.
- `HomeScreen`: `_usuario` (Usuario?) junto con el `AppStore` (ver TS-02).

## Datos

- Tabla `usuario`: `id_usuario`, `auth_uuid` (único, `auth.users`), `nombre`, `email`, `rol` (`coordinador`), `pais`, `activo`.

## Paquetes y plataformas

- `supabase_flutter` · Auth, base de datos y Storage. Android necesita
  `<uses-permission android:name="android.permission.INTERNET"/>` en
  `android/app/src/main/AndroidManifest.xml` (en release).
- Se corre con `flutter run -d chrome --dart-define-from-file=env.json`.

## Tareas

- **T-01** Conectar la app a Supabase con llaves fuera del código, rutas nombradas y ruta inicial según la sesión · CA-4 · depende de: ninguna
  - Prueba: sin `env.json` la app muestra cómo configurarla; con `env.json` arranca en el login.
- **T-02** `AuthService` y `UsuarioService` reales; `LoginScreen` con cargando y errores en español · CA-1, CA-2, CA-3 · depende de: T-01
  - Prueba: clave mala → «Correo o contraseña incorrectos.»; sin internet → mensaje de conexión; clave buena → panel.
- **T-03** Crear cuenta: `RegistroScreen`, ruta `/registro` y enlace desde el login · CA-5, CA-6 · depende de: T-02
  - Prueba: crear una cuenta nueva → entra al panel y en *Authentication → Users* y en la tabla `usuario` aparece la fila; repetir el correo → «Ese correo ya tiene una cuenta.».
- **T-04** `HomeScreen` con el usuario de la sesión y cerrar sesión que limpia la pila · CA-5, CA-7 · depende de: T-02
  - Prueba: el menú muestra el nombre registrado; *Cerrar sesión* → login; recargar la página → sigue en login.

## Preguntas abiertas

- Ninguna.

## Historial

- 1.0.0 · 2026-11-26 · Primera versión, con la skill `sdd-tecnicas`; aprobada.
