---
id: TS-05
titulo: Registrar mantenimiento
version: 1.0.0
fecha: 2026-11-26
estado: aprobada
funcional: F-05 1.0.0
responsable: Elías Saldarriaga
---

# TS-05 · Registrar mantenimiento

## Resumen

Crear, corregir y eliminar un mantenimiento pasan a Supabase. Al crear se actualiza
también el kilometraje del vehículo (y el último preventivo) y, si atendía una
alerta, la predicción queda `confirmada`. El formulario solo se cierra cuando
Supabase confirmó; si falla, conserva lo escrito.

## Preparación en Supabase

- Ninguna.

## Piezas

- `lib/models/models.dart` · **cambia** (T-14) · `Mantenimiento.toMap()` sin `id_mantenimiento` (lo pone la base), con `fecha` como `yyyy-MM-dd`.
- `lib/services/maintenance_service.dart` · **cambia** (T-14, T-15) · `crearMantenimiento(Mantenimiento) → Future<Mantenimiento>` (`insert(...).select().single()`), `actualizarMantenimiento(int id, Map cambios) → Future<Mantenimiento>`, `eliminarMantenimiento(int id)`, `confirmarPrediccion(int id, int idUsuario)`, `reabrirPrediccion(int id)`.
- `lib/services/fleet_service.dart` · **cambia** (T-14) · `actualizarKilometraje(int idVehiculo, double km, {double? kmUltimoPreventivo})`.
- `lib/state/app_store.dart` · **cambia** (T-14, T-15) · `agregarMantenimiento(Mantenimiento guardado)`, `reemplazarMantenimiento`, `quitarMantenimiento`; ya no generan ids.
- `lib/components/formulario_mantenimiento.dart` · **cambia** (T-14) · `onGuardar` pasa a `Future<bool> Function(MantenimientoBorrador)`; el diálogo se cierra solo si devuelve `true` y deshabilita *Guardar* mientras espera.
- `lib/screens/acciones_mantenimiento.dart` · **cambia** (T-14, T-15) · `registrar`, `editar` y `eliminar` llaman a los servicios en `try`/`catch` y avisan con `SnackBar`.

## Estado

- `FormularioMantenimiento`: `_guardando` (bool), además de su borrador.

## Datos

- `mantenimiento` (todas sus columnas; `id_usuario_registro` = `store.usuario.id`).
- `vehiculo.kilometraje_actual` y `km_ultimo_preventivo`; `prediccion_falla.estado`.

## Paquetes y plataformas

- Ninguno.

## Tareas

- **T-14** Registrar un mantenimiento en Supabase (vehículo y predicción incluidos); el formulario conserva los datos si falla · CA-1, CA-3, CA-4, CA-5 · depende de: T-06
  - Prueba: registrar un preventivo de CAL-311 → aparece en el historial y en la tabla, y su preventivo por km se reinicia; sin wifi → error y el formulario sigue abierto con los datos.
- **T-15** Corregir y eliminar un mantenimiento en Supabase · CA-6, CA-7 · depende de: T-14
  - Prueba: editar el costo → cerrar y abrir → costo nuevo; eliminar uno que atendía una alerta → la alerta vuelve a pendiente.
- **T-16** Revisar que un correctivo sin tipo de falla no se guarde · CA-2 · depende de: T-14
  - Prueba: correctivo con tipo de falla vacío → «Obligatorio» y no se envía nada.

## Preguntas abiertas

- Ninguna.

## Historial

- 1.0.0 · 2026-11-26 · Primera versión, con la skill `sdd-tecnicas`; aprobada.
