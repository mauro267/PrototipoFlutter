---
id: F-07
titulo: Evidencia de mantenimiento
version: 1.0.0
fecha: 2026-11-26
estado: implementada
autores: [Mauricio Marín, Elías Saldarriaga, Juan Felipe Martínez, Daniel Cabal]
requisitos: [RF-13]
depende_de: [F-05]
---

# F-07 · Evidencia de mantenimiento

## Objetivo

El coordinador necesita dejar fotos de lo que se hizo en un mantenimiento (la pieza cambiada, la factura, el estado del vehículo) para poder verificarlo después.

## Flujo principal

1. Desde el historial de mantenimientos, el coordinador abre la evidencia de un mantenimiento.
2. El sistema muestra las fotos que ya tiene ese mantenimiento, de la más reciente a la más antigua.
3. El coordinador elige adjuntar una foto y la toma de la galería del dispositivo.
4. El sistema guarda la foto y la agrega a la evidencia del mantenimiento.

## Flujos alternos

- **A1 · Ver una foto:** el coordinador toca una foto y la ve en grande.
- **A2 · Cancelar:** si el coordinador abre la galería y no elige ninguna foto, no se agrega nada.

## Reglas

- Una foto siempre pertenece a un mantenimiento ya registrado.
- Las fotos no se reemplazan: cada foto adjuntada se agrega a las que ya había.
- Si se elimina un mantenimiento, su evidencia deja de mostrarse.

## Estados

- **Cargando:** mientras se traen las fotos o se guarda una nueva, el coordinador ve que se está procesando y no puede adjuntar otra al mismo tiempo.
- **Vacío:** si el mantenimiento aún no tiene fotos, el coordinador ve un aviso de que no hay evidencia y la opción de adjuntar la primera.
- **Error:** si las fotos no se pueden traer o guardar, el coordinador ve un mensaje explicando el problema y puede reintentar.

## Datos

- El mantenimiento al que pertenece la evidencia.
- Las fotos de evidencia, con la fecha en que se adjuntaron.

## Criterios de aceptación

- **CA-1** Dado un mantenimiento con fotos, cuando el coordinador abre su evidencia, entonces ve todas sus fotos con la fecha en que se adjuntaron.
- **CA-2** Dado un mantenimiento, cuando el coordinador adjunta una foto de la galería, entonces la foto aparece en su evidencia sin salir de la pantalla.
- **CA-3** Dado que el coordinador adjuntó una foto, cuando cierra la aplicación y vuelve a abrir la evidencia de ese mantenimiento, entonces la foto sigue ahí.
- **CA-4** Dado un mantenimiento sin fotos, cuando el coordinador abre su evidencia, entonces ve un aviso de que no hay evidencia.
- **CA-5** Dado que la foto no se puede guardar, cuando el coordinador la adjunta, entonces ve un mensaje de error y la evidencia queda como estaba.
- **CA-6** Dado que el coordinador abre la galería, cuando la cierra sin elegir una foto, entonces la evidencia queda como estaba.
- **CA-7** Dado una foto de evidencia, cuando el coordinador la toca, entonces la ve en grande.

## Fuera de alcance

- Borrar o reemplazar una foto ya adjuntada.
- Tomar la foto con la cámara dentro de la aplicación.
- Adjuntar documentos que no sean fotos.

## Preguntas abiertas

- Ninguna.

## Historial

- 1.0.0 · 2026-11-27 · Implementada.
- 1.0.0 · 2026-11-26 · Primera versión, aprobada para la Entrega 3 (RF-13).
