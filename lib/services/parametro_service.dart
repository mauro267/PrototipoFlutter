import 'package:supabase_flutter/supabase_flutter.dart';

/// Valores configurables de la app guardados en la tabla parametro (RF-09).
class ParametroService {
  final SupabaseClient _client = Supabase.instance.client;

  static const _metaOtd = 'meta_otd';

  /// Meta de entregas a tiempo como fracción (0,95 = 95 %). 0,95 si aún no se ha guardado.
  Future<double> getMetaOtd() async {
    final fila = await _client.from('parametro').select('valor').eq('clave', _metaOtd).maybeSingle();
    if (fila == null) return 0.95;
    return (fila['valor'] as num).toDouble();
  }

  Future<void> guardarMetaOtd(double fraccion) async {
    await _client.from('parametro').upsert({'clave': _metaOtd, 'valor': fraccion});
  }
}
