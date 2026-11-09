import 'package:flutter/material.dart';

import '../pages/maintenance_page.dart';
import '../state/app_store.dart';
import 'acciones_mantenimiento.dart';
import 'vehicle_detail_screen.dart';

/// Screen anfitriona de mantenimiento: conecta la Page con el store.
class MaintenanceScreen extends StatelessWidget {
  final AppStore store;
  const MaintenanceScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final acciones = AccionesMantenimiento(store);
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return MaintenancePage(
          alertas: store.alertas,
          sinTelemetria: store.sinTelemetria,
          historial: store.historial,
          etiquetasVehiculo: store.etiquetasVehiculo,
          onRegistrar: () => acciones.registrar(context),
          onRegistrarPreventivo: (id) => acciones.registrar(context, idVehiculo: id),
          onVerVehiculo: (id) => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => VehicleDetailScreen(store: store, idVehiculo: id)),
          ),
          onProgramar: (p) => acciones.programar(context, p),
          onCancelarProgramacion: (p) => acciones.cancelarProgramacion(context, p),
          onEditar: (m) => acciones.editar(context, m),
          onEliminar: (m) => acciones.eliminar(context, m),
        );
      },
    );
  }
}
