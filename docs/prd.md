---
documento: prd
proyecto: RutaViva
version: 0.3.0
fecha: 2026-11-26
estado: aprobado
autores: [Mauricio Marín, Elías Saldarriaga, Juan Felipe Martínez, Daniel Cabal]
---

# PRD · RutaViva

## Problema

RutaViva Logística es un operador de última milla con 1.200 vehículos, de los
cuales el 70% cuenta con sensores IoT que hoy solo se usan para reaccionar a fallas
ya ocurridas, generando sobrecostos de reparación, varadas en ruta y retrasos frente
a los retailers que atiende. El área de Operaciones no tiene, hoy, un lugar único
donde ver el estado de la flota, anticipar qué vehículos necesitan mantenimiento, o
medir de forma consolidada el cumplimiento de entregas frente a los cinco clientes
que atiende (cada uno con su propia integración de pedidos).

## Usuarios

- **Coordinador(a) de Operaciones**: entra todos los días a revisar el estado de la
  flota, atender las alertas de mantenimiento predictivo, agendar intervenciones,
  registrar los mantenimientos con su evidencia y revisar los indicadores de entrega
  y salud del parque vehicular.

## Objetivos

- **O-01** Anticipar el mantenimiento antes de que el vehículo se averíe en ruta.
  *Se cumple si* el sistema muestra alertas de falla prevista (vehículo, componente,
  probabilidad y plazo recomendado) antes del evento.
- **O-02** Dar visibilidad unificada de la flota en tiempo real. *Se cumple si* el
  coordinador puede ver, desde un solo panel, el estado y la ubicación de los
  vehículos agrupados por zona.
- **O-03** Reducir las varadas en ruta. *Se cumple si* el sistema calcula y muestra
  la tasa de varadas (fallas no planificadas en ruta sobre el total de viajes).
- **O-04** Medir el cumplimiento de entregas de forma consolidada entre los cinco
  retailers atendidos. *Se cumple si* el sistema calcula el porcentaje de entregas a
  tiempo (OTD) sobre un modelo común de orden, sin importar de qué cliente venga.
- **O-05** Convivir con el 30% de la flota sin telemetría instalada, sin distorsionar
  los indicadores agregados. *Se cumple si* esos vehículos quedan identificados
  explícitamente y siguen un esquema de mantenimiento preventivo por kilometraje,
  separado de las vistas predictivas.
- **O-06** Dejar evidencia verificable de los mantenimientos realizados. *Se cumple
  si* cada mantenimiento registrado puede tener fotos de evidencia que se consultan
  desde su historial.

## Alcance

### Incluye

- Creación de cuenta, inicio y cierre de sesión del coordinador.
- Panel principal con los indicadores clave (OTD, tasa de varadas, cobertura de
  telemetría) agrupados por zona.
- Detalle de un vehículo, con telemetría reciente cuando la tiene, y sin ella
  (conductor asignado, eventos de conducción, mantenimiento preventivo por
  kilometraje) cuando no la tiene.
- Alertas predictivas de falla, con acción para programar mantenimiento.
- Registro de un mantenimiento realizado (preventivo o correctivo).
- Fotos de evidencia de cada mantenimiento.
- Listado de órdenes de entrega con su estado, filtrable por cliente y estado.

### No incluye

- Una app o vista para los conductores.
- La integración real con los sistemas de los cinco retailers: se trabaja con datos
  de ejemplo que siguen el modelo canónico de orden.
- Notificaciones push o por correo, y cualquier proceso que corra solo, sin que el
  coordinador lo pida.
- Permisos distintos por usuario sobre los datos: todos los coordinadores ven la
  misma flota.
- Un motor de machine learning real para generar las predicciones de falla: se
  muestran y se gestionan, pero no se calculan dentro de esta app.

## Restricciones

- Entregas del curso: Entrega 1 (contexto, base de datos y prototipo, sin código),
  Entrega 2 (prototipo no funcional, con datos simulados), Entrega 3 (app final con
  datos persistentes, exhibida por el equipo).
- Plataformas: web y Android.
- El modelo de datos ya fue diseñado en el trabajo previo del Caso 4 (ver
  `docs/modelo.md`, basado en `MR_RutaViva.pdf`) y se reutiliza aquí.

## Preguntas abiertas

- Ninguna.

## Decisiones confirmadas

- Equipo: Mauricio Marín, Elías Saldarriaga, Juan Felipe Martínez, Daniel Cabal
  (el mismo del Caso 4).
- Un único rol de usuario para esta fase: Coordinador(a) de Operaciones. Un rol de
  Mecánico (con acceso solo a mantenimiento) queda como posible v2.
- Cualquier persona del área puede crear su cuenta desde la app; la cuenta nueva
  queda con el rol de coordinador.
- Los archivos que maneja la app son las fotos de evidencia de los mantenimientos.
- Los datos de ejemplo (flota, telemetría, predicciones y órdenes) son un conjunto
  fijo que carga el equipo; no se generan al azar.

## Historial

- 0.3.0 · 2026-11-26 · Entrega 3. Se agregan O-06 (evidencia de mantenimientos) y la
  creación de cuenta y el cierre de sesión al alcance; se resuelven las dos preguntas
  abiertas; se quitan los nombres de tecnología del alcance y de las restricciones,
  según el dictamen del taller.
- 0.1.2 · 2026-11-06 · Se corrigió el campo de autores del encabezado para que coincida con el equipo confirmado.
- 0.1.1 · 2026-11-06 · Equipo y alcance de roles confirmados por el equipo.
- 0.1.0 · 2026-11-06 · Primera versión, redactada a partir del contexto del Caso 4,
  el modelo de datos y el prototipo en Stitch.
