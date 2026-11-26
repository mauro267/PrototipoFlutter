import 'package:flutter/material.dart';

import '../components/app_button.dart';
import '../components/basicos.dart';
import '../components/campos.dart';
import '../theme.dart';

/// Page de crear cuenta (F-01 A3): solo muestra y reporta. Los controladores,
/// el error y si está cargando viven en RegistroScreen.
class RegistroPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nombre;
  final TextEditingController correo;
  final TextEditingController clave;
  final bool verClave;
  final bool cargando;
  final String? error;
  final Function() onAlternarClave;
  final Function() onCrear;
  final Function() onVolver;
  const RegistroPage({
    super.key,
    required this.formKey,
    required this.nombre,
    required this.correo,
    required this.clave,
    required this.verClave,
    required this.cargando,
    required this.error,
    required this.onAlternarClave,
    required this.onCrear,
    required this.onVolver,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Panel(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Crea tu cuenta',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Pal.texto)),
                  const SizedBox(height: 4),
                  const Text('Tu cuenta queda con el rol de Coordinador(a) de Operaciones.',
                      style: TextStyle(color: Pal.suave)),
                  const SizedBox(height: 24),
                  AppTextField(
                    etiqueta: 'Nombre completo',
                    controller: nombre,
                    icono: Icons.person_outline,
                    validator: (s) => (s == null || s.trim().isEmpty) ? 'Escribe tu nombre' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    etiqueta: 'Correo corporativo',
                    controller: correo,
                    teclado: TextInputType.emailAddress,
                    icono: Icons.badge_outlined,
                    validator: (s) => (s == null || !s.contains('@')) ? 'Ingresa un correo válido' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    etiqueta: 'Contraseña',
                    controller: clave,
                    oculto: !verClave,
                    icono: Icons.vpn_key_outlined,
                    sufijo: IconButton(
                      icon: Icon(verClave ? Icons.visibility_off : Icons.visibility),
                      onPressed: onAlternarClave,
                    ),
                    validator: (s) => (s == null || s.length < 6) ? 'Mínimo 6 caracteres' : null,
                    onEnviar: (_) {
                      if (!cargando) onCrear();
                    },
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(error!, style: const TextStyle(color: Pal.rojo, fontWeight: FontWeight.w600)),
                  ],
                  const SizedBox(height: 20),
                  AppButton(
                    cargando ? 'Creando la cuenta…' : 'Crear cuenta',
                    icono: cargando ? Icons.hourglass_top : Icons.person_add_alt_1,
                    expandido: true,
                    onPressed: cargando ? null : onCrear,
                  ),
                  const SizedBox(height: 12),
                  AppButton('Ya tengo cuenta', tipo: TipoBoton.texto, onPressed: cargando ? null : onVolver),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
