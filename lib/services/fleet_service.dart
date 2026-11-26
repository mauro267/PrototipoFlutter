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
}
