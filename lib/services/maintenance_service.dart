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
}
