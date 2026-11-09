import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

/// Screen anfitriona del inicio de sesión (RNF-04): guarda el estado del
/// formulario y decide a dónde navegar. La Page solo muestra y reporta.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _correo = TextEditingController(text: 'coordinador@rutaviva.com');
  final _clave = TextEditingController(text: AuthService.claveDemo);
  bool _verClave = false;
  String? _error;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_form.currentState!.validate()) return;
    try {
      final usuario = AuthService.iniciarSesion(_correo.text, _clave.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(usuario: usuario)),
      );
    } on String catch (motivo) {
      setState(() => _error = motivo);
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
        onAlternarClave: () => setState(() => _verClave = !_verClave),
        onEntrar: _entrar,
      ),
    );
  }
}
