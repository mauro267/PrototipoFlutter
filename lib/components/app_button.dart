import 'package:flutter/material.dart';

import '../theme.dart';

enum TipoBoton { primario, secundario, texto, peligro }

/// Único botón de la app.
class AppButton extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icono;
  final TipoBoton tipo;
  final bool expandido;
  const AppButton(
    this.texto, {
    super.key,
    required this.onPressed,
    this.icono,
    this.tipo = TipoBoton.primario,
    this.expandido = false,
  });

  @override
  Widget build(BuildContext context) {
    final etiqueta = Text(texto);
    final ico = icono == null ? null : Icon(icono, size: 18);
    Widget boton;
    switch (tipo) {
      case TipoBoton.primario:
        boton = ico == null
            ? FilledButton(onPressed: onPressed, child: etiqueta)
            : FilledButton.icon(onPressed: onPressed, icon: ico, label: etiqueta);
        break;
      case TipoBoton.peligro:
        final estilo = FilledButton.styleFrom(backgroundColor: Pal.rojo);
        boton = ico == null
            ? FilledButton(onPressed: onPressed, style: estilo, child: etiqueta)
            : FilledButton.icon(onPressed: onPressed, style: estilo, icon: ico, label: etiqueta);
        break;
      case TipoBoton.secundario:
        boton = ico == null
            ? OutlinedButton(onPressed: onPressed, child: etiqueta)
            : OutlinedButton.icon(onPressed: onPressed, icon: ico, label: etiqueta);
        break;
      case TipoBoton.texto:
        boton = ico == null
            ? TextButton(onPressed: onPressed, child: etiqueta)
            : TextButton.icon(onPressed: onPressed, icon: ico, label: etiqueta);
        break;
    }
    return expandido ? SizedBox(width: double.infinity, child: boton) : boton;
  }
}
