import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';
import '../utils/format.dart';
import 'app_button.dart';
import 'campos.dart';

/// Formulario para crear una orden de entrega (modelo canónico, RF-08).
Future<void> mostrarFormularioOrden(
  BuildContext context, {
  required List<ClienteRetailer> clientes,
  required ValueChanged<OrdenBorrador> onGuardar,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _FormularioOrden(clientes: clientes, onGuardar: onGuardar),
  );
}

class _FormularioOrden extends StatefulWidget {
  final List<ClienteRetailer> clientes;
  final ValueChanged<OrdenBorrador> onGuardar;
  const _FormularioOrden({required this.clientes, required this.onGuardar});

  @override
  State<_FormularioOrden> createState() => _FormularioOrdenState();
}

class _FormularioOrdenState extends State<_FormularioOrden> {
  final _form = GlobalKey<FormState>();
  late int _idCliente = widget.clientes.first.id;
  final _direccion = TextEditingController();
  final _ciudad = TextEditingController();
  late DateTime _fecha = _manana();

  static DateTime _manana() {
    final h = DateTime.now().add(const Duration(days: 1));
    return DateTime(h.year, h.month, h.day);
  }

  @override
  void dispose() {
    _direccion.dispose();
    _ciudad.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final f = await showDatePicker(
      context: context,
      initialDate: _fecha.isBefore(hoy) ? hoy : _fecha,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 365)),
      helpText: 'Fecha promesa de entrega',
    );
    if (f != null) setState(() => _fecha = f);
  }

  String? _obligatorio(String? s) => (s == null || s.trim().isEmpty) ? 'Obligatorio' : null;

  void _guardar() {
    if (!_form.currentState!.validate()) return;
    widget.onGuardar(OrdenBorrador(
      idCliente: _idCliente,
      direccion: _direccion.text.trim(),
      ciudad: _ciudad.text.trim(),
      fechaPromesa: DateTime(_fecha.year, _fecha.month, _fecha.day, 17),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva orden de entrega'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                AppSelect<int>(
                  etiqueta: 'Cliente retailer',
                  value: _idCliente,
                  items: [
                    for (final c in widget.clientes) DropdownMenuItem(value: c.id, child: Text(c.nombre)),
                  ],
                  onChanged: (v) => setState(() => _idCliente = v ?? _idCliente),
                ),
                const SizedBox(height: 12),
                AppTextField(etiqueta: 'Dirección de destino', controller: _direccion, validator: _obligatorio),
                const SizedBox(height: 12),
                AppTextField(etiqueta: 'Ciudad', controller: _ciudad, validator: _obligatorio),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text('Promesa: ${fmtFecha(_fecha)}, 5:00 p. m.',
                          style: const TextStyle(color: Pal.suave)),
                    ),
                    AppButton('Cambiar fecha', tipo: TipoBoton.secundario, icono: Icons.calendar_month, onPressed: _elegirFecha),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        AppButton('Cancelar', tipo: TipoBoton.texto, onPressed: () => Navigator.of(context).pop()),
        AppButton('Crear orden', onPressed: _guardar),
      ],
    );
  }
}
