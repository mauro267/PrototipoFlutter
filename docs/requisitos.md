---
documento: requisitos
proyecto: RutaViva
version: 0.1.0
fecha: 2026-11-06
estado: borrador
basado_en: prd 0.1.0
---

# Requisitos · RutaViva

## Funcionales

### O-01 · Anticipar el mantenimiento antes de que el vehículo se averíe en ruta

- **RF-01** El sistema debe permitir ver una lista de alertas predictivas de falla,
  cada una con el vehículo, el componente afectado, la probabilidad de falla y la
  fecha límite recomendada de intervención. *Debe*
- **RF-02** El sistema debe permitir programar una intervención de mantenimiento a
  partir de una alerta predictiva. *Debe*
- **RF-03** El sistema debe permitir registrar un mantenimiento realizado
  (preventivo o correctivo), con tipo de falla, kilometraje, costo y horas fuera de
  servicio. *Debe*

### O-02 · Dar visibilidad unificada de la flota en tiempo real

- **RF-04** El sistema debe mostrar un panel con el estado operativo de cada
  vehículo, agrupado por zona. *Debe*
- **RF-05** El sistema debe permitir consultar el detalle de un vehículo, incluida
  su telemetría más reciente cuando el vehículo tiene sensores instalados. *Debe*
- **RF-06** El sistema debe distinguir visualmente los vehículos que no tienen
  telemetría instalada. (O-02, O-05) *Debe*

### O-03 · Reducir las varadas en ruta

- **RF-07** El sistema debe calcular la tasa de varadas en ruta, como la proporción
  de eventos de falla no planificada sobre el total de viajes. *Debe*

### O-04 · Medir el cumplimiento de entregas de forma consolidada

- **RF-08** El sistema debe mostrar un listado de órdenes de entrega con su estado
  (a tiempo, en camino, en riesgo, retrasada, pendiente). *Debe*
- **RF-09** El sistema debe calcular el porcentaje de entregas a tiempo (OTD) frente
  a una meta configurable. *Debe*
- **RF-10** El sistema debe permitir filtrar las órdenes de entrega por cliente
  retailer y por estado. *Debería*

### O-05 · Convivir con la flota sin telemetría

- **RF-11** El sistema debe permitir dar seguimiento al mantenimiento preventivo por
  kilometraje de los vehículos sin sensores instalados. *Debe*
- **RF-12** El sistema debe calcular la cobertura de telemetría, como la proporción
  de vehículos con sensores instalados sobre el total de la flota. *Debe*

## No funcionales

- **RNF-01** La aplicación debe ejecutar en Flutter Web y en Android. (todos) *Debe*
- **RNF-02** El panel principal debe mostrar sus indicadores en menos de 3 segundos
  con una conexión wifi estándar. (O-02) *Debería*
- **RNF-03** Todo el contenido visible debe estar en español (Colombia), con punto
  para miles y coma para decimales. (todos) *Debe*
- **RNF-04** El acceso a la aplicación debe requerir inicio de sesión autenticado.
  (todos) *Debe*

## Preguntas abiertas

- ¿RF-10 (filtrar por cliente y estado) debe ser *Debe* en lugar de *Debería* para
  la Entrega 2, dado que el prototipo en Stitch ya lo incluye?
- ¿Hay un requisito de desempeño para el cálculo de las predicciones de falla, o
  eso corre fuera de esta app (según se definió en O-01 y el alcance del PRD)?

## Historial

- 0.1.0 · 2026-11-06 · Primera versión, derivada del PRD 0.1.0.
