import 'package:flutter/material.dart';

import '../components/app_button.dart';
import '../components/basicos.dart';
import '../components/campos.dart';
import '../theme.dart';

/// Page de inicio de sesión: solo muestra y reporta. Los controladores, el error
/// y la visibilidad de la clave viven en LoginScreen.
class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController correo;
  final TextEditingController clave;
  final bool verClave;
  final String? error;
  final VoidCallback onAlternarClave;
  final VoidCallback onEntrar;
  const LoginPage({
    super.key,
    required this.formKey,
    required this.correo,
    required this.clave,
    required this.verClave,
    required this.error,
    required this.onAlternarClave,
    required this.onEntrar,
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
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: Pal.azul, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.local_shipping, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                              children: [
                                TextSpan(text: 'RutaViva', style: TextStyle(color: Pal.texto)),
                                TextSpan(text: 'Logística', style: TextStyle(color: Pal.azul)),
                              ],
                            ),
                          ),
                          const Text('TORRE DE CONTROL · OPERACIONES',
                              style: TextStyle(fontSize: 10.5, letterSpacing: 0.6, color: Pal.suave)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Inicia sesión',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Pal.texto)),
                  const SizedBox(height: 4),
                  const Text('Visibilidad de flota, mantenimiento predictivo y cumplimiento de entregas.',
                      style: TextStyle(color: Pal.suave)),
                  const SizedBox(height: 24),
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
                    onEnviar: (_) => onEntrar(),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(error!, style: const TextStyle(color: Pal.rojo, fontWeight: FontWeight.w600)),
                  ],
                  const SizedBox(height: 20),
                  AppButton('Ingresar a Operaciones', icono: Icons.arrow_forward, expandido: true, onPressed: onEntrar),
                  const SizedBox(height: 16),
                  const Text(
                    'Prototipo con datos simulados. Usuario de prueba: coordinador@rutaviva.com · contraseña 123456.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Pal.suave),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
