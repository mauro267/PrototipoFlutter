---
id: F-04
titulo: Alertas predictivas de mantenimiento
version: 1.0.0
fecha: 2026-11-26
estado: aprobada
autores: [Mauricio Marín, Elías Saldarriaga, Juan Felipe Martínez, Daniel Cabal]
requisitos: [RF-01, RF-02]
depende_de: []
---

# F-04 · Alertas predictivas de mantenimiento

## Objetivo

El coordinador necesita anticipar fallas de los vehículos con telemetría, para programar el mantenimiento antes de que se averíen en ruta.

## Flujo principal

1. El coordinador consulta la lista de alertas predictivas de falla.
2. Por cada alerta, el sistema muestra el vehículo, el componente afectado, la probabilidad de falla y la fecha límite recomendada de intervención.
3. El coordinador elige una alerta y programa una intervención de mantenimiento a partir de ella.
4. El sistema confirma que la intervención quedó programada.

## Flujos alternos

- **A1 · Descartar una alerta:** el coordinador puede marcar una alerta como atendida sin programar una intervención, por ejemplo si ya se resolvió por otro medio.
- **A2 · Cancelar la programación:** el coordinador cancela una intervención programada y la alerta vuelve a quedar pendiente.

## Reglas

- Una alerta predictiva solo existe para vehículos con telemetría instalada.
- Cada alerta debe mostrar siempre el vehículo, el componente afectado, la probabilidad de falla y la fecha límite recomendada.
- Una intervención programada queda asociada a la alerta que la originó.

## Estados

- **Cargando:** mientras se trae la lista de alertas, el coordinador ve que está cargando.
- **Vacío:** si no hay alertas activas, el coordinador ve un aviso de que no hay alertas pendientes.
- **Error:** si la lista de alertas no se puede cargar, el coordinador ve un mensaje explicando el problema y puede reintentar.

## Datos

- Las alertas predictivas: vehículo, componente afectado, probabilidad de falla y fecha límite recomendada.
- La intervención de mantenimiento programada a partir de una alerta.

## Criterios de aceptación

- **CA-1** Dado que hay alertas activas, cuando el coordinador abre la lista, entonces ve cada alerta con su vehículo, componente, probabilidad de falla y fecha límite.
- **CA-2** Dado una alerta activa, cuando el coordinador programa una intervención a partir de ella, entonces el sistema confirma que quedó programada.
- **CA-3** Dado que no hay alertas activas, cuando el coordinador abre la lista, entonces ve un aviso de que no hay alertas pendientes.
- **CA-4** Dado que la lista de alertas no se puede cargar, cuando el coordinador la abre, entonces ve un mensaje de error y puede reintentar.
- **CA-5** Dado una alerta activa, cuando el coordinador la marca como atendida sin programar una intervención, entonces la alerta deja de aparecer en la lista de alertas pendientes.
- **CA-6** Dado una alerta con una intervención programada, cuando el coordinador cancela la programación, entonces la alerta vuelve a quedar pendiente, también al volver a abrir la aplicación.

## Fuera de alcance

- Cómo se calcula la probabilidad de falla.
- Modificar los datos de la alerta (vehículo, componente, probabilidad o fecha límite) o eliminarla; marcarla como atendida sí está dentro de esta funcionalidad.

## Preguntas abiertas

- Ninguna. Las alertas vienen de un conjunto de datos de ejemplo que carga el equipo (PRD 0.3.0, *Decisiones confirmadas*).

## Historial

- 1.0.0 · 2026-11-26 · Aprobada para la Entrega 3. Se agrega cancelar la programación (A2, CA-6), que el prototipo ya hacía; se cierra la pregunta abierta.
- 0.1.0 · 2026-11-06 · Primera versión.
- 0.2.0 · 2026-11-06 · Se precisó el fuera de alcance (ya no contradice marcar una alerta como atendida) y se agregó CA-5 para el flujo alterno A1 (descartar una alerta).
