import 'dart:ui';

import 'package:flutter/material.dart';

import '../components/estados_carga.dart';
import '../pages/vehicle_detail_page.dart';
import '../services/fleet_service.dart';
import '../services/maintenance_service.dart';
import '../state/app_store.dart';
import '../utils/errores.dart';
import 'acciones_mantenimiento.dart';

/// Screen anfitriona del detalle de un vehículo (ruta que se abre desde el
/// panel de flota o desde mantenimiento). Al abrirse y al deslizar hacia abajo
/// pide a Supabase la telemetría, los eventos y el historial del vehículo (TS-03).
class VehicleDetailScreen extends StatefulWidget {
  final AppStore store;
  final int idVehiculo;
  const VehicleDetailScreen({super.key, required this.store, required this.idVehiculo});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  bool _cargando = true;
  String? _error;

  AppStore get _s => widget.store;

  @override
  void initState() {
    super.initState();
    _refrescar();
  }

  /// T-09 y T-10: la última lectura (solo si tiene sensores), los eventos y el historial.
  Future<void> _refrescar() async {
    setState(() => _error = null);
    final id = widget.idVehiculo;
    try {
      final flota = FleetService();
      final conTelemetria = _s.vehiculo(id).hasTelemetry;
      final gps = conTelemetria ? flota.getUltimoGps(id) : Future.value(null);
      final obd = conTelemetria ? flota.getUltimoObd(id) : Future.value(null);
      final eventos = flota.getEventosDe(id);
      final historial = MaintenanceService().getMantenimientosDe(id);
      final g = await gps;
      final o = await obd;
      final e = await eventos;
      final h = await historial;
      if (!mounted) return;
      if (conTelemetria) _s.reemplazarTelemetria(id, g, o);
      _s.reemplazarDelVehiculo(id, e, h);
      setState(() => _cargando = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = mensajeDeError(e);
      });
    }
  }

  void _reintentar() {
    setState(() => _cargando = true);
    _refrescar();
  }

  @override
  Widget build(BuildContext context) {
    final acciones = AccionesMantenimiento(_s);
    return ListenableBuilder(
      listenable: _s,
      builder: (context, _) {
        final v = _s.vehiculo(widget.idVehiculo);
        final Widget cuerpo;
        if (_cargando) {
          cuerpo = const EstadoCarga(mensaje: 'Cargando la telemetría del vehículo…');
        } else if (_error != null) {
          cuerpo = EstadoError(
            mensaje: _error!,
            onReintentar: _reintentar,
            textoSecundario: 'Volver al panel',
            onSecundario: () => Navigator.of(context).pop(),
          );
        } else {
          cuerpo = RefreshIndicator(
            onRefresh: _refrescar,
            // En web el gesto de deslizar también se hace con el mouse.
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: PointerDeviceKind.values.toSet()),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: VehicleDetailPage(
                    vehiculo: v,
                    zona: _s.zona(v.idZona),
                    conductor: _s.conductorDe(v),
                    obd: _s.obdDe(v.id),
                    gps: _s.gpsDe(v.id),
                    alertas: _s.alertasDe(v.id),
                    eventos: _s.eventosDe(v.id),
                    historial: _s.historialDe(v.id),
                    onRegistrarMantenimiento: () => acciones.registrar(context, idVehiculo: v.id),
                    onProgramar: (p) => acciones.programar(context, p),
                    onCancelarProgramacion: (p) => acciones.cancelarProgramacion(context, p),
                    onDescartar: (p) => acciones.descartar(context, p),
                    onEditar: (m) => acciones.editar(context, m),
                    onEliminar: (m) => acciones.eliminar(context, m),
                    onEvidencia: (m) => Navigator.pushNamed(context, '/evidencias', arguments: m),
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(v.placa)),
          floatingActionButton: _cargando || _error != null
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => acciones.registrar(context, idVehiculo: v.id),
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar mantenimiento'),
                ),
          body: cuerpo,
        );
      },
    );
  }
}
