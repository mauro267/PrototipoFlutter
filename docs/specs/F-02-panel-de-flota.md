---
id: F-02
titulo: Panel de flota
version: 1.0.0
fecha: 2026-11-26
estado: implementada
autores: [Mauricio Marín, Elías Saldarriaga, Juan Felipe Martínez, Daniel Cabal]
requisitos: [RF-04, RF-06, RF-07, RF-09, RF-12]
depende_de: [F-01]
---

# F-02 · Panel de flota

## Objetivo

El coordinador necesita ver, de un vistazo, cómo está operando toda la flota por zona, para saber dónde poner atención primero.

## Flujo principal

1. El coordinador entra al panel de flota después de iniciar sesión.
2. El sistema muestra los indicadores generales: porcentaje de entregas a tiempo, tasa de varadas en ruta y cobertura de telemetría.
3. El sistema muestra los vehículos agrupados por zona, distinguiendo visualmente los que no tienen telemetría instalada.
4. El coordinador elige un vehículo para ver su detalle.

## Flujos alternos

- **A1 · Filtrar por zona:** el coordinador elige una zona y el sistema muestra solo los vehículos de esa zona, con los indicadores recalculados para ella.
- **A2 · Cambiar la meta:** desde la sección de entregas, el coordinador cambia la meta de entregas a tiempo; el panel compara el porcentaje con la nueva meta y la conserva para la próxima vez que entre.

## Reglas

- La cobertura de telemetría se calcula como la proporción de vehículos con sensores instalados sobre el total de la flota.
- La tasa de varadas en ruta se calcula como la proporción de eventos de falla no planificada sobre el total de viajes.
- El porcentaje de entregas a tiempo se compara contra una meta configurable.
- Un vehículo sin telemetría instalada se distingue visualmente de uno que sí la tiene, en todo el panel.

## Estados

- **Cargando:** mientras se calculan los indicadores y se arma el listado, el coordinador ve que el panel está cargando.
- **Vacío:** si una zona no tiene vehículos registrados, el coordinador ve un aviso de que no hay vehículos en esa zona.
- **Error:** si los indicadores no se pueden calcular, el coordinador ve un mensaje explicando que no fue posible cargar el panel y puede reintentar.

## Datos

- Las zonas de operación.
- Los vehículos de la flota, con su zona y si tienen o no telemetría instalada.
- Los viajes y eventos de falla no planificada, para calcular la tasa de varadas.
- Las entregas y la meta configurable de entregas a tiempo.

## Criterios de aceptación

- **CA-1** Dado que el coordinador entra al panel, cuando la carga termina, entonces ve el porcentaje de entregas a tiempo, la tasa de varadas y la cobertura de telemetría.
- **CA-2** Dado que un vehículo no tiene telemetría instalada, cuando el coordinador ve el panel, entonces ese vehículo se distingue visualmente de los que sí la tienen.
- **CA-3** Dado que el coordinador filtra por una zona sin vehículos, cuando aplica el filtro, entonces ve un aviso de que no hay vehículos en esa zona.
- **CA-4** Dado que los indicadores no se pueden calcular, cuando el coordinador abre el panel, entonces ve un mensaje de error y puede reintentar.
- **CA-5** Dado que el coordinador filtra por una zona con vehículos, cuando aplica el filtro, entonces ve solo los vehículos de esa zona con los indicadores recalculados para ella.

- **CA-6** Dado que el coordinador cambia la meta de entregas a tiempo, cuando cierra la aplicación y vuelve a entrar, entonces el panel muestra la nueva meta y compara el porcentaje contra ella.

## Fuera de alcance

- La forma en que se definen o ajustan los límites de las zonas.
- Notificaciones automáticas cuando un indicador empeora.

## Preguntas abiertas

- Ninguna. La meta la cambia el coordinador desde la sección de entregas (flujo A2) y se conserva entre sesiones.

## Historial

- 1.0.0 · 2026-11-27 · Implementada.
- 1.0.0 · 2026-11-26 · Aprobada para la Entrega 3; se agrega el flujo A2 (cambiar la meta) con su CA-6 y se cierra la pregunta abierta.
- 0.1.0 · 2026-11-06 · Primera versión.
- 0.2.0 · 2026-11-06 · Se agregó CA-5 para cubrir el flujo alterno A1 (filtrar por zona) en su caso con resultados.
