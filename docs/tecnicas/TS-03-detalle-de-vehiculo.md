---
id: TS-03
titulo: Detalle de vehículo
version: 1.0.0
fecha: 2026-11-26
estado: aprobada
funcional: F-03 1.0.0
responsable: Daniel Cabal
---

# TS-03 · Detalle de vehículo

## Resumen

El detalle ya muestra telemetría, preventivo por kilometraje, eventos e historial a
partir del `AppStore` (Entrega 2). Esta TS hace que, al abrirlo, pida a Supabase la
telemetría más reciente del vehículo, con sus estados de carga y error, y que se
pueda actualizar deslizando hacia abajo.

## Preparación en Supabase

- Ninguna (las tablas y los datos vienen de TS-02).

## Piezas

- `lib/services/fleet_service.dart` · **cambia** (T-09) · `getUltimoGps(int idVehiculo) → Future<TelemetriaGps?>` y `getUltimoObd(int idVehiculo) → Future<TelemetriaObd?>` (`order('fecha_hora', ascending: false).limit(1).maybeSingle()`); (T-10) `getEventosDe(int idVehiculo)`.
- `lib/services/maintenance_service.dart` · **cambia** (T-10) · `getMantenimientosDe(int idVehiculo)`.
- `lib/state/app_store.dart` · **cambia** (T-09, T-10) · `reemplazarTelemetria(idVehiculo, gps, obd)` y `reemplazarDelVehiculo(idVehiculo, eventos, mantenimientos)`, con `notifyListeners()`.
- `lib/screens/vehicle_detail_screen.dart` · **cambia** (T-09, T-10) · pasa a `StatefulWidget`: `_cargando`, `_error`; `initState` llama a `_refrescar()`. Con error: `EstadoError` (de `components/estados_carga.dart`) con *Reintentar* y *Volver al panel*. `RefreshIndicator` alrededor de la Page.
- `lib/pages/vehicle_detail_page.dart` · **cambia** (T-09) · si el vehículo tiene telemetría pero no hay lecturas, el aviso dice «No hay telemetría reciente para este vehículo.».

## Estado

- `VehicleDetailScreen`: `_cargando` (bool), `_error` (String?). Los datos siguen en el `AppStore`.

## Datos

- `telemetria_gps`, `telemetria_obd`, `evento_conduccion`, `mantenimiento` filtrados por `id_vehiculo`.

## Paquetes y plataformas

- Ninguno.

## Tareas

- **T-09** Telemetría más reciente al abrir el detalle, con cargando, error, *Reintentar* y *Volver* · CA-1, CA-3, CA-4 · depende de: T-06
  - Prueba: abrir ABC-123 → temperatura 92 °C; en el SQL Editor insertar una lectura nueva de `telemetria_obd` y deslizar → se ve la nueva; abrir con el wifi apagado → error con *Reintentar*.
- **T-10** Deslizar para actualizar eventos e historial del vehículo; el vehículo sin telemetría sigue mostrando solo el preventivo por kilometraje · CA-2, CA-5 · depende de: T-09
  - Prueba: abrir CAL-311 (sin sensores) → preventivo por km y su historial completo.

## Preguntas abiertas

- Ninguna.

## Historial

- 1.0.0 · 2026-11-26 · Primera versión, con la skill `sdd-tecnicas`; aprobada.
