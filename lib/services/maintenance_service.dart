import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

/// Predicciones de falla y mantenimientos. Las escrituras llegan en TS-04 y TS-05.
class MaintenanceService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<PrediccionFalla>> getPredicciones() async {
    final filas = await _client.from('prediccion_falla').select().order('id_prediccion');
    return filas.map(PrediccionFalla.fromMap).toList();
  }

  Future<List<Mantenimiento>> getMantenimientos() async {
    final filas = await _client.from('mantenimiento').select().order('fecha', ascending: false);
    return filas.map(Mantenimiento.fromMap).toList();
  }

  /// TS-03: el historial de un vehículo, del más reciente al más antiguo.
  Future<List<Mantenimiento>> getMantenimientosDe(int idVehiculo) async {
    final filas = await _client
        .from('mantenimiento')
        .select()
        .eq('id_vehiculo', idVehiculo)
        .order('fecha', ascending: false);
    return filas.map(Mantenimiento.fromMap).toList();
  }

  /// Inserta un nuevo mantenimiento en Supabase y retorna el registro creado con su id generado.
  Future<Mantenimiento> crearMantenimiento(Mantenimiento m) async {
    final fila = await _client.from('mantenimiento').insert(m.toMap()).select().single();
    return Mantenimiento.fromMap(fila);
  }

  /// Marca una predicción de falla como confirmada indicando el usuario que la revisó.
  Future<void> confirmarPrediccion(int id, int idUsuario) async {
    await _client.from('prediccion_falla').update({
      'estado': 'confirmada',
      'id_usuario_revision': idUsuario,
    }).eq('id_prediccion', id);
  }

  /// Actualiza los campos especificados de un mantenimiento y retorna el registro actualizado.
  Future<Mantenimiento> actualizarMantenimiento(int id, Map<String, dynamic> cambios) async {
    final fila = await _client
        .from('mantenimiento')
        .update(cambios)
        .eq('id_mantenimiento', id)
        .select()
        .single();
    return Mantenimiento.fromMap(fila);
  }

  /// Elimina un mantenimiento de Supabase por su id.
  Future<void> eliminarMantenimiento(int id) async {
    await _client.from('mantenimiento').delete().eq('id_mantenimiento', id);
  }

  /// Vuelve una predicción de falla al estado pendiente (por ejemplo cuando se elimina el mantenimiento que la atendía).
  Future<void> reabrirPrediccion(int id) async {
    await _client.from('prediccion_falla').update({
      'estado': 'pendiente',
    }).eq('id_prediccion', id);
  }

  // ---------------------------------------------------------------- alertas (TS-04)

  String _fecha(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<PrediccionFalla> _actualizarPrediccion(int id, Map<String, dynamic> cambios) async {
    final fila = await _client
        .from('prediccion_falla')
        .update(cambios)
        .eq('id_prediccion', id)
        .select()
        .single();
    return PrediccionFalla.fromMap(fila);
  }

  /// T-11: deja la alerta programada para [fecha] y anota quién la revisó.
  Future<PrediccionFalla> programarPrediccion(int id, DateTime fecha, int idUsuario) =>
      _actualizarPrediccion(id, {
        'estado': 'programada',
        'fecha_programada': _fecha(fecha),
        'id_usuario_revision': idUsuario,
      });

  /// T-11: la alerta vuelve a quedar pendiente, sin fecha programada.
  Future<PrediccionFalla> cancelarProgramacion(int id) =>
      _actualizarPrediccion(id, {'estado': 'pendiente', 'fecha_programada': null});

  /// T-12: la alerta se marca como atendida sin programar una intervención.
  Future<PrediccionFalla> descartarPrediccion(int id, int idUsuario) =>
      _actualizarPrediccion(id, {
        'estado': 'descartada',
        'fecha_programada': null,
        'id_usuario_revision': idUsuario,
      });
}
