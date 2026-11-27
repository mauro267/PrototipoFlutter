import 'package:supabase_flutter/supabase_flutter.dart';

/// Llamadas a Supabase Auth: crear cuenta, entrar, salir y sesión (F-01).
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Crea la cuenta y devuelve el uuid que le dio Auth.
  Future<String> registrar(String correo, String clave) async {
    final r = await _client.auth.signUp(email: correo.trim().toLowerCase(), password: clave);
    return r.user!.id;
  }

  Future<void> iniciarSesion(String correo, String clave) async {
    await _client.auth.signInWithPassword(email: correo.trim().toLowerCase(), password: clave);
  }

  Future<void> cerrarSesion() async {
    await _client.auth.signOut();
  }

  /// Lee la sesión guardada en el dispositivo, sin ir a internet.
  bool haySesion() => _client.auth.currentSession != null;
}
