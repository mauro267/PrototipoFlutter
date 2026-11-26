import 'package:flutter/material.dart';

import '../models/models.dart';
import '../pages/registro_page.dart';
import '../services/auth_service.dart';
import '../services/usuario_service.dart';
import '../utils/errores.dart';

/// Screen anfitriona de crear cuenta (F-01 A3, A4): primero la cuenta en Auth y
/// después su fila en usuario, con el uuid que devolvió Auth (AD-03).
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _authService = AuthService();
  final _usuarioService = UsuarioService();
  final _form = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  bool _verClave = false;
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  Future<void> _crear() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final uuid = await _authService.registrar(_correo.text, _clave.text);
      await _usuarioService.crearUsuario(Usuario(
        id: 0,
        authUuid: uuid,
        nombre: _nombre.text.trim(),
        email: _correo.text.trim().toLowerCase(),
        rol: 'coordinador',
        pais: 'Colombia',
      ));
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
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: RegistroPage(
        formKey: _form,
        nombre: _nombre,
        correo: _correo,
        clave: _clave,
        verClave: _verClave,
        cargando: _cargando,
        error: _error,
        onAlternarClave: () => setState(() => _verClave = !_verClave),
        onCrear: _crear,
        onVolver: () => Navigator.pop(context),
      ),
    );
  }
}
