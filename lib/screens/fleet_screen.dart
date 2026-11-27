import 'package:flutter/material.dart';

import '../components/mapa_flota.dart';
import '../pages/fleet_page.dart';
import '../state/app_store.dart';
import '../utils/estados.dart';
import 'vehicle_detail_screen.dart';

/// Screen anfitriona del panel de flota: guarda el filtro de zona y arma los
/// datos que recibe la Page.
class FleetScreen extends StatefulWidget {
  final AppStore store;
  const FleetScreen({super.key, required this.store});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  int? _idZona;

  @override
  Widget build(BuildContext context) {
    final s = widget.store;
    return ListenableBuilder(
      listenable: s,
      builder: (context, _) {
        final visibles = s.vehiculosDeZona(_idZona);
        final puntos = <PuntoMapa>[];
        for (final v in visibles) {
          if (!v.hasTelemetry) continue; // AD-04
          final g = s.gpsDe(v.id);
          if (g != null) puntos.add(PuntoMapa(v.placa, g.lat, g.lon, colorEstadoVehiculo(v.estadoOperativo)));
        }

        return FleetPage(
          zonas: s.zonas,
          idZona: _idZona,
          onZona: (id) => setState(() => _idZona = id),
          vehiculos: visibles,
          conductores: s.conductoresPorVehiculo,
          puntos: puntos,
          sinSensores: visibles.where((v) => !v.hasTelemetry).length,
          // F-02 CA-5: los indicadores se recalculan para la zona elegida.
          otd: s.otdDe(_idZona),
          meta: s.metaOtd,
          cumpleMeta: s.cumpleMetaDe(_idZona),
          tasaVaradas: s.tasaVaradasDe(_idZona),
          varadas: s.varadasDe(_idZona),
          totalViajes: s.viajesDe(_idZona),
          cobertura: s.coberturaDe(_idZona),
          conTelemetria: s.conTelemetriaDe(_idZona),
          totalVehiculos: visibles.length,
          onVehiculo: (id) => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => VehicleDetailScreen(store: s, idVehiculo: id)),
          ),
        );
      },
    );
  }
}
