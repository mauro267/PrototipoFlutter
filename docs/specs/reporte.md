# Reporte de specs · RutaViva

Fecha: 2026-11-26 · Revisado: prd 0.3.0 · requisitos 0.3.0 · spine 0.3.0 · modelo 0.2.0 · 7 specs (F-01 a F-07, todas 1.0.0)

## Métricas

- **Completitud** (verde): 14/14 · 100 % (RF-01 a RF-14 aparecen en el campo `requisitos` de alguna spec)
- **Trazabilidad** (verde): RF → objetivo 14/14 · 100 % (RF-14 está en *Transversal · Cuentas*, que cita todos los objetivos); spec → RF 7/7 · 100 % (F-01 ya cita RF-14, el hueco del reporte anterior quedó cerrado)
- **Verificabilidad** (verde): 46/46 · 100 % (F-01 7, F-02 6, F-03 5, F-04 6, F-05 7, F-06 8, F-07 7; todos con Dado / cuando / entonces y un resultado visible; ninguna spec sin criterios)
- **Ambigüedad** (verde): 0 (no aparecen fácil, rápido, intuitivo, amigable, adecuado, etc., algunos, varios ni y/o)
- **Consistencia** (verde): 0 contradicciones entre specs, spine o `docs/modelo.md`. Hay un choque de vocabulario que se trata como corrección 3: «atendida» significa cosas distintas en F-04 y F-05.
- **Atomicidad** (amarillo): 1. El título de F-01 («Cuenta y sesión») lleva «y». Se acepta: crear cuenta, iniciar sesión y cerrarla salen de un mismo RF (RF-14) y los flujos dependen uno del otro.
- **Pureza funcional** (verde): 0 (ninguna spec nombra Supabase, Flutter, widgets, tablas, SQL ni Storage)
- **Preguntas abiertas:** 0 (bajó de 6 en la revisión del 2026-11-06)
- **Avance de implementación:** 2/7 · 29 % (F-03 y F-06 implementadas; F-01, F-02, F-04, F-05 y F-07 aprobadas con tareas pendientes en `docs/impl_progress.md`)
- **Estabilidad:** F-01 a F-06 subieron una vez de versión mayor (0.2.0 → 1.0.0, al aprobarse para la Entrega 3); F-07 nació en 1.0.0. Ningún cambio mayor después de aprobadas.

## Correcciones propuestas

1. **F-06 · Datos.** Solo dice «cliente retailer y estado», pero A2, A3 y las *Reglas* usan la dirección, la ciudad, la fecha prometida y la fecha de entrega. Propuesta: «Las órdenes de entrega: código, cliente retailer, dirección, ciudad, fecha prometida, fecha de entrega (si ya se entregó) y estado.»
2. **F-06 · Criterios de aceptación.** A3 tiene dos salidas y solo *a tiempo* tiene criterio; tampoco hay uno para la regla «Solo se marca como entregada una orden que aún no se ha entregado». Propuesta: **CA-9** Dado una orden sin entregar cuya fecha prometida ya pasó, cuando el coordinador la marca como entregada, entonces queda *retrasada* y el porcentaje de entregas a tiempo baja. **CA-10** Dado una orden ya entregada, cuando el coordinador ve su fila, entonces no tiene la opción de marcarla como entregada.
3. **F-04 · Flujos alternos (A1) y F-05 · Flujos alternos (A2).** F-04 A1 se titula «Descartar una alerta» pero dice «marcar como atendida»; F-05 A2 usa «atender una alerta» para cuando se registra el mantenimiento. En `docs/modelo.md` son dos estados distintos (`descartada` y `confirmada`). Propuesta: en F-04 A1 y CA-5 cambiar «marca como atendida» por «descarta», y dejar «atender» solo para F-05.

## Lo que está bien

- Completitud y trazabilidad al 100 %: cada RF tiene objetivo y spec, y cada spec cita al menos un RF.
- Ninguna pregunta abierta: todas se cerraron al aprobar las specs para la Entrega 3, y cada cierre quedó anotado en el *Historial*.
- Los 46 criterios son verificables, y cada flujo alterno y cada estado de vacío y error tiene el suyo (salvo la salida *retrasada* de F-06 A3, corrección 2).
- Las specs siguen libres de tecnología aunque la Entrega 3 ya usa un backend: los detalles quedaron en `docs/tecnicas/`.
