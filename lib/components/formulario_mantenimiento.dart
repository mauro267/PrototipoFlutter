import 'package:flutter/material.dart';

import '../models/models.dart';
import 'app_button.dart';
import 'campos.dart';

/// Formulario para crear o editar un mantenimiento (RF-03, RF-11).
/// Si [inicial] es null se crea; si no, se edita. Reporta con [onGuardar].
Future<void> mostrarFormularioMantenimiento(
  BuildContext context, {
  required List<Vehiculo> vehiculos,
  required List<PrediccionFalla> alertas,
  int? idVehiculoInicial,
  Mantenimiento? inicial,
  required ValueChanged<MantenimientoBorrador> onGuardar,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _FormularioMantenimiento(
      vehiculos: vehiculos,
      alertas: alertas,
      idVehiculoInicial: idVehiculoInicial,
      inicial: inicial,
      onGuardar: onGuardar,
    ),
  );
}

class _FormularioMantenimiento extends StatefulWidget {
  final List<Vehiculo> vehiculos;
  final List<PrediccionFalla> alertas;
  final int? idVehiculoInicial;
  final Mantenimiento? inicial;
  final ValueChanged<MantenimientoBorrador> onGuardar;
  const _FormularioMantenimiento({
    required this.vehiculos,
    required this.alertas,
    required this.idVehiculoInicial,
    required this.inicial,
    required this.onGuardar,
  });

  @override
  State<_FormularioMantenimiento> createState() => _FormularioMantenimientoState();
}

String _txt(double v) => v == v.roundToDouble() ? v.round().toString() : v.toString();

class _FormularioMantenimientoState extends State<_FormularioMantenimiento> {
  final _form = GlobalKey<FormState>();
  late int _idVehiculo;
  late String _origen;
  late bool _enRuta;
  int? _idPrediccion;
  late final TextEditingController _tipoFalla;
  late final TextEditingController _descripcion;
  late final TextEditingController _km;
  late final TextEditingController _costo;
  late final TextEditingController _horas;

  bool get _edita => widget.inicial != null;

  Vehiculo _vehiculo(int id) => widget.vehiculos.firstWhere((v) => v.id == id);

  @override
  void initState() {
    super.initState();
    final m = widget.inicial;
    _idVehiculo = m?.idVehiculo ?? widget.idVehiculoInicial ?? widget.vehiculos.first.id;
    _origen = m?.origen ?? 'preventivo';
    _enRuta = m?.enRuta ?? false;
    _tipoFalla = TextEditingController(text: m?.tipoFalla ?? '');
    _descripcion = TextEditingController(text: m?.descripcion ?? '');
    _km = TextEditingController(text: _txt(m?.kilometraje ?? _vehiculo(_idVehiculo).kilometrajeActual));
    _costo = TextEditingController(text: m == null ? '' : _txt(m.costo));
    _horas = TextEditingController(text: m == null ? '' : _txt(m.horasFueraServicio));
  }

  @override
  void dispose() {
    _tipoFalla.dispose();
    _descripcion.dispose();
    _km.dispose();
    _costo.dispose();
    _horas.dispose();
    super.dispose();
  }

  double? _num(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

  String? _validarNumero(String? s) {
    if (s == null || s.trim().isEmpty) return 'Obligatorio';
    final n = _num(s);
    if (n == null || n < 0) return 'Número no válido';
    return null;
  }

  void _guardar() {
    if (!_form.currentState!.validate()) return;
    widget.onGuardar(MantenimientoBorrador(
      idVehiculo: _idVehiculo,
      idPrediccion: _edita ? widget.inicial!.idPrediccion : _idPrediccion,
      origen: _origen,
      tipoFalla: _tipoFalla.text.trim(),
      descripcion: _descripcion.text.trim(),
      kilometraje: _num(_km.text)!,
      costo: _num(_costo.text)!,
      horasFuera: _num(_horas.text)!,
      enRuta: _enRuta,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final alertasDelVehiculo = widget.alertas.where((p) => p.idVehiculo == _idVehiculo).toList();

    return AlertDialog(
      title: Text(_edita ? 'Editar mantenimiento' : 'Registrar mantenimiento'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                AppSelect<int>(
                  etiqueta: 'Vehículo',
                  value: _idVehiculo,
                  items: [
                    for (final v in widget.vehiculos)
                      DropdownMenuItem(
                        value: v.id,
                        child: Text('${v.placa} · ${v.nombre}', overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: _edita
                      ? (_) {}
                      : (v) {
                          if (v == null) return;
                          setState(() {
                            _idVehiculo = v;
                            _idPrediccion = null;
                            _km.text = _txt(_vehiculo(v).kilometrajeActual);
                          });
                        },
                ),
                const SizedBox(height: 12),
                AppSelect<String>(
                  etiqueta: 'Tipo de mantenimiento',
                  value: _origen,
                  items: const [
                    DropdownMenuItem(value: 'preventivo', child: Text('Preventivo')),
                    DropdownMenuItem(value: 'correctivo', child: Text('Correctivo')),
                  ],
                  onChanged: (v) => setState(() => _origen = v ?? 'preventivo'),
                ),
                if (!_edita && alertasDelVehiculo.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  AppSelect<int?>(
                    etiqueta: 'Confirma una alerta predictiva (opcional)',
                    value: _idPrediccion,
                    items: [
                      const DropdownMenuItem<int?>(value: null, child: Text('Ninguna')),
                      for (final p in alertasDelVehiculo)
                        DropdownMenuItem<int?>(value: p.id, child: Text(p.componente, overflow: TextOverflow.ellipsis)),
                    ],
                    onChanged: (v) => setState(() => _idPrediccion = v),
                  ),
                ],
                const SizedBox(height: 12),
                AppTextField(
                  etiqueta: 'Tipo de falla',
                  controller: _tipoFalla,
                  validator: (s) => (s == null || s.trim().isEmpty) ? 'Obligatorio' : null,
                ),
                const SizedBox(height: 12),
                AppTextField(etiqueta: 'Descripción (opcional)', controller: _descripcion, maxLineas: 2),
                const SizedBox(height: 12),
                AppTextField(
                    etiqueta: 'Kilometraje (km)', controller: _km, teclado: TextInputType.number, validator: _validarNumero),
                const SizedBox(height: 12),
                AppTextField(
                    etiqueta: 'Costo (COP)', controller: _costo, teclado: TextInputType.number, validator: _validarNumero),
                const SizedBox(height: 12),
                AppTextField(
                    etiqueta: 'Horas fuera de servicio',
                    controller: _horas,
                    teclado: TextInputType.number,
                    validator: _validarNumero),
                if (_origen == 'correctivo')
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('La falla ocurrió en ruta'),
                    value: _enRuta,
                    onChanged: (v) => setState(() => _enRuta = v),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        AppButton('Cancelar', tipo: TipoBoton.texto, onPressed: () => Navigator.of(context).pop()),
        AppButton(_edita ? 'Guardar cambios' : 'Guardar', onPressed: _guardar),
      ],
    );
  }
}
