import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

/// Lecturas de la flota: zonas, vehículos, conductores, turnos, viajes y telemetría.
class FleetService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Zona>> getZonas() async {
    final filas = await _client.from('zona').select().order('id_zona');
    return filas.map(Zona.fromMap).toList();
  }

  Future<List<Vehiculo>> getVehiculos() async {
    final filas = await _client.from('vehiculo').select().order('id_vehiculo');
    return filas.map(Vehiculo.fromMap).toList();
  }

  Future<List<Conductor>> getConductores() async {
    final filas = await _client.from('conductor').select().order('id_conductor');
    return filas.map(Conductor.fromMap).toList();
  }

  /// La más reciente primero: así la primera de cada vehículo es su conductor actual.
  Future<List<AsignacionTurno>> getAsignaciones() async {
    final filas = await _client
        .from('asignacion_turno')
        .select()
        .order('fecha', ascending: false)
        .order('id_asignacion', ascending: false);
    return filas.map(AsignacionTurno.fromMap).toList();
  }

  Future<List<Viaje>> getViajes() async {
    final filas = await _client.from('viaje').select().order('id_viaje');
    return filas.map(Viaje.fromMap).toList();
  }

  Future<List<EventoConduccion>> getEventos() async {
    final filas = await _client.from('evento_conduccion').select().order('fecha_hora', ascending: false);
    return filas.map(EventoConduccion.fromMap).toList();
  }

  /// La más reciente primero: la primera lectura de cada vehículo es la última que reportó.
  Future<List<TelemetriaGps>> getGps() async {
    final filas = await _client.from('telemetria_gps').select().order('fecha_hora', ascending: false);
    return filas.map(TelemetriaGps.fromMap).toList();
  }

  Future<List<TelemetriaObd>> getObd() async {
    final filas = await _client.from('telemetria_obd').select().order('fecha_hora', ascending: false);
    return filas.map(TelemetriaObd.fromMap).toList();
  }

  /// TS-03: la última lectura GPS del vehículo, o null si nunca reportó.
  Future<TelemetriaGps?> getUltimoGps(int idVehiculo) async {
    final fila = await _client
        .from('telemetria_gps')
        .select()
        .eq('id_vehiculo', idVehiculo)
        .order('fecha_hora', ascending: false)
        .limit(1)
        .maybeSingle();
    return fila == null ? null : TelemetriaGps.fromMap(fila);
  }

  /// TS-03: la última lectura OBD-II del vehículo, o null si nunca reportó.
  Future<TelemetriaObd?> getUltimoObd(int idVehiculo) async {
    final fila = await _client
        .from('telemetria_obd')
        .select()
        .eq('id_vehiculo', idVehiculo)
        .order('fecha_hora', ascending: false)
        .limit(1)
        .maybeSingle();
    return fila == null ? null : TelemetriaObd.fromMap(fila);
  }

  /// TS-03: los eventos de conducción de un vehículo, del más reciente al más antiguo.
  Future<List<EventoConduccion>> getEventosDe(int idVehiculo) async {
    final filas = await _client
        .from('evento_conduccion')
        .select()
        .eq('id_vehiculo', idVehiculo)
        .order('fecha_hora', ascending: false);
    return filas.map(EventoConduccion.fromMap).toList();
  }

  /// Actualiza el kilometraje actual de un vehículo (y opcionalmente el km del último preventivo).
  Future<void> actualizarKilometraje(int idVehiculo, double km, {double? kmUltimoPreventivo}) async {
    final valores = <String, dynamic>{'kilometraje_actual': km};
    if (kmUltimoPreventivo != null) {
      valores['km_ultimo_preventivo'] = kmUltimoPreventivo;
    }
    await _client.from('vehiculo').update(valores).eq('id_vehiculo', idVehiculo);
  }
}
