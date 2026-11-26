import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Acceso a la galería del dispositivo para elegir una foto.
class FotoService {
  final ImagePicker _picker = ImagePicker();

  /// Los bytes de la foto elegida, o null si la persona cancela.
  Future<Uint8List?> elegirDeGaleria() async {
    final archivo = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
    if (archivo == null) return null;
    return archivo.readAsBytes();
  }
}
