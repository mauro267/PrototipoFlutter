import 'package:flutter/material.dart';

import '../theme.dart';
import 'app_button.dart';

/// Indicador de carga centrado, con un mensaje opcional.
class EstadoCarga extends StatelessWidget {
  final String mensaje;
  const EstadoCarga({super.key, this.mensaje = 'Cargando…'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 14),
          Text(mensaje, style: const TextStyle(color: Pal.suave)),
        ],
      ),
    );
  }
}

/// Mensaje de error con botón para reintentar y, si se pasa, una segunda acción.
class EstadoError extends StatelessWidget {
  final String mensaje;
  final Function() onReintentar;
  final String? textoSecundario;
  final Function()? onSecundario;
  const EstadoError({
    super.key,
    required this.mensaje,
    required this.onReintentar,
    this.textoSecundario,
    this.onSecundario,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 48, color: Pal.rojo),
              const SizedBox(height: 12),
              Text(mensaje, textAlign: TextAlign.center, style: const TextStyle(color: Pal.texto)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  AppButton('Reintentar', icono: Icons.refresh, onPressed: onReintentar),
                  if (textoSecundario != null && onSecundario != null)
                    AppButton(textoSecundario!, tipo: TipoBoton.texto, onPressed: onSecundario),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
