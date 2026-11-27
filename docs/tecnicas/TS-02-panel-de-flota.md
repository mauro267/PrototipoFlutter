---
id: TS-02
titulo: Panel de flota
version: 1.0.0
fecha: 2026-11-26
estado: aprobada
funcional: F-02 1.0.0
responsable: Mauricio Marín
---

# TS-02 · Panel de flota

## Resumen

Los datos ya no salen de `simulated_data.dart`: `HomeScreen` llama a
`cargarDatosIniciales()`, que pide en paralelo cada tabla a su servicio, y con eso
crea el `AppStore`. Las Screens y Pages de la Entrega 2 no cambian de forma. Esta TS
deja listas las **lecturas** de todos los servicios; las escrituras las agregan
TS-04, TS-05 y TS-06.

## Preparación en Supabase

1. Migraciones `initial_schema` y `datos_ejemplo` subidas.

## Piezas

- `lib/models/models.dart` · **cambia** (T-05) · `fromMap` en `Zona`, `Conductor`, `Vehiculo`, `AsignacionTurno`, `Viaje`, `EventoConduccion`, `TelemetriaGps`, `TelemetriaObd`, `PrediccionFalla`, `Mantenimiento`, `ClienteRetailer` y `OrdenEntrega`. Las fechas `timestamptz` se pasan a hora local.
- `lib/services/fleet_service.dart` · **nueva** (T-05) · `getZonas`, `getVehiculos`, `getConductores`, `getAsignaciones` (más reciente primero), `getViajes`, `getEventos`, `getGps` y `getObd` (más reciente primero, así la primera lectura de cada vehículo es la última).
- `lib/services/maintenance_service.dart` · **nueva** (T-05) · `getPredicciones`, `getMantenimientos`.
- `lib/services/order_service.dart` · **nueva** (T-05) · `getClientes`, `getOrdenes`.
- `lib/services/parametro_service.dart` · **nueva** (T-05, T-08) · `getMetaOtd() → Future<double>` (0,95 si no hay fila); `guardarMetaOtd(double)` con `upsert`.
- `lib/services/carga_inicial.dart` · **nueva** (T-05) · `cargarDatosIniciales() → Future<DatosIniciales>` con `Future.wait`.
- `lib/state/datos_iniciales.dart` · **nueva** (T-05) · `DatosIniciales`, el paquete de listas que recibe `AppStore` (sale de `simulated_data.dart`) más `metaOtd`.
- `lib/state/app_store.dart` · **cambia** (T-06, T-07) · toma `metaOtd` de `DatosIniciales`; indicadores con zona opcional: `otdDe`, `varadasDe`, `viajesDe`, `tasaVaradasDe`, `conTelemetriaDe`, `coberturaDe`, `cumpleMetaDe`.
- `lib/screens/home_screen.dart` · **cambia** (T-06) · `_cargar()` en `initState`: `_cargando`, `_error`, `_store`. Muestra `EstadoCarga` mientras carga y `EstadoError` con *Reintentar* si falla.
- `lib/components/estados_carga.dart` · **nueva** (T-06) · `EstadoCarga(mensaje)` y `EstadoError(mensaje, onReintentar)`, reutilizables en las demás TS.
- `lib/screens/fleet_screen.dart` · **cambia** (T-07) · pasa a `FleetPage` los indicadores de la zona elegida.
- `lib/screens/orders_screen.dart` · **cambia** (T-08) · `onEditarMeta` guarda con `ParametroService` y, si Supabase confirma, llama a `store.cambiarMeta`; si falla, `SnackBar`.
- `test/datos_simulados.dart` y `test/app_store_test.dart` · **cambian** (T-06) · las pruebas del store siguen usando los datos simulados.

## Estado

- `HomeScreen`: `_store` (`AppStore?`), `_cargando` (bool), `_error` (String?).
- `FleetScreen`: `_idZona` (ya existía).
- `AppStore.metaOtd`: llega de la base al cargar y cambia solo después de `guardarMetaOtd`.

## Datos

- Lee todas las tablas del modelo. `parametro` con `clave = 'meta_otd'`.
- Tasa de varadas por zona: mantenimientos correctivos en ruta de vehículos de la zona ÷ viajes cuyas asignaciones son de vehículos de la zona. OTD por zona: órdenes cuyo viaje pertenece a un vehículo de la zona.

## Paquetes y plataformas

- Ninguno nuevo.

## Tareas

- **T-05** `fromMap` en los modelos y las lecturas de los servicios, con `cargarDatosIniciales()` · CA-1 · depende de: T-01
  - Prueba: `flutter analyze` sin errores; los servicios compilan contra las tablas de la migración.
- **T-06** `HomeScreen` crea el `AppStore` con los datos de Supabase, con cargando, error y *Reintentar*; los datos simulados pasan a `test/` · CA-1, CA-4 · depende de: T-04, T-05
  - Prueba: el panel muestra OTD 92,3 %, 12 vehículos y 8 con sensores, como en la Entrega 2; con el wifi apagado aparece el error y *Reintentar* carga al volver la conexión.
- **T-07** Indicadores recalculados para la zona elegida · CA-5 · depende de: T-06
  - Prueba: filtrar *Cali* → cobertura 1 de 3 vehículos y el OTD/varadas cambian frente a *Todas*.
- **T-08** Meta de OTD guardada en `parametro` · CA-6 · depende de: T-06
  - Prueba: en Entregas cambiar la meta a 90 % → el panel compara contra 90 %; cerrar y abrir la app → sigue en 90 %.

## Preguntas abiertas

- Ninguna.

## Historial

- 1.0.0 · 2026-11-26 · Primera versión, con la skill `sdd-tecnicas`; aprobada.
