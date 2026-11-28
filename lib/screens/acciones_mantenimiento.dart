import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../components/dialogs.dart';
import '../components/formulario_mantenimiento.dart';
import '../models/models.dart';
import '../services/fleet_service.dart';
import '../services/maintenance_service.dart';
import '../state/app_store.dart';
import '../utils/errores.dart';
import '../utils/format.dart';

/// Acciones de mantenimiento que comparten las pantallas anfitrionas
/// (mantenimiento y detalle de vehículo): abren diálogos y actualizan el store.
class AccionesMantenimiento {
  final AppStore store;
  final MaintenanceService _maintenanceService;
  final FleetService _fleetService;

  AccionesMantenimiento(
    this.store, {
    MaintenanceService? maintenanceService,
    FleetService? fleetService,
  })  : _maintenanceService = maintenanceService ?? MaintenanceService(),
        _fleetService = fleetService ?? FleetService();

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
      onGuardar: (b) async {
        try {
          final nuevo = Mantenimiento(
            id: 0,
            idVehiculo: b.idVehiculo,
            idPrediccion: b.idPrediccion,
            fecha: DateTime.now(),
            origen: b.origen,
            tipoFalla: b.tipoFalla,
            descripcion: b.descripcion,
            kilometraje: b.kilometraje,
            costo: b.costo,
            moneda: 'COP',
            horasFueraServicio: b.horasFuera,
            enRuta: b.origen == 'correctivo' && b.enRuta,
            idUsuarioRegistro: store.usuario.id,
          );
          final guardado = await _maintenanceService.crearMantenimiento(nuevo);
          final v = store.vehiculo(b.idVehiculo);
          final nuevoKm = math.max(v.kilometrajeActual, b.kilometraje);
          final nuevoKmPrev = b.origen == 'preventivo' ? b.kilometraje : null;
          await _fleetService.actualizarKilometraje(b.idVehiculo, nuevoKm, kmUltimoPreventivo: nuevoKmPrev);
          if (b.idPrediccion != null) {
            await _maintenanceService.confirmarPrediccion(b.idPrediccion!, store.usuario.id);
          }
          store.agregarMantenimiento(guardado);
          if (context.mounted) _aviso(context, 'Mantenimiento registrado.');
          return true;
        } catch (e) {
          if (context.mounted) _aviso(context, mensajeDeError(e));
          return false;
        }
      },
    );
  }

  void editar(BuildContext context, Mantenimiento m) {
    mostrarFormularioMantenimiento(
      context,
      vehiculos: store.vehiculos,
      alertas: store.alertas,
      inicial: m,
      onGuardar: (b) async {
        try {
          final cambios = <String, dynamic>{
            'origen': b.origen,
            'tipo_falla': b.tipoFalla,
            'descripcion': b.descripcion,
            'kilometraje': b.kilometraje,
            'costo': b.costo,
            'horas_fuera_servicio': b.horasFuera,
            'en_ruta': b.origen == 'correctivo' && b.enRuta,
          };
          final actualizado = await _maintenanceService.actualizarMantenimiento(m.id, cambios);
          store.reemplazarMantenimiento(actualizado);
          if (context.mounted) _aviso(context, 'Mantenimiento actualizado.');
          return true;
        } catch (e) {
          if (context.mounted) _aviso(context, mensajeDeError(e));
          return false;
        }
      },
    );
  }

  Future<void> eliminar(BuildContext context, Mantenimiento m) async {
    final ok = await confirmar(
      context,
      titulo: 'Eliminar mantenimiento',
      mensaje: 'Se eliminará "${m.tipoFalla}" del ${fmtFecha(m.fecha)}. Esta acción no se puede deshacer.',
    );
    if (!ok || !context.mounted) return;
    try {
      await _maintenanceService.eliminarMantenimiento(m.id);
      if (m.idPrediccion != null &&
          !store.mantenimientos.any((item) => item.id != m.id && item.idPrediccion == m.idPrediccion)) {
        await _maintenanceService.reabrirPrediccion(m.idPrediccion!);
      }
      store.quitarMantenimiento(m.id);
      if (context.mounted) _aviso(context, 'Mantenimiento eliminado.');
    } catch (e) {
      if (context.mounted) _aviso(context, mensajeDeError(e));
    }
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
    if (fecha == null || !context.mounted) return;
    try {
      final guardada = await _maintenanceService.programarPrediccion(p.id, fecha, store.usuario.id);
      store.reemplazarPrediccion(guardada);
      if (context.mounted) _aviso(context, 'Mantenimiento programado para el ${fmtFecha(fecha)}.');
    } catch (e) {
      if (context.mounted) _aviso(context, mensajeDeError(e));
    }
  }

  Future<void> cancelarProgramacion(BuildContext context, PrediccionFalla p) async {
    try {
      final guardada = await _maintenanceService.cancelarProgramacion(p.id);
      store.reemplazarPrediccion(guardada);
      if (context.mounted) _aviso(context, 'Programación cancelada.');
    } catch (e) {
      if (context.mounted) _aviso(context, mensajeDeError(e));
    }
  }

  /// T-12 (F-04 A1): marca la alerta como atendida sin programar una intervención.
  Future<void> descartar(BuildContext context, PrediccionFalla p) async {
    final ok = await confirmar(
      context,
      titulo: 'Marcar alerta como atendida',
      mensaje: 'La alerta de "${p.componente}" dejará de aparecer entre las pendientes.',
    );
    if (!ok || !context.mounted) return;
    try {
      final guardada = await _maintenanceService.descartarPrediccion(p.id, store.usuario.id);
      store.reemplazarPrediccion(guardada);
      if (context.mounted) _aviso(context, 'Alerta marcada como atendida.');
    } catch (e) {
      if (context.mounted) _aviso(context, mensajeDeError(e));
    }
  }
}
