# RutaViva — Contexto del proyecto

## Qué es

RutaViva es la app para el área de Operaciones de RutaViva Logística, un operador de
última milla con 1.200 vehículos (70% con telemetría IoT: GPS, acelerómetro, sensores
de motor y combustible). Hoy esa telemetría solo se usa de forma reactiva. La app la
convierte en una torre de control: anticipa el mantenimiento antes de la falla, da
visibilidad unificada de la flota por zona, y mide el cumplimiento de entregas (OTD)
de forma consolidada frente a los cinco retailers atendidos.

Este proyecto retoma el caso trabajado antes en Seminario de Ingeniería de Software
(Caso 4 · RutaViva Logística, reto Lovelytics x ICESI): la arquitectura de datos y el
modelo relacional definidos ahí (ver `docs/modelo.md`) son la base del backend en
Supabase para esta app.

## Stack

- Frontend: Flutter (web + Android).
- Backend: Supabase — Auth, Postgres vía PostgREST, Storage.
- Sin servidor propio: la app habla directo con Supabase a través de `supabase_flutter`.
  (Ver `docs/architectural_spine.md` para las invariantes.)

## Estructura de lib/

Prototipo navegable de la Entrega 2 (datos simulados en memoria, sin Supabase todavía).
Regla de estado: **el estado vive en la Screen anfitriona; las Pages muestran y
reportan con callbacks; ninguna Page guarda datos de la app.**

- `main.dart`, `theme.dart` — arranque, tema, localización es-CO.
- `models/models.dart` — clases Dart alineadas con `docs/modelo.md` (incluye
  `Viaje` y `Usuario`) y los borradores de formularios.
- `services/` — `simulated_data.dart` (datos iniciales coherentes con el modelo) y
  `auth_service.dart` (login simulado). En la Entrega 3 se reemplazan por
  servicios con `supabase_flutter` (AD-01, AD-02, AD-03).
- `state/app_store.dart` — datos en memoria + crear/editar/eliminar + indicadores.
  Lo crea y posee `HomeScreen`.
- `screens/` — anfitrionas con estado y navegación: `login_screen`, `home_screen`
  (barra inferior en móvil, menú lateral en pantallas anchas), `fleet_screen`,
  `maintenance_screen`, `orders_screen`, `vehicle_detail_screen`.
  `acciones_mantenimiento.dart` agrupa las acciones que comparten dos pantallas.
- `pages/` — vistas sin estado: `login_page`, `fleet_page`, `maintenance_page`,
  `orders_page`, `vehicle_detail_page`.
- `components/` — widgets reutilizables, cada uno definido una sola vez:
  `AppButton`, `AppTextField`, `AppSelect`, `Panel`, `Insignia`, `Kpi`,
  `TarjetaVehiculo`, `TarjetaAlerta`, `TarjetaPreventivo`, `FilaMantenimiento`,
  `FilaOrden`, `MapaFlota`, formularios y diálogos.
- `utils/` — `format.dart` (es-CO) y `estados.dart` (colores por estado).

CRUD en pantalla: mantenimientos (crear, editar, eliminar), alertas (programar,
cancelar) y órdenes (crear, marcar entregada, eliminar).

Para generar las carpetas de plataforma: `flutter create . --platforms=web,android`.

## Documentos

`docs/` tiene:

- `prd.md` — el problema, los usuarios y los objetivos medibles.
- `requisitos.md` — los RF y RNF, ligados a cada objetivo.
- `architectural_spine.md` — el stack y las invariantes de arquitectura.
- `modelo.md` — el modelo de datos (entidades, PK, FK) basado en `MR_RutaViva.pdf`.
- `specs/` — una spec funcional por funcionalidad (pendiente, Paso 5 del taller).
