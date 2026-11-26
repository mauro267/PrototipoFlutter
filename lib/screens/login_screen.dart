import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../services/auth_service.dart';
import '../services/usuario_service.dart';
import '../utils/errores.dart';

/// Screen anfitriona del inicio de sesión (F-01): guarda el formulario, si está
/// cargando y el error, y llama a Supabase Auth. La Page solo muestra y reporta.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _usuarioService = UsuarioService();
  final _form = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  bool _verClave = false;
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      await _authService.iniciarSesion(_correo.text, _clave.text);
      try {
        await _usuarioService.miUsuario();
      } catch (_) {
        await _authService.cerrarSesion();
        rethrow;
      }
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = mensajeDeError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage(
        formKey: _form,
        correo: _correo,
        clave: _clave,
        verClave: _verClave,
        error: _error,
        cargando: _cargando,
        onAlternarClave: () => setState(() => _verClave = !_verClave),
        onEntrar: _entrar,
        onCrearCuenta: () => Navigator.pushNamed(context, '/registro'),
      ),
    );
  }
}
