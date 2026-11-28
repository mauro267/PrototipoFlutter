# Avance de la implementación · RutaViva

Actualizado: 2026-11-27 · Hechas: 13 de 21

Lo escribe la skill `sdd-tecnicas` (tareas nuevas, `[ ]`) y lo marca la skill `sdd-implementar` (`[x]`). Una tarea se marca cuando pasa `flutter analyze` sin errores. La prueba a mano la hace el responsable: si falla, se desmarca y se vuelve a pedir.

Cada integrante implementa y sube (commit) sus propias tareas.

## TS-01 · Cuenta y sesión · Mauricio Marín

- [ ] **T-01** Conectar la app a Supabase con llaves fuera del código, rutas nombradas y ruta inicial según la sesión · CA-4 · depende de: ninguna
- [x] **T-02** `AuthService` y `UsuarioService` reales; `LoginScreen` con cargando y errores en español · CA-1, CA-2, CA-3 · depende de: T-01
  - Hecha: 2026-11-26
  - Archivos: `lib/services/auth_service.dart`, `lib/services/usuario_service.dart` (nuevo), `lib/utils/errores.dart` (nuevo), `lib/models/models.dart`, `lib/screens/login_screen.dart`, `lib/pages/login_page.dart`
  - Notas: en `login_page.dart` el encabezado (logo + título) se desbordaba 18 px en pantallas angostas y hacía fallar `test/widget_test.dart`; se envolvió el título en `Flexible`. Probado: credenciales malas → «Correo o contraseña incorrectos.». No se probó el mensaje sin internet.
- [x] **T-03** Crear cuenta: `RegistroScreen`, ruta `/registro` y enlace desde el login · CA-5, CA-6 · depende de: T-02
  - Hecha: 2026-11-26
  - Archivos: `lib/screens/registro_screen.dart` (nuevo), `lib/pages/registro_page.dart` (nuevo), `lib/main.dart`, `lib/pages/login_page.dart`
  - Notas: con *Confirm email* encendido el registro crea la cuenta pero no abre sesión y el panel dice «No hay una sesión iniciada»; hay que apagarlo (TS-01, preparación 3). Probado: cuenta nueva → panel con el nombre y fila en `usuario` (coordinador); correo repetido → «Ese correo ya tiene una cuenta.».
- [ ] **T-04** `HomeScreen` con el usuario de la sesión y cerrar sesión que limpia la pila · CA-5, CA-7 · depende de: T-02

## TS-02 · Panel de flota · Mauricio Marín

- [x] **T-05** `fromMap` en los modelos y las lecturas de los servicios, con `cargarDatosIniciales()` · CA-1 · depende de: T-01
  - Hecha: 2026-11-26
  - Archivos: `lib/models/models.dart`, `lib/services/fleet_service.dart` (nuevo), `lib/services/maintenance_service.dart` (nuevo), `lib/services/order_service.dart` (nuevo), `lib/services/parametro_service.dart` (nuevo), `lib/services/carga_inicial.dart` (nuevo), `lib/state/datos_iniciales.dart` (nuevo)
  - Notas: nada. `flutter analyze` sin errores y el panel carga los datos de las migraciones.
- [ ] **T-06** `HomeScreen` crea el `AppStore` con los datos de Supabase, con cargando, error y *Reintentar*; los datos simulados pasan a `test/` · CA-1, CA-4 · depende de: T-04, T-05
- [x] **T-07** Indicadores recalculados para la zona elegida · CA-5 · depende de: T-06
  - Hecha: 2026-11-26
  - Archivos: `lib/state/app_store.dart`, `lib/screens/fleet_screen.dart`
  - Notas: nada. Probado: zona Cali → 3 vehículos, cobertura 1 de 3, OTD y varadas distintos a *Todas*.
- [x] **T-08** Meta de OTD guardada en `parametro` · CA-6 · depende de: T-06
  - Hecha: 2026-11-26
  - Archivos: `lib/services/parametro_service.dart` (nuevo), `lib/screens/orders_screen.dart`
  - Notas: nada. Probado: meta 90 → «Meta: 90,0 %», sigue al recargar y `parametro.meta_otd = 0.9`.

## TS-03 · Detalle de vehículo · Daniel Cabal

- [x] **T-09** Telemetría más reciente al abrir el detalle, con cargando, error, *Reintentar* y *Volver* · CA-1, CA-3, CA-4 · depende de: T-06
  - Hecha: 2026-11-26
  - Archivos: `lib/services/fleet_service.dart`, `lib/state/app_store.dart`, `lib/screens/vehicle_detail_screen.dart`, `lib/pages/vehicle_detail_page.dart`, `test/app_store_test.dart`
  - Notas: el detalle muestra *Cargando* la primera vez y, con error, `EstadoError` con *Reintentar* y *Volver al panel*. Para que deslizar funcione en Chrome con el mouse, el `RefreshIndicator` va con un `ScrollConfiguration` que acepta todos los dispositivos. Falta la prueba a mano contra Supabase.
- [x] **T-10** Deslizar para actualizar eventos e historial del vehículo; el vehículo sin telemetría sigue mostrando solo el preventivo por kilometraje · CA-2, CA-5 · depende de: T-09
  - Hecha: 2026-11-26
  - Archivos: `lib/services/fleet_service.dart`, `lib/services/maintenance_service.dart`, `lib/state/app_store.dart`, `lib/screens/vehicle_detail_screen.dart`
  - Notas: el mismo `_refrescar()` de T-09 trae eventos e historial; a un vehículo sin sensores no se le pide telemetría. Falta la prueba a mano con CAL-311.

## TS-04 · Alertas predictivas de mantenimiento · Juan Felipe Martínez

- [ ] **T-11** Programar y cancelar una alerta guardan en Supabase · CA-2, CA-6 · depende de: T-06
- [ ] **T-12** Marcar una alerta como atendida sin programar · CA-5 · depende de: T-11
- [ ] **T-13** Recargar alertas deslizando, con aviso de vacío y error con *Reintentar* · CA-1, CA-3, CA-4 · depende de: T-11

## TS-05 · Registrar mantenimiento · Elías Saldarriaga

- [x] **T-14** Registrar un mantenimiento en Supabase (vehículo y predicción incluidos); el formulario conserva los datos si falla · CA-1, CA-3, CA-4, CA-5 · depende de: T-06
  - Hecha: 2026-11-27
  - Archivos: `lib/models/models.dart`, `lib/services/maintenance_service.dart`, `lib/services/fleet_service.dart`, `lib/state/app_store.dart`, `lib/components/formulario_mantenimiento.dart`, `lib/screens/acciones_mantenimiento.dart`
  - Notas: `Mantenimiento.toMap()` inserta en Supabase con fecha yyyy-MM-dd y la base de datos asigna el id generado; `actualizarKilometraje` actualiza el kilometraje y último preventivo si aplica; si se seleccionó una alerta se marca `confirmada` con el usuario; el diálogo deshabilita el botón mientras guarda y si la llamada falla mantiene los datos capturados y muestra el error. `flutter analyze` y `flutter test` pasan limpios.
- [x] **T-15** Corregir y eliminar un mantenimiento en Supabase · CA-6, CA-7 · depende de: T-14
  - Hecha: 2026-11-27
  - Archivos: `lib/services/maintenance_service.dart`, `lib/state/app_store.dart`, `lib/screens/acciones_mantenimiento.dart`
  - Notas: `actualizarMantenimiento` aplica cambios en Supabase y actualiza la lista en memoria con `reemplazarMantenimiento`; `eliminarMantenimiento` borra el registro en Supabase, reabre la predicción asociada con `reabrirPrediccion` (volviéndola a 'pendiente') si ya no tiene otro mantenimiento asociado, y remueve el registro con `quitarMantenimiento`. Pasan `flutter analyze` y `flutter test`.
- [x] **T-16** Revisar que un correctivo sin tipo de falla no se guarde · CA-2 · depende de: T-14
  - Hecha: 2026-11-27
  - Archivos: `lib/components/formulario_mantenimiento.dart`, `test/widget_test.dart`
  - Notas: en el formulario, cuando el tipo de mantenimiento es `correctivo`, el campo `Tipo de falla` es obligatorio (`validator` retorna «Obligatorio») y bloquea el guardado; para `preventivo` el campo es opcional y asigna por defecto «Mantenimiento preventivo». Verificado mediante prueba de widget automatizada en `test/widget_test.dart` y `flutter analyze` sin errores.

## TS-06 · Órdenes de entrega · Daniel Cabal

- [x] **T-17** Registrar una orden en Supabase · CA-6 · depende de: T-06
  - Hecha: 2026-11-26
  - Archivos: `lib/models/models.dart`, `lib/services/order_service.dart`, `lib/state/app_store.dart`, `lib/components/formulario_orden.dart`, `lib/screens/orders_screen.dart`, `test/app_store_test.dart`
  - Notas: el código `RV-<n>` se calcula leyendo los códigos existentes (si dos personas crean a la vez, la restricción `unique` rechaza la segunda y el formulario queda abierto). Falta la prueba a mano.
- [x] **T-18** Marcar entregada y eliminar una orden en Supabase · CA-7, CA-8 · depende de: T-17
  - Hecha: 2026-11-26
  - Archivos: `lib/services/order_service.dart`, `lib/state/app_store.dart`, `lib/screens/orders_screen.dart`
  - Notas: los métodos viejos del store que creaban o cambiaban órdenes en memoria se reemplazaron por `agregarOrden(guardada)`, `reemplazarOrden` y `quitarOrden`. Falta la prueba a mano.
- [x] **T-19** Recargar el listado deslizando, con error y *Reintentar*; filtros y aviso sin resultados sobre lo cargado · CA-1, CA-2, CA-3, CA-4, CA-5 · depende de: T-06
  - Hecha: 2026-11-26
  - Archivos: `lib/state/app_store.dart`, `lib/screens/orders_screen.dart`, `lib/pages/orders_page.dart`
  - Notas: la Page usa `AlwaysScrollableScrollPhysics` para poder deslizar aunque el filtro deje la lista vacía. Falta la prueba a mano sin wifi.

## TS-07 · Evidencia de mantenimiento · Mauricio Marín

- [ ] **T-20** Servicios de foto, Storage y evidencia, y el modelo `Evidencia` · CA-2, CA-3, CA-5, CA-6 · depende de: T-05
- [ ] **T-21** `EvidenciasScreen` con galería, adjuntar y ver en grande, y el botón *Evidencia* en el historial · CA-1, CA-2, CA-4, CA-7 · depende de: T-20, T-06
