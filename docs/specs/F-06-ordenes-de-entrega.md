---
id: F-06
titulo: Órdenes de entrega
version: 1.0.0
fecha: 2026-11-26
estado: aprobada
autores: [Mauricio Marín, Elías Saldarriaga, Juan Felipe Martínez, Daniel Cabal]
requisitos: [RF-08, RF-10]
depende_de: []
---

# F-06 · Órdenes de entrega

## Objetivo

El coordinador necesita ver el estado de las entregas a los clientes retailer para saber cuáles están a tiempo y cuáles requieren seguimiento.

## Flujo principal

1. El coordinador abre el listado de órdenes de entrega.
2. El sistema muestra cada orden con su cliente retailer y su estado (a tiempo, en camino, en riesgo, retrasada, pendiente).
3. El coordinador filtra el listado por cliente retailer o por estado.
4. El sistema muestra solo las órdenes que cumplen el filtro elegido.

## Flujos alternos

- **A1 · Quitar el filtro:** el coordinador puede quitar el filtro aplicado y volver a ver el listado completo.
- **A2 · Registrar una orden:** el coordinador registra una orden que llegó por fuera de las integraciones (cliente, dirección, ciudad y fecha prometida); queda pendiente.
- **A3 · Marcar entregada:** el coordinador marca una orden como entregada; queda *a tiempo* si se entregó antes de la fecha prometida y *retrasada* si no, y el porcentaje de entregas a tiempo se actualiza.
- **A4 · Eliminar una orden:** el coordinador elimina una orden registrada por error, después de confirmarlo.

## Reglas

- Cada orden de entrega debe tener uno de los estados definidos: a tiempo, en camino, en riesgo, retrasada o pendiente.
- El listado se puede filtrar por cliente retailer y por estado, de forma independiente o combinada.
- Una orden nueva necesita cliente, dirección, ciudad y fecha prometida.
- Solo se marca como entregada una orden que aún no se ha entregado.

## Estados

- **Cargando:** mientras se trae el listado de órdenes, el coordinador ve que está cargando.
- **Vacío:** si no hay órdenes que cumplan el filtro elegido, el coordinador ve un aviso de que no hay resultados para ese filtro.
- **Error:** si el listado no se puede cargar, el coordinador ve un mensaje explicando el problema y puede reintentar.

## Datos

- Las órdenes de entrega: cliente retailer y estado.

## Criterios de aceptación

- **CA-1** Dado que hay órdenes de entrega registradas, cuando el coordinador abre el listado, entonces ve cada orden con su cliente retailer y su estado.
- **CA-2** Dado que el coordinador filtra por un cliente retailer y un estado, cuando aplica el filtro, entonces ve solo las órdenes que cumplen ambas condiciones.
- **CA-3** Dado que ningún resultado cumple el filtro elegido, cuando el coordinador lo aplica, entonces ve un aviso de que no hay resultados.
- **CA-4** Dado que el listado no se puede cargar, cuando el coordinador lo abre, entonces ve un mensaje de error y puede reintentar.
- **CA-5** Dado que el coordinador tiene un filtro aplicado, cuando lo quita, entonces vuelve a ver el listado completo de órdenes de entrega.

- **CA-6** Dado que el coordinador completa cliente, dirección, ciudad y fecha prometida, cuando registra la orden, entonces aparece en el listado como pendiente y sigue ahí al volver a abrir la aplicación.
- **CA-7** Dado una orden sin entregar cuya fecha prometida no ha pasado, cuando el coordinador la marca como entregada, entonces queda *a tiempo* y el porcentaje de entregas a tiempo del panel se actualiza.
- **CA-8** Dado una orden, cuando el coordinador la elimina y confirma, entonces deja de aparecer en el listado.

## Fuera de alcance

- Editar los datos de una orden ya registrada.
- La integración real con los sistemas de pedidos de los clientes retailer.

## Preguntas abiertas

- Ninguna. RF-10 pasó a *Debe* en requisitos 0.3.0.

## Historial

- 1.0.0 · 2026-11-26 · Aprobada para la Entrega 3. Se agregan registrar una orden, marcarla entregada y eliminarla (A2 a A4, CA-6 a CA-8), que el prototipo de la Entrega 2 ya hacía pero la spec dejaba fuera; se cierra la pregunta abierta.
- 0.1.0 · 2026-11-06 · Primera versión.
- 0.2.0 · 2026-11-06 · Se agregó CA-5 para cubrir el flujo alterno A1 (quitar el filtro).
