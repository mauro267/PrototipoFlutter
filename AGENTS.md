# AGENTS.md · RutaViva

App Flutter (web y Android) para el área de Operaciones de RutaViva Logística, un
operador de última milla con 1.200 vehículos (70 % con telemetría IoT). La app es una
torre de control: anticipa el mantenimiento con alertas predictivas, da visibilidad
de la flota por zona, mide el cumplimiento de entregas (OTD) frente a los cinco
retailers y guarda la evidencia fotográfica de cada mantenimiento. Retoma el Caso 4
(RutaViva Logística, reto Lovelytics x ICESI) de Seminario de Ingeniería de Software.

Backend: Supabase (Auth, base de datos y Storage), sin servidor propio.

## Cómo se trabaja

El proyecto sigue Spec Driven Development. Todo está en `docs/`:

- `prd.md`, `requisitos.md` y `architectural_spine.md`.
- `modelo.md`: el modelo de datos (fuente de verdad de tablas y columnas).
- `specs/`: las specs funcionales (`F-xx`), sin tecnología, con su índice.
- `tecnicas/`: las specs técnicas (`TS-xx`), una por spec funcional, con sus tareas `T-xx`.
- `impl_progress.md`: el manifiesto de la implementación: qué tareas están hechas
  (`[x]`), cuáles faltan (`[ ]`) y quién es responsable de cada una.
- `standard_code.md`: las reglas del código. Léelo antes de escribir código.

Las skills están en `.agents/skills/` y en `.claude/skills/` (son las mismas). Para
pasar una spec funcional a técnica, `sdd-tecnicas`; para implementar una tarea,
`sdd-implementar`; para revisar el conjunto de specs, `sdd-critica`.

## Estructura de lib/

- `main.dart`: `Supabase.initialize` y rutas nombradas. Ruta inicial `/home` si hay
  sesión, `/login` si no.
- `config.dart`: URL y publishable key desde `env.json` (`--dart-define-from-file`).
- `models/models.dart`: clases alineadas con `docs/modelo.md`, con `fromMap`.
- `services/`: `AuthService`, `UsuarioService`, `FleetService`, `MaintenanceService`,
  `OrderService`, `ParametroService`, `EvidenciaService`, `StorageService`,
  `FotoService` y `cargarDatosIniciales()`.
- `state/app_store.dart`: los datos de la sesión y los indicadores. Lo crea
  `HomeScreen` con lo que devuelven los servicios.
- `screens/`: `login_screen`, `registro_screen`, `home_screen` (barra inferior en
  móvil, menú lateral en pantallas anchas), `fleet_screen`, `maintenance_screen`,
  `orders_screen`, `vehicle_detail_screen`, `evidencias_screen`.
  `acciones_mantenimiento.dart` agrupa las acciones que comparten dos pantallas.
- `pages/`: vistas sin estado de cada Screen.
- `components/`: widgets reutilizables, cada uno definido una sola vez.
- `utils/`: `format.dart` (es-CO), `estados.dart` (colores) y `errores.dart`.

## Base de datos

- El modelo está en `docs/modelo.md` (y `MR_RutaViva.pdf`). Es la fuente de verdad.
- Las tablas se crean con migraciones del CLI en `supabase/migrations/`. Nunca se
  editan a mano en el dashboard. Una migración subida no se edita: se crea otra.
- Nombres del modelo: español, singular, `snake_case`, llaves `bigint` con identidad
  (spine AD-08).
- Cada tabla nueva lleva su `grant select, insert, update, delete ... to anon, authenticated;`.
- Sin RLS en las tablas de la app (Diferido en la spine).

## Storage

- Bucket **público** `evidencias`. Cada foto va en
  `<id_mantenimiento>/<milisegundos>.jpg`; nunca se sobrescribe.
- La tabla `evidencia_mantenimiento` guarda la ruta y la URL pública.
- Policies de INSERT y SELECT sobre `storage.objects` para `authenticated`.

## Reglas

- Las de `docs/standard_code.md`.
- No inventes tablas, columnas ni buckets: si hace falta uno, pregunta y se agrega
  primero a `docs/modelo.md` y a una migración nueva.
- La URL y la publishable key nunca se escriben en el código ni se suben al repo.
