import 'package:flutter/material.dart';

import '../components/app_button.dart';
import '../components/basicos.dart';
import '../components/fila_mantenimiento.dart';
import '../components/tarjeta_alerta.dart';
import '../components/tarjeta_preventivo.dart';
import '../models/models.dart';

/// Page de mantenimiento: alertas predictivas, preventivo por km e historial
/// (RF-01, RF-02, RF-03, RF-11).
class MaintenancePage extends StatelessWidget {
  final List<PrediccionFalla> alertas;
  final List<Vehiculo> sinTelemetria;
  final List<Mantenimiento> historial;
  final Map<int, String> etiquetasVehiculo;
  final VoidCallback onRegistrar;
  final ValueChanged<int> onRegistrarPreventivo;
  final ValueChanged<int> onVerVehiculo;
  final ValueChanged<PrediccionFalla> onProgramar;
  final ValueChanged<PrediccionFalla> onCancelarProgramacion;
  final ValueChanged<Mantenimiento> onEditar;
  final ValueChanged<Mantenimiento> onEliminar;

  const MaintenancePage({
    super.key,
    required this.alertas,
    required this.sinTelemetria,
    required this.historial,
    required this.etiquetasVehiculo,
    required this.onRegistrar,
    required this.onRegistrarPreventivo,
    required this.onVerVehiculo,
    required this.onProgramar,
    required this.onCancelarProgramacion,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        EncabezadoPagina(
          titulo: 'Mantenimiento predictivo',
          subtitulo: 'Alertas de falla prevista, preventivo por kilometraje e historial.',
          accion: AppButton('Registrar', icono: Icons.add, onPressed: onRegistrar),
        ),
        const TituloSeccion('Alertas predictivas de falla'),
        if (alertas.isEmpty)
          const EstadoVacio('No hay alertas predictivas activas.')
        else
          Rejilla(
            minAncho: 320,
            children: [
              for (final a in alertas)
                TarjetaAlerta(
                  prediccion: a,
                  etiquetaVehiculo: etiquetasVehiculo[a.idVehiculo] ?? '',
                  onVerVehiculo: () => onVerVehiculo(a.idVehiculo),
                  onProgramar: () => onProgramar(a),
                  onCancelar: () => onCancelarProgramacion(a),
                ),
            ],
          ),
        const TituloSeccion('Preventivo por kilometraje (vehículos sin telemetría)'),
        if (sinTelemetria.isEmpty)
          const EstadoVacio('Todos los vehículos tienen telemetría.')
        else
          Rejilla(
            minAncho: 320,
            children: [
              for (final v in sinTelemetria)
                TarjetaPreventivo(
                  vehiculo: v,
                  onVerVehiculo: () => onVerVehiculo(v.id),
                  onRegistrar: () => onRegistrarPreventivo(v.id),
                ),
            ],
          ),
        const TituloSeccion('Historial de mantenimientos'),
        if (historial.isEmpty)
          const EstadoVacio('Aún no hay mantenimientos registrados.')
        else
          for (final m in historial)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FilaMantenimiento(
                mantenimiento: m,
                etiquetaVehiculo: etiquetasVehiculo[m.idVehiculo],
                onEditar: () => onEditar(m),
                onEliminar: () => onEliminar(m),
              ),
            ),
      ],
    );
  }
}
