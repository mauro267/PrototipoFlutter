import 'package:flutter/material.dart';

import '../pages/maintenance_page.dart';
import '../services/maintenance_service.dart';
import '../state/app_store.dart';
import '../utils/errores.dart';
import 'acciones_mantenimiento.dart';
import 'vehicle_detail_screen.dart';

/// Screen anfitriona de mantenimiento: conecta la Page con el store y permite
/// recargar las alertas desde Supabase deslizando hacia abajo (TS-04 T-13).
class MaintenanceScreen extends StatefulWidget {
  final AppStore store;
  const MaintenanceScreen({super.key, required this.store});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final _maintenanceService = MaintenanceService();

  AppStore get _s => widget.store;

  /// F-04 CA-4: si la recarga falla, avisa con la opción de reintentar.
  Future<void> _recargarAlertas() async {
    try {
      final predicciones = await _maintenanceService.getPredicciones();
      if (!mounted) return;
      _s.reemplazarPredicciones(predicciones);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mensajeDeError(e)),
        action: SnackBarAction(label: 'Reintentar', onPressed: _recargarAlertas),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final acciones = AccionesMantenimiento(_s);
    return ListenableBuilder(
      listenable: _s,
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: _recargarAlertas,
          child: MaintenancePage(
            alertas: _s.alertas,
            sinTelemetria: _s.sinTelemetria,
            historial: _s.historial,
            etiquetasVehiculo: _s.etiquetasVehiculo,
            onRegistrar: () => acciones.registrar(context),
            onRegistrarPreventivo: (id) => acciones.registrar(context, idVehiculo: id),
            onVerVehiculo: (id) => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => VehicleDetailScreen(store: _s, idVehiculo: id)),
            ),
            onProgramar: (p) => acciones.programar(context, p),
            onCancelarProgramacion: (p) => acciones.cancelarProgramacion(context, p),
            onDescartar: (p) => acciones.descartar(context, p),
            onRecargarAlertas: _recargarAlertas,
            onEditar: (m) => acciones.editar(context, m),
            onEliminar: (m) => acciones.eliminar(context, m),
            onEvidencia: (m) => Navigator.pushNamed(context, '/evidencias', arguments: m),
          ),
        );
      },
    );
  }
}
