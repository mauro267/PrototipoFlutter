import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Archivos en Supabase Storage: fotos de evidencia en el bucket público evidencias (AD-07).
class StorageService {
  final SupabaseClient _client = Supabase.instance.client;

  static const _bucket = 'evidencias';

  /// Sube la foto con un nombre nuevo (nunca sobrescribe) y devuelve su ruta y su URL pública.
  Future<({String ruta, String url})> subirEvidencia(int idMantenimiento, Uint8List bytes) async {
    final ruta = '$idMantenimiento/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _client.storage.from(_bucket).uploadBinary(
          ruta,
          bytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );
    final url = _client.storage.from(_bucket).getPublicUrl(ruta);
    return (ruta: ruta, url: url);
  }
}
