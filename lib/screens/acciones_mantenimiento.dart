import 'package:flutter/material.dart';

import '../components/dialogs.dart';
import '../components/formulario_mantenimiento.dart';
import '../models/models.dart';
import '../state/app_store.dart';
import '../utils/format.dart';

/// Acciones de mantenimiento que comparten las pantallas anfitrionas
/// (mantenimiento y detalle de vehículo): abren diálogos y actualizan el store.
class AccionesMantenimiento {
  final AppStore store;
  const AccionesMantenimiento(this.store);

  void _aviso(BuildContext context, String texto) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  void registrar(BuildContext context, {int? idVehiculo}) {
    mostrarFormularioMantenimiento(
      context,
      vehiculos: store.vehiculos,
      alertas: store.alertas,
      idVehiculoInicial: idVehiculo,
      onGuardar: (b) {
        store.agregarMantenimiento(b);
        _aviso(context, 'Mantenimiento registrado.');
      },
    );
  }

  void editar(BuildContext context, Mantenimiento m) {
    mostrarFormularioMantenimiento(
      context,
      vehiculos: store.vehiculos,
      alertas: store.alertas,
      inicial: m,
      onGuardar: (b) {
        store.editarMantenimiento(m.id, b);
        _aviso(context, 'Mantenimiento actualizado.');
      },
    );
  }

  Future<void> eliminar(BuildContext context, Mantenimiento m) async {
    final ok = await confirmar(
      context,
      titulo: 'Eliminar mantenimiento',
      mensaje: 'Se eliminará "${m.tipoFalla}" del ${fmtFecha(m.fecha)}. Esta acción no se puede deshacer.',
    );
    if (!ok) return;
    store.eliminarMantenimiento(m.id);
    _aviso(context, 'Mantenimiento eliminado.');
  }

  Future<void> programar(BuildContext context, PrediccionFalla p) async {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final l = p.fechaLimiteMantenimiento;
    final limite = DateTime(l.year, l.month, l.day);
    final fecha = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: hoy,
      lastDate: limite.isBefore(hoy) ? hoy : limite,
      helpText: 'Fecha de la intervención',
    );
    if (fecha == null) return;
    store.programarAlerta(p.id, fecha);
    _aviso(context, 'Mantenimiento programado para el ${fmtFecha(fecha)}.');
  }

  void cancelarProgramacion(BuildContext context, PrediccionFalla p) {
    store.cancelarProgramacion(p.id);
    _aviso(context, 'Programación cancelada.');
  }
}
