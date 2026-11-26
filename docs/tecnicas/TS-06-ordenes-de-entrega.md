---
id: TS-06
titulo: Órdenes de entrega
version: 1.0.0
fecha: 2026-11-26
estado: aprobada
funcional: F-06 1.0.0
responsable: Daniel Cabal
---

# TS-06 · Órdenes de entrega

## Resumen

Registrar, marcar entregada y eliminar una orden pasan a `orden_entrega`. El
listado se puede recargar. Los filtros y el OTD siguen calculándose en el
`AppStore` sobre lo cargado.

## Preparación en Supabase

- Ninguna.

## Piezas

- `lib/models/models.dart` · **cambia** (T-17) · `OrdenEntrega.toMap()` sin `id_orden`.
- `lib/services/order_service.dart` · **cambia** (T-17, T-18) · `crearOrden(OrdenBorrador) → Future<OrdenEntrega>` (el código `RV-<número>` se arma con el siguiente número después del mayor existente), `marcarEntregada(OrdenEntrega) → Future<OrdenEntrega>` (`fecha_entrega_real` = ahora y `estado` = `a_tiempo` o `retrasada`), `eliminarOrden(int id)`.
- `lib/state/app_store.dart` · **cambia** (T-17, T-18, T-19) · `agregarOrden(OrdenEntrega guardada)`, `reemplazarOrden`, `quitarOrden`, `reemplazarOrdenes(List)`.
- `lib/components/formulario_orden.dart` · **cambia** (T-17) · `onGuardar` como `Future<bool> Function(OrdenBorrador)`; se cierra solo si salió bien.
- `lib/screens/orders_screen.dart` · **cambia** (T-17, T-18, T-19) · `_nueva`, `onMarcarEntregada` y `_eliminar` con `try`/`catch` y `SnackBar`; `RefreshIndicator` que llama a `OrderService.getOrdenes()`; `_error` con `EstadoError`.

## Estado

- `OrdersScreen`: `_idCliente`, `_estado` (ya existían) y `_error` (String?).

## Datos

- `orden_entrega` (todas sus columnas). La orden registrada a mano no tiene `id_viaje`.

## Paquetes y plataformas

- Ninguno.

## Tareas

- **T-17** Registrar una orden en Supabase · CA-6 · depende de: T-06
  - Prueba: nueva orden para Jumbo → aparece *pendiente*; cerrar y abrir → sigue.
- **T-18** Marcar entregada y eliminar una orden en Supabase · CA-7, CA-8 · depende de: T-17
  - Prueba: marcar entregada una orden con promesa futura → *a tiempo* y el OTD del panel sube; eliminarla → desaparece también de la tabla.
- **T-19** Recargar el listado deslizando, con error y *Reintentar*; filtros y aviso sin resultados sobre lo cargado · CA-1, CA-2, CA-3, CA-4, CA-5 · depende de: T-06
  - Prueba: filtrar Falabella + Retrasada → aviso sin resultados; quitar filtros → listado completo; sin wifi y deslizar → error.

## Preguntas abiertas

- Ninguna.

## Historial

- 1.0.0 · 2026-11-26 · Primera versión, con la skill `sdd-tecnicas`; aprobada.
