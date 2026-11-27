import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../utils/errores.dart';

/// Llamadas a la tabla usuario: la persona de Operaciones enlazada a Auth (AD-03).
class UsuarioService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> crearUsuario(Usuario usuario) async {
    await _client.from('usuario').insert(usuario.toMap());
  }

  /// El usuario de la sesión actual. Falla si no tiene fila, está inactivo o no es coordinador.
  Future<Usuario> miUsuario() async {
    final uuid = _client.auth.currentUser?.id;
    if (uuid == null) throw const ErrorApp('No hay una sesión iniciada.');
    final fila = await _client.from('usuario').select().eq('auth_uuid', uuid).maybeSingle();
    if (fila == null) throw const ErrorApp('Tu cuenta no tiene un perfil en RutaViva. Crea la cuenta desde la app.');
    final usuario = Usuario.fromMap(fila);
    if (!usuario.activo) throw const ErrorApp('Este usuario está inactivo.');
    if (usuario.rol != 'coordinador') {
      throw const ErrorApp('Esta fase solo permite el rol Coordinador de Operaciones.');
    }
    return usuario;
  }
}
