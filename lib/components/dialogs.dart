import 'package:flutter/material.dart';

import '../utils/format.dart';
import 'app_button.dart';
import 'campos.dart';

/// Confirmación para acciones destructivas. Devuelve true si el usuario acepta.
Future<bool> confirmar(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String textoConfirmar = 'Eliminar',
}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        AppButton('Cancelar', tipo: TipoBoton.texto, onPressed: () => Navigator.of(ctx).pop(false)),
        AppButton(textoConfirmar, tipo: TipoBoton.peligro, onPressed: () => Navigator.of(ctx).pop(true)),
      ],
    ),
  );
  return r ?? false;
}

/// Edita la meta de OTD (RF-09). Reporta la nueva meta como fracción (0..1).
Future<void> mostrarDialogoMeta(
  BuildContext context, {
  required double actual,
  required ValueChanged<double> onGuardar,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _MetaDialog(actual: actual, onGuardar: onGuardar),
  );
}

class _MetaDialog extends StatefulWidget {
  final double actual;
  final ValueChanged<double> onGuardar;
  const _MetaDialog({required this.actual, required this.onGuardar});

  @override
  State<_MetaDialog> createState() => _MetaDialogState();
}

class _MetaDialogState extends State<_MetaDialog> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _ctrl =
      TextEditingController(text: fmtDec(widget.actual * 100, 1));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double? _leer(String? s) => double.tryParse((s ?? '').trim().replaceAll(',', '.'));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Meta de entregas a tiempo'),
      content: Form(
        key: _form,
        child: AppTextField(
          etiqueta: 'Meta (%)',
          controller: _ctrl,
          teclado: TextInputType.number,
          validator: (s) {
            final n = _leer(s);
            if (n == null || n < 0 || n > 100) return 'Ingresa un valor entre 0 y 100';
            return null;
          },
        ),
      ),
      actions: [
        AppButton('Cancelar', tipo: TipoBoton.texto, onPressed: () => Navigator.of(context).pop()),
        AppButton('Guardar', onPressed: () {
          if (!_form.currentState!.validate()) return;
          widget.onGuardar(_leer(_ctrl.text)! / 100);
          Navigator.of(context).pop();
        }),
      ],
    );
  }
}
