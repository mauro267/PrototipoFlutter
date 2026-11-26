# Reporte de specs · RutaViva

Fecha: 2026-11-06 · Revisado: prd 0.1.1 · requisitos 0.1.0 · spine 0.1.0 · 6 specs

## Métricas

- **Completitud** (verde): 12/12 · 100 %
- **Trazabilidad** (amarillo): RF → objetivo 12/12 · 100 %; spec → RF 5/6 · 83 % (F-01 solo cita RNF-04, ninguna RF — aceptado: el inicio de sesión no tiene un RF propio en `docs/requisitos.md`, solo la no funcional)
- **Verificabilidad** (verde): 27/27 · 100 % (todas con forma Dado/cuando/entonces y un resultado visible; ninguna spec sin criterios; ya hay al menos un CA por flujo alterno)
- **Ambigüedad** (verde): 0
- **Consistencia** (verde): 0 (corregido F-03, ver Historial)
- **Atomicidad** (verde): 0
- **Pureza funcional** (verde): 0
- **Preguntas abiertas:** 6 (una por spec, sin cambios)
- **Avance de implementación:** todo en borrador (0 aprobadas, 0 implementadas)
- **Estabilidad:** 6 specs subieron de versión menor (0.1.0 → 0.2.0) en esta revisión; ningún cambio mayor todavía

## Correcciones aplicadas

1. **F-01 a F-06 · Criterios de aceptación.** Se agregó un CA por cada flujo alterno que no tenía uno propio (antes solo quedaban cubiertos los estados de vacío y error). Ver el Historial de cada spec.
2. **F-03 · Reglas.** Se corrigió la regla de que la condición de telemetría "no cambia durante la vida del vehículo", porque contradecía `docs/modelo.md` (campo `fecha_instalacion_iot`). Ahora la regla dice que la vista depende del estado actual en el momento de la consulta.
3. **F-04 · Fuera de alcance.** Se precisó "editar o eliminar una alerta" para dejar claro que marcarla como atendida (el flujo alterno A1) sí está dentro de esta funcionalidad.

## Lo que está bien

- Completitud 100 %: los 12 RF de `docs/requisitos.md` quedan cubiertos por alguna spec.
- Ninguna spec usa palabras vagas, nombra tecnología (Supabase, Flutter, tablas, SQL) ni mezcla dos funcionalidades en una.
- Cada estado de "vacío" y de "error" que una spec declara tiene su propio criterio de aceptación verificable, y ahora también cada flujo alterno.
- No quedan contradicciones de datos pendientes entre las specs y `docs/modelo.md`.
