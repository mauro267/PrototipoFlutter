---
documento: modelo
proyecto: RutaViva
version: 0.2.0
fecha: 2026-11-26
estado: borrador
fuente: MR_RutaViva.pdf (diagrama original en Oracle Data Modeler, Caso 4)
---

# Modelo de datos · RutaViva

Transcripción en texto del diagrama MER de `MR_RutaViva.pdf`, para que los agentes
y las skills puedan leerlo. El PDF original sigue siendo la referencia visual para
la entrega (diagrama MER pedido en la Entrega 1).

```mermaid
erDiagram
  ZONA ||--o{ VEHICULO : ubica
  ZONA ||--o{ CONDUCTOR : asigna
  VEHICULO ||--o{ ASIGNACION_TURNO : tiene
  CONDUCTOR ||--o{ ASIGNACION_TURNO : cubre
  ASIGNACION_TURNO ||--o{ VIAJE : genera
  VEHICULO ||--o{ EVENTO_CONDUCCION : registra
  VIAJE ||--o{ EVENTO_CONDUCCION : incluye
  VEHICULO ||--o{ TELEMETRIA_GPS : reporta
  VEHICULO ||--o{ TELEMETRIA_OBD : reporta
  VEHICULO ||--o{ PREDICCION_FALLA : genera
  VEHICULO ||--o{ MANTENIMIENTO : recibe
  PREDICCION_FALLA ||--o| MANTENIMIENTO : confirma
  USUARIO ||--o{ PREDICCION_FALLA : revisa
  USUARIO ||--o{ MANTENIMIENTO : registra
  CLIENTE_RETAILER ||--o{ ORDEN_ENTREGA : solicita
  VIAJE ||--o{ ORDEN_ENTREGA : entrega
  MANTENIMIENTO ||--o{ EVIDENCIA_MANTENIMIENTO : documenta

  ZONA {
    number id_zona PK
    varchar nombre UK
    varchar ciudad
    varchar pais
  }
  CONDUCTOR {
    number id_conductor PK
    varchar nombre
    varchar documento UK
    varchar telefono
    varchar licencia
    number id_zona FK
    boolean activo
  }
  VEHICULO {
    number id_vehiculo PK
    varchar placa UK
    varchar tipo
    varchar marca
    varchar modelo
    number id_zona FK
    varchar estado_operativo
    number kilometraje_actual
    boolean has_telemetry
    date fecha_instalacion_iot
    number intervalo_preventivo_km
    number km_ultimo_preventivo
  }
  ASIGNACION_TURNO {
    number id_asignacion PK
    number id_conductor FK
    number id_vehiculo FK
    date fecha
    timestamp hora_inicio
    timestamp hora_fin
  }
  VIAJE {
    number id_viaje PK
    varchar codigo UK
    number id_asignacion FK
    timestamp fecha_inicio
    timestamp fecha_fin
    number km_recorridos
    number paradas_totales
    number paradas_completadas
    varchar estado
  }
  EVENTO_CONDUCCION {
    number id_evento PK
    number id_vehiculo FK
    number id_viaje FK
    timestamp fecha_hora
    varchar tipo
    number magnitud
    varchar unidad
    varchar ubicacion
  }
  TELEMETRIA_GPS {
    number id_lectura PK
    number id_vehiculo FK
    timestamp fecha_hora
    number lat
    number lon
    number velocidad
  }
  TELEMETRIA_OBD {
    number id_lectura PK
    number id_vehiculo FK
    timestamp fecha_hora
    varchar codigo_falla
    number temp_motor
    number rpm
    number nivel_combustible
  }
  PREDICCION_FALLA {
    number id_prediccion PK
    number id_vehiculo FK
    date fecha_prediccion
    varchar componente
    number probabilidad
    date fecha_limite_mantenimiento
    varchar estado
    date fecha_programada
    number id_usuario_revision FK
  }
  MANTENIMIENTO {
    number id_mantenimiento PK
    number id_vehiculo FK
    number id_prediccion FK
    date fecha
    varchar origen
    varchar tipo_falla
    varchar descripcion
    number kilometraje
    number costo
    varchar moneda
    number horas_fuera_servicio
    boolean en_ruta
    number id_usuario_registro FK
  }
  CLIENTE_RETAILER {
    number id_cliente PK
    varchar nombre UK
    varchar pais
    varchar canal_integracion
    varchar formato_origen
  }
  ORDEN_ENTREGA {
    number id_orden PK
    varchar codigo UK
    number id_cliente FK
    number id_viaje FK
    varchar direccion_destino
    varchar ciudad
    timestamp fecha_creacion
    timestamp fecha_promesa
    timestamp fecha_entrega_real
    varchar estado
  }
  USUARIO {
    number id_usuario PK
    uuid auth_uuid UK
    varchar nombre
    varchar email UK
    varchar rol
    varchar pais
    boolean activo
  }
  EVIDENCIA_MANTENIMIENTO {
    number id_evidencia PK
    number id_mantenimiento FK
    varchar ruta UK
    varchar url
    timestamp fecha_subida
    uuid auth_uuid_subida
  }
  PARAMETRO {
    varchar clave PK
    number valor
  }
```

## Notas para el backend en Supabase

- `VEHICULO.has_telemetry` es la bandera central (AD-04 de `architectural_spine.md`):
  decide si un vehículo aparece en las vistas de telemetría/predicción o solo en
  mantenimiento preventivo por kilometraje.
- `PREDICCION_FALLA` y `MANTENIMIENTO` se enlazan por `id_prediccion`: un
  mantenimiento puede confirmar (o no) una predicción.
- `USUARIO` representa a quien usa la app (hoy, el Coordinador de Operaciones); su
  fila debe enlazarse con el `uuid` de Supabase Auth cuando se implemente (AD-03).
- `TELEMETRIA_GPS` y `TELEMETRIA_OBD` se cargan por lotes (no hay streaming real;
  ver *Diferido* en `architectural_spine.md`).

## Cambios de la Entrega 3 frente a `MR_RutaViva.pdf`

- `USUARIO.auth_uuid`: el `uuid` de la cuenta en Supabase Auth (AD-03). Es único y
  apunta a `auth.users`.
- `PREDICCION_FALLA.fecha_programada`: la fecha de la intervención programada desde
  una alerta (RF-02). `estado` toma `pendiente`, `programada`, `confirmada` o
  `descartada`.
- `EVENTO_CONDUCCION.unidad`: la unidad de `magnitud` (`g` o `km/h`).
- `MANTENIMIENTO.id_usuario_registro` admite nulo: los mantenimientos históricos de
  los datos de ejemplo no los registró nadie de la app.
- `EVIDENCIA_MANTENIMIENTO` (nueva, RF-13): una fila por foto subida al bucket
  `evidencias`; si se borra el mantenimiento, se borran sus filas.
- `PARAMETRO` (nueva, RF-09): valores configurables de la app; hoy solo
  `meta_otd` (fracción, 0,95 = 95 %).

## Historial

- 0.2.0 · 2026-11-26 · Entrega 3: columnas `auth_uuid`, `fecha_programada` y
  `unidad`, tablas `EVIDENCIA_MANTENIMIENTO` y `PARAMETRO`.

- 0.1.0 · 2026-11-06 · Transcripción inicial desde `MR_RutaViva.pdf`.
