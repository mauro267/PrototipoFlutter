-- Datos de ejemplo de RutaViva: los mismos del prototipo de la Entrega 2
-- (lib/services/simulated_data.dart), ahora como filas. Las fechas son relativas
-- al momento en que se sube la migración. La telemetría y las predicciones se
-- cargan como datos (spine AD-05); los usuarios los crea la app al registrarse.

insert into public.zona (id_zona, nombre, ciudad, pais) values
  (1, 'Bogotá Norte', 'Bogotá', 'Colombia'),
  (2, 'Medellín', 'Medellín', 'Colombia'),
  (3, 'Cali', 'Cali', 'Colombia'),
  (4, 'Quito', 'Quito', 'Ecuador');

insert into public.vehiculo (id_vehiculo, placa, tipo, marca, modelo, id_zona, estado_operativo,
  kilometraje_actual, has_telemetry, fecha_instalacion_iot, intervalo_preventivo_km, km_ultimo_preventivo) values
  (1, 'ABC-123', 'furgon', 'Mercedes-Benz', 'Sprinter 519 CDI', 1, 'en_ruta', 142880, true, '2024-03-12', 20000, 135000),
  (2, 'YAM-88F', 'moto', 'Yamaha', 'FZ25', 4, 'en_ruta', 18420, true, '2025-01-20', 5000, 15000),
  (3, 'BOG-452', 'camion', 'Chevrolet', 'N300 Cargo', 1, 'varado', 98210, true, '2024-06-02', 10000, 91000),
  (4, 'MED-771', 'tractocamion', 'Kenworth', 'T680', 2, 'en_ruta', 311400, true, '2023-11-08', 25000, 295000),
  (5, 'BUC-209', 'camion', 'Hino', 'Dutro Pro', 2, 'disponible', 76500, false, null, 10000, 70200),
  (6, 'CAL-310', 'furgon', 'Renault', 'Master', 3, 'en_ruta', 54300, true, '2025-04-15', 15000, 45000),
  (7, 'CAL-311', 'furgon', 'Renault', 'Master', 3, 'disponible', 121900, false, null, 15000, 108000),
  (8, 'UIO-120', 'camion', 'Isuzu', 'NPR', 4, 'en_ruta', 203300, true, '2024-09-30', 15000, 192000),
  (9, 'UIO-121', 'camion', 'Isuzu', 'NPR', 4, 'mantenimiento', 188000, false, null, 15000, 172000),
  (10, 'BOG-901', 'furgon', 'Ford', 'Transit', 1, 'disponible', 33100, true, '2025-07-01', 15000, 30000),
  (11, 'MED-455', 'furgon', 'Hyundai', 'H100', 2, 'alerta', 167400, true, '2024-02-18', 15000, 155000),
  (12, 'CAL-880', 'camion', 'Hino', '300', 3, 'en_ruta', 90100, false, null, 10000, 83000);

insert into public.conductor (id_conductor, nombre, documento, telefono, licencia, id_zona) values
  (1, 'Mateo Silva', '1010223344', '300 555 0101', 'C2', 1),
  (2, 'Camila Restrepo', '1020334455', '300 555 0102', 'A2', 4),
  (3, 'Javier Ortiz', '1030445566', '300 555 0103', 'C2', 1),
  (4, 'Hernando Gómez', '1040556677', '300 555 0104', 'C3', 2),
  (5, 'Laura Peña', '1050667788', '300 555 0105', 'C2', 2),
  (6, 'Andrés Cárdenas', '1060778899', '300 555 0106', 'C1', 3),
  (7, 'Sofía Almeida', '1070889900', '300 555 0107', 'C1', 3),
  (8, 'Diego Narváez', '1080990011', '300 555 0108', 'C2', 4),
  (9, 'Paula Rincón', '1091001122', '300 555 0109', 'C1', 1),
  (10, 'Esteban Mora', '1101112233', '300 555 0110', 'C2', 2);

insert into public.asignacion_turno (id_asignacion, id_conductor, id_vehiculo, fecha) values
  (1, 1, 1, current_date), (2, 2, 2, current_date), (3, 3, 3, current_date),
  (4, 4, 4, current_date), (5, 5, 5, current_date), (6, 6, 6, current_date),
  (7, 7, 7, current_date), (8, 8, 8, current_date), (9, 9, 10, current_date),
  (10, 10, 11, current_date);

-- 400 viajes repartidos entre las asignaciones; los 4 más recientes siguen en curso.
insert into public.viaje (id_viaje, codigo, id_asignacion, fecha_inicio, fecha_fin, km_recorridos,
  paradas_totales, paradas_completadas, estado)
select
  i + 1,
  'VJ-' || (1000 + i),
  (i % 10) + 1,
  now() - make_interval(hours => 6 + i * 5),
  case when i < 4 then null else now() - make_interval(hours => 6 + i * 5) + interval '5 hours' end,
  60 + (i * 13) % 140,
  8 + i % 7,
  case when i < 4 then (8 + i % 7) / 2 else 8 + i % 7 end,
  case when i < 4 then 'en_curso' else 'completado' end
from generate_series(0, 399) as i;

-- Telemetría solo para vehículos con has_telemetry = true (AD-04).
insert into public.telemetria_gps (id_vehiculo, fecha_hora, lat, lon, velocidad) values
  (1, now() - interval '1 minute', 4.7110, -74.0721, 64),
  (2, now() - interval '2 minutes', -0.1807, -78.4678, 38),
  (3, now() - interval '3 minutes', 4.8120, -74.0350, 0),
  (4, now() - interval '1 minute', 6.2518, -75.5636, 72),
  (6, now() - interval '2 minutes', 3.4516, -76.5320, 51),
  (8, now() - interval '1 minute', -0.2200, -78.5120, 45),
  (10, now() - interval '5 minutes', 4.6486, -74.1100, 0),
  (11, now() - interval '2 minutes', 6.2100, -75.6000, 28);

insert into public.telemetria_obd (id_vehiculo, fecha_hora, codigo_falla, temp_motor, rpm, nivel_combustible) values
  (1, now() - interval '1 minute', null, 92, 2150, 78),
  (2, now() - interval '2 minutes', null, 84, 6200, 92),
  (3, now() - interval '3 minutes', 'P0301', 114, 0, 41),
  (4, now() - interval '1 minute', null, 95, 1650, 94),
  (6, now() - interval '2 minutes', null, 89, 1900, 63),
  (8, now() - interval '1 minute', 'P0087', 99, 2300, 55),
  (10, now() - interval '5 minutes', null, 70, 780, 88),
  (11, now() - interval '2 minutes', 'P0299', 103, 2050, 36);

insert into public.evento_conduccion (id_evento, id_vehiculo, id_viaje, fecha_hora, tipo, magnitud, unidad, ubicacion) values
  (1, 1, 1, now() - interval '35 minutes', 'Frenada brusca', 0.62, 'g', 'Autopista Norte km 42'),
  (2, 1, 1, now() - interval '190 minutes', 'Frenada brusca', 0.48, 'g', 'Salida del depósito'),
  (3, 3, 3, now() - interval '75 minutes', 'Exceso de velocidad', 92, 'km/h', 'Calle 80 con Boyacá'),
  (4, 4, 4, now() - interval '120 minutes', 'Aceleración brusca', 0.41, 'g', 'Alto de Minas'),
  (5, 5, 5, now() - interval '300 minutes', 'Giro brusco', 0.38, 'g', 'Bucaramanga, Carrera 27'),
  (6, 7, 7, now() - interval '410 minutes', 'Frenada brusca', 0.55, 'g', 'Cali, Calle 5'),
  (7, 7, 7, now() - interval '900 minutes', 'Exceso de velocidad', 84, 'km/h', 'Vía Cali–Jamundí'),
  (8, 11, 10, now() - interval '60 minutes', 'Giro brusco', 0.44, 'g', 'Medellín, Av. Regional');

-- Predicciones de falla: se cargan, no se calculan (AD-05).
insert into public.prediccion_falla (id_prediccion, id_vehiculo, fecha_prediccion, componente, probabilidad,
  fecha_limite_mantenimiento, estado, fecha_programada) values
  (1, 1, current_date, 'Pastillas y rotor de freno delantero', 0.87, current_date + 2, 'pendiente', null),
  (2, 3, current_date, 'Sistema de refrigeración', 0.93, current_date + 1, 'pendiente', null),
  (3, 11, current_date - 1, 'Turbocompresor', 0.64, current_date + 9, 'pendiente', null),
  (4, 4, current_date - 2, 'Alternador', 0.41, current_date + 21, 'pendiente', null),
  (5, 8, current_date - 3, 'Embrague', 0.72, current_date + 6, 'programada', current_date + 4);

insert into public.mantenimiento (id_mantenimiento, id_vehiculo, fecha, origen, tipo_falla, descripcion,
  kilometraje, costo, horas_fuera_servicio, en_ruta) values
  (1, 3, current_date - 12, 'correctivo', 'Falla eléctrica', 'Cambio de batería y revisión del cableado.', 97500, 780000, 9, true),
  (2, 1, current_date - 20, 'preventivo', 'Preventivo programado', 'Cambio de aceite y filtros.', 135000, 1450000, 5, false),
  (3, 4, current_date - 27, 'correctivo', 'Neumático', 'Pinchazo en ruta; cambio de llanta trasera.', 309900, 920000, 4, true),
  (4, 9, current_date - 3, 'correctivo', 'Transmisión', 'Ruido en caja de cambios; en revisión en taller.', 187600, 3200000, 52, true),
  (5, 7, current_date - 40, 'preventivo', 'Preventivo por kilometraje', 'Cambio de aceite, frenos y alineación.', 108000, 1100000, 6, false),
  (6, 6, current_date - 55, 'preventivo', 'Preventivo programado', 'Revisión general y cambio de filtros.', 45000, 870000, 4, false);

insert into public.cliente_retailer (id_cliente, nombre, pais, canal_integracion, formato_origen) values
  (1, 'Éxito', 'Colombia', 'API REST', 'JSON'),
  (2, 'Falabella', 'Colombia', 'SFTP', 'CSV'),
  (3, 'Farmatodo', 'Colombia', 'API REST', 'JSON'),
  (4, 'Alkosto', 'Colombia', 'Webhook', 'XML'),
  (5, 'Jumbo', 'Colombia', 'SFTP', 'CSV');

-- 20 órdenes con el modelo canónico; la promesa arranca hoy a las 8:00 (hora Bogotá) - 10 h.
with base as (
  select (date_trunc('day', now() at time zone 'America/Bogota') + interval '8 hours')
           at time zone 'America/Bogota' as b
),
est as (
  select (n - 1)::int as i, e
  from unnest(array[
    'a_tiempo', 'a_tiempo', 'en_camino', 'en_riesgo', 'a_tiempo',
    'a_tiempo', 'pendiente', 'en_camino', 'a_tiempo', 'a_tiempo',
    'retrasada', 'a_tiempo', 'en_riesgo', 'a_tiempo', 'pendiente',
    'a_tiempo', 'a_tiempo', 'a_tiempo', 'en_camino', 'a_tiempo'
  ]) with ordinality as t(e, n)
)
insert into public.orden_entrega (id_orden, codigo, id_cliente, id_viaje, direccion_destino, ciudad,
  fecha_creacion, fecha_promesa, fecha_entrega_real, estado)
select
  i + 1,
  'RV-' || (88291 + i),
  (i % 5) + 1,
  case when e in ('en_camino', 'en_riesgo') then (i % 4) + 1
       when e = 'pendiente' then null
       else 5 + i end,
  (array['Calle 80 # 69-20', 'Carrera 43A # 1-50', 'Av. 6N # 28-10', 'Av. Amazonas N24-15', 'Carrera 7 # 72-41'])[i % 5 + 1],
  (array['Bogotá', 'Medellín', 'Cali', 'Quito', 'Bogotá'])[i % 5 + 1],
  p - interval '20 hours',
  p,
  case when e = 'a_tiempo' then p - make_interval(mins => 5 + (i * 7) % 20)
       when e = 'retrasada' then p + interval '70 minutes' end,
  e
from est, base, lateral (select b + make_interval(mins => 90 * i - 600) as p) q;

insert into public.parametro (clave, valor) values ('meta_otd', 0.95);

-- Las llaves se cargaron a mano: cada identidad sigue después del último id.
select setval(pg_get_serial_sequence('public.zona', 'id_zona'), (select max(id_zona) from public.zona));
select setval(pg_get_serial_sequence('public.vehiculo', 'id_vehiculo'), (select max(id_vehiculo) from public.vehiculo));
select setval(pg_get_serial_sequence('public.conductor', 'id_conductor'), (select max(id_conductor) from public.conductor));
select setval(pg_get_serial_sequence('public.asignacion_turno', 'id_asignacion'), (select max(id_asignacion) from public.asignacion_turno));
select setval(pg_get_serial_sequence('public.viaje', 'id_viaje'), (select max(id_viaje) from public.viaje));
select setval(pg_get_serial_sequence('public.evento_conduccion', 'id_evento'), (select max(id_evento) from public.evento_conduccion));
select setval(pg_get_serial_sequence('public.prediccion_falla', 'id_prediccion'), (select max(id_prediccion) from public.prediccion_falla));
select setval(pg_get_serial_sequence('public.mantenimiento', 'id_mantenimiento'), (select max(id_mantenimiento) from public.mantenimiento));
select setval(pg_get_serial_sequence('public.cliente_retailer', 'id_cliente'), (select max(id_cliente) from public.cliente_retailer));
select setval(pg_get_serial_sequence('public.orden_entrega', 'id_orden'), (select max(id_orden) from public.orden_entrega));
