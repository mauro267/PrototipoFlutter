---
id: F-05
titulo: Registrar mantenimiento
version: 1.0.0
fecha: 2026-11-26
estado: aprobada
autores: [Mauricio Marín, Elías Saldarriaga, Juan Felipe Martínez, Daniel Cabal]
requisitos: [RF-03, RF-11]
depende_de: []
---

# F-05 · Registrar mantenimiento

## Objetivo

El coordinador necesita dejar constancia de un mantenimiento realizado, sea preventivo o correctivo, para mantener al día el historial del vehículo.

## Flujo principal

1. El coordinador elige el vehículo al que se le hizo mantenimiento.
2. El coordinador indica el tipo de mantenimiento (preventivo o correctivo), el tipo de falla si aplica, el kilometraje, el costo y las horas fuera de servicio.
3. El coordinador confirma el registro.
4. El sistema guarda el mantenimiento y lo agrega al historial del vehículo.

## Flujos alternos

- **A1 · Mantenimiento preventivo por kilometraje:** si el vehículo no tiene telemetría instalada, el coordinador puede registrar el mantenimiento preventivo asociado al seguimiento por kilometraje de ese vehículo.
- **A2 · Atender una alerta:** si el mantenimiento se hizo por una alerta predictiva, el coordinador la elige al registrarlo y la alerta deja de estar pendiente.
- **A3 · Corregir un mantenimiento:** el coordinador corrige los datos de un mantenimiento ya registrado.
- **A4 · Eliminar un mantenimiento:** el coordinador elimina un mantenimiento registrado por error, después de confirmarlo; si había atendido una alerta, la alerta vuelve a estar pendiente.

## Reglas

- Todo mantenimiento registrado debe indicar si es preventivo o correctivo.
- El kilometraje, el costo y las horas fuera de servicio son obligatorios para registrar un mantenimiento.
- Un mantenimiento correctivo debe indicar el tipo de falla atendida.

## Estados

- **Cargando:** mientras se guarda el registro, el coordinador ve que se está procesando.
- **Vacío:** no aplica.
- **Error:** si el registro no se puede guardar, el coordinador ve un mensaje explicando el problema y la información que ya escribió se conserva para intentar de nuevo.

## Datos

- El vehículo al que se le hace el mantenimiento.
- El tipo de mantenimiento, el tipo de falla (si aplica), el kilometraje, el costo y las horas fuera de servicio.

## Criterios de aceptación

- **CA-1** Dado que el coordinador completa los datos obligatorios de un mantenimiento, cuando confirma, entonces el mantenimiento queda guardado en el historial del vehículo.
- **CA-2** Dado que el coordinador registra un mantenimiento correctivo sin indicar el tipo de falla, cuando intenta confirmar, entonces el sistema le indica que ese dato es obligatorio y no guarda el registro.
- **CA-3** Dado que el registro no se puede guardar, cuando el coordinador confirma, entonces ve un mensaje de error y los datos que escribió se conservan.
- **CA-4** Dado un vehículo sin telemetría instalada, cuando el coordinador registra su mantenimiento preventivo por kilometraje, entonces el seguimiento por kilometraje de ese vehículo queda actualizado.
- **CA-5** Dado una alerta pendiente, cuando el coordinador registra un mantenimiento que la atiende, entonces la alerta deja de aparecer entre las pendientes.
- **CA-6** Dado un mantenimiento registrado, cuando el coordinador corrige sus datos y confirma, entonces el historial muestra los datos corregidos al volver a abrir la aplicación.
- **CA-7** Dado un mantenimiento registrado, cuando el coordinador lo elimina y confirma, entonces deja de aparecer en el historial.

## Fuera de alcance

- Programar mantenimientos futuros fuera de las alertas predictivas (cubierto en F-04).

## Preguntas abiertas

- Ninguna. Las fotos de evidencia se adjuntan a un mantenimiento ya registrado: ver F-07.

## Historial

- 1.0.0 · 2026-11-26 · Aprobada para la Entrega 3. Se agregan atender una alerta, corregir y eliminar un mantenimiento (A2 a A4, CA-5 a CA-7), que el prototipo de la Entrega 2 ya hacía pero la spec dejaba fuera; se cierra la pregunta abierta (la evidencia va en F-07).
- 0.1.0 · 2026-11-06 · Primera versión.
- 0.2.0 · 2026-11-06 · Se agregó CA-4 para cubrir el flujo alterno A1 (mantenimiento preventivo por kilometraje).
