import '../models/models.dart';
import 'simulated_data.dart';

/// Autenticación simulada contra la tabla USUARIO (Entrega 2).
/// En la Entrega 3 se reemplaza por Supabase Auth (AD-03).
class AuthService {
  static const claveDemo = '123456';

  /// Devuelve el usuario o lanza un [String] con el motivo del rechazo.
  static Usuario iniciarSesion(String correo, String clave) {
    final email = correo.trim().toLowerCase();
    for (final u in DatosSimulados.usuarios()) {
      if (u.email != email) continue;
      if (clave != claveDemo) throw 'Correo o contraseña incorrectos.';
      if (!u.activo) throw 'Este usuario está inactivo.';
      if (u.rol != 'coordinador') {
        throw 'Esta fase solo permite el rol Coordinador de Operaciones.';
      }
      return u;
    }
    throw 'Correo o contraseña incorrectos.';
  }
}
