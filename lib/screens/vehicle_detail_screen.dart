import 'package:flutter/material.dart';

import '../pages/vehicle_detail_page.dart';
import '../state/app_store.dart';
import 'acciones_mantenimiento.dart';

/// Screen anfitriona del detalle de un vehículo (ruta que se abre desde el
/// panel de flota o desde mantenimiento).
class VehicleDetailScreen extends StatelessWidget {
  final AppStore store;
  final int idVehiculo;
  const VehicleDetailScreen({super.key, required this.store, required this.idVehiculo});

  @override
  Widget build(BuildContext context) {
    final acciones = AccionesMantenimiento(store);
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final v = store.vehiculo(idVehiculo);
        return Scaffold(
          appBar: AppBar(title: Text(v.placa)),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => acciones.registrar(context, idVehiculo: v.id),
            icon: const Icon(Icons.add),
            label: const Text('Registrar mantenimiento'),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: VehicleDetailPage(
                vehiculo: v,
                zona: store.zona(v.idZona),
                conductor: store.conductorDe(v),
                obd: store.obdDe(v.id),
                gps: store.gpsDe(v.id),
                alertas: store.alertasDe(v.id),
                eventos: store.eventosDe(v.id),
                historial: store.historialDe(v.id),
                onRegistrarMantenimiento: () => acciones.registrar(context, idVehiculo: v.id),
                onProgramar: (p) => acciones.programar(context, p),
                onCancelarProgramacion: (p) => acciones.cancelarProgramacion(context, p),
                onEditar: (m) => acciones.editar(context, m),
                onEliminar: (m) => acciones.eliminar(context, m),
                onEvidencia: (m) => Navigator.pushNamed(context, '/evidencias', arguments: m),
              ),
            ),
          ),
        );
      },
    );
  }
}
