---
id: F-03
titulo: Detalle de vehículo
version: 1.0.0
fecha: 2026-11-26
estado: implementada
autores: [Mauricio Marín, Elías Saldarriaga, Juan Felipe Martínez, Daniel Cabal]
requisitos: [RF-05, RF-06]
depende_de: [F-02]
---

# F-03 · Detalle de vehículo

## Objetivo

El coordinador necesita ver la información específica de un vehículo para decidir si requiere atención, sea que tenga telemetría instalada o no.

## Flujo principal

1. El coordinador elige un vehículo desde el panel de flota.
2. El sistema muestra la información general del vehículo: placa, zona, conductor asignado y si tiene o no telemetría instalada.
3. Si el vehículo tiene telemetría instalada, el sistema muestra su telemetría más reciente.
4. Si el vehículo no tiene telemetría instalada, el sistema muestra en su lugar el seguimiento de mantenimiento preventivo por kilometraje.

## Flujos alternos

- **A1 · Ver historial de mantenimiento:** desde el detalle, el coordinador puede ver los mantenimientos registrados anteriormente para ese vehículo.

## Reglas

- Un vehículo solo muestra telemetría reciente si tiene sensores instalados; en caso contrario muestra el seguimiento por kilometraje.
- La vista que ve el coordinador depende del estado actual de instalación de telemetría del vehículo en el momento de la consulta.

## Estados

- **Cargando:** mientras se trae la información del vehículo, el coordinador ve que el detalle está cargando.
- **Vacío:** si el vehículo tiene telemetría instalada pero aún no hay lecturas registradas, el coordinador ve un aviso de que no hay telemetría reciente.
- **Error:** si no se puede cargar el detalle del vehículo, el coordinador ve un mensaje explicando el problema y puede reintentar o volver al panel.

## Datos

- El vehículo: placa, zona, conductor asignado y si tiene telemetría instalada.
- La telemetría más reciente, cuando aplica.
- El kilometraje y el seguimiento de mantenimiento preventivo, cuando el vehículo no tiene telemetría.
- El historial de mantenimientos del vehículo.

## Criterios de aceptación

- **CA-1** Dado un vehículo con telemetría instalada, cuando el coordinador abre su detalle, entonces ve su telemetría más reciente.
- **CA-2** Dado un vehículo sin telemetría instalada, cuando el coordinador abre su detalle, entonces ve su seguimiento de mantenimiento preventivo por kilometraje en lugar de telemetría.
- **CA-3** Dado un vehículo con telemetría instalada pero sin lecturas registradas, cuando el coordinador abre su detalle, entonces ve un aviso de que no hay telemetría reciente.
- **CA-4** Dado que el detalle del vehículo no se puede cargar, cuando el coordinador lo abre, entonces ve un mensaje de error y puede reintentar o volver al panel.
- **CA-5** Dado un vehículo con mantenimientos registrados, cuando el coordinador abre su historial de mantenimiento, entonces ve cada mantenimiento registrado para ese vehículo.

## Fuera de alcance

- Editar la información del vehículo o reasignar conductor desde esta pantalla.
- Instalar o dar de baja telemetría de un vehículo.

## Preguntas abiertas

- Ninguna. El historial se muestra completo, del más reciente al más antiguo.

## Historial

- 1.0.0 · 2026-11-26 · Aprobada para la Entrega 3; se cierra la pregunta abierta.
- 0.1.0 · 2026-11-06 · Primera versión.
- 0.2.0 · 2026-11-06 · Se corrigió la regla sobre la condición de telemetría (ahora depende del estado en el momento de la consulta, no de que nunca cambie) y se agregó CA-5 para el flujo alterno A1 (ver historial de mantenimiento).
