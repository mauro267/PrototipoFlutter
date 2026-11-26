import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

/// Filas de evidencia_mantenimiento: la ruta y la URL de cada foto (RF-13).
class EvidenciaService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Las fotos de un mantenimiento, de la más reciente a la más antigua.
  Future<List<Evidencia>> getEvidencias(int idMantenimiento) async {
    final filas = await _client
        .from('evidencia_mantenimiento')
        .select()
        .eq('id_mantenimiento', idMantenimiento)
        .order('fecha_subida', ascending: false);
    return filas.map(Evidencia.fromMap).toList();
  }

  Future<Evidencia> crearEvidencia({
    required int idMantenimiento,
    required String ruta,
    required String url,
  }) async {
    final fila = await _client
        .from('evidencia_mantenimiento')
        .insert({
          'id_mantenimiento': idMantenimiento,
          'ruta': ruta,
          'url': url,
          'auth_uuid_subida': _client.auth.currentUser?.id,
        })
        .select()
        .single();
    return Evidencia.fromMap(fila);
  }
}
