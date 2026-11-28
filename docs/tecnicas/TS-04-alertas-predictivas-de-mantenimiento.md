---
id: TS-04
titulo: Alertas predictivas de mantenimiento
version: 1.1.0
fecha: 2026-11-27
estado: aprobada
funcional: F-04 1.0.0
responsable: Mauricio Marín
---

# TS-04 · Alertas predictivas de mantenimiento

## Resumen

Programar, cancelar y descartar una alerta dejan de cambiar solo la memoria: cada
acción actualiza la fila de `prediccion_falla` y, cuando Supabase confirma, el
`AppStore` reemplaza la predicción. Las alertas se pueden recargar.

## Preparación en Supabase

- Ninguna. El `check` de `prediccion_falla.estado` ya admite `descartada`.

## Piezas

- `lib/models/models.dart` · **cambia** (T-11) · `PrediccionFalla.copyWith` (estado, fechaProgramada, idUsuarioRevision).
- `lib/services/maintenance_service.dart` · **cambia** (T-11) · `programarPrediccion(int id, DateTime fecha, int idUsuario) → Future<PrediccionFalla>` y `cancelarProgramacion(int id) → Future<PrediccionFalla>` (`update(...).eq('id_prediccion', id).select().single()`); (T-12) `descartarPrediccion(int id, int idUsuario)`.
- `lib/state/app_store.dart` · **cambia** (T-11, T-12, T-13) · `reemplazarPrediccion(PrediccionFalla)` en vez de mutar; `alertas` excluye `confirmada` y `descartada`; `reemplazarPredicciones(List)`.
- `lib/screens/acciones_mantenimiento.dart` · **cambia** (T-11, T-12) · `programar`, `cancelarProgramacion` y `descartar` son `async`: llaman al servicio en `try`/`catch`, luego al store, y avisan con `SnackBar` (`mensajeDeError` si falla).
- `lib/components/tarjeta_alerta.dart` · **cambia** (T-12) · botón *Marcar atendida* (`onDescartar`), con confirmación.
- `lib/pages/maintenance_page.dart`, `lib/pages/vehicle_detail_page.dart` · **cambian** (T-12) · pasan `onDescartar`.
- `lib/screens/maintenance_screen.dart` · **cambia** (T-13) · `StatefulWidget` con `RefreshIndicator` que llama a `MaintenanceService.getPredicciones()`; `_error` con `EstadoError` y *Reintentar* en la sección de alertas.

## Estado

- `MaintenanceScreen`: `_error` (String?) de la recarga.

## Datos

- `prediccion_falla`: `estado`, `fecha_programada` (formato `yyyy-MM-dd`), `id_usuario_revision` = `store.usuario.id`.

## Paquetes y plataformas

- Ninguno.

## Tareas

- **T-11** Programar y cancelar una alerta guardan en Supabase · CA-2, CA-6 · depende de: T-06
  - Prueba: programar la alerta de ABC-123 → «programada» en la tabla y en la app; cerrar y abrir → sigue programada; cancelar → vuelve a pendiente.
- **T-12** Marcar una alerta como atendida sin programar · CA-5 · depende de: T-11
  - Prueba: marcar atendida la del Turbocompresor → desaparece de la lista y en la tabla queda `descartada`.
- **T-13** Recargar alertas deslizando, con aviso de vacío y error con *Reintentar* · CA-1, CA-3, CA-4 · depende de: T-11
  - Prueba: sin wifi, deslizar → error con *Reintentar*; con todas atendidas → «No hay alertas predictivas activas.».

## Preguntas abiertas

- Ninguna. T-13 muestra el error de la recarga con un `SnackBar` que trae *Reintentar*, en vez de `EstadoError`, porque la lista de alertas ya cargada sigue siendo válida y no se debe tapar.

## Historial

- 1.1.0 · 2026-11-27 · T-13: el error de recarga va en un `SnackBar` con *Reintentar*. No se agregó `PrediccionFalla.copyWith`: el servicio devuelve la fila actualizada y el store la reemplaza.
- 1.0.0 · 2026-11-26 · Primera versión, con la skill `sdd-tecnicas`; aprobada.
