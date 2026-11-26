import 'package:supabase_flutter/supabase_flutter.dart';

/// Error de la app con un mensaje listo para mostrar.
class ErrorApp implements Exception {
  final String mensaje;
  const ErrorApp(this.mensaje);

  @override
  String toString() => mensaje;
}

const _sinConexion = 'No se pudo conectar con el servidor. Revisa tu conexión e inténtalo de nuevo.';

/// Traduce cualquier error de Supabase o de red a un mensaje en español.
String mensajeDeError(Object e) {
  if (e is ErrorApp) return e.mensaje;
  if (e is AuthRetryableFetchException) return _sinConexion;
  if (e is AuthException) {
    final m = e.message.toLowerCase();
    if (m.contains('invalid login credentials')) return 'Correo o contraseña incorrectos.';
    if (m.contains('already registered') || e.code == 'user_already_exists') {
      return 'Ese correo ya tiene una cuenta.';
    }
    if (m.contains('email not confirmed')) {
      return 'El correo no está confirmado. Pide que apaguen la confirmación de correo en Supabase.';
    }
    if (m.contains('password')) return 'La contraseña no cumple los requisitos (mínimo 6 caracteres).';
    return 'No se pudo completar la autenticación: ${e.message}';
  }
  if (e is PostgrestException) {
    if (e.code == '42501') return 'La base de datos rechazó la operación (falta un permiso en la tabla).';
    return 'La base de datos no aceptó la operación: ${e.message}';
  }
  if (e is StorageException) return 'No se pudo guardar el archivo: ${e.message}';
  final texto = e.toString().toLowerCase();
  if (texto.contains('socket') || texto.contains('clientexception') || texto.contains('failed host lookup') ||
      texto.contains('xmlhttprequest') || texto.contains('network')) {
    return _sinConexion;
  }
  return 'Ocurrió un error inesperado: $e';
}
