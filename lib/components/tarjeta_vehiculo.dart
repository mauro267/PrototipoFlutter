import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';
import '../utils/estados.dart';
import '../utils/format.dart';
import 'basicos.dart';

/// Insignia de telemetría: distingue visualmente los vehículos sin sensores (RF-06).
class InsigniaTelemetria extends StatelessWidget {
  final bool tiene;
  final String textoCon;
  const InsigniaTelemetria({super.key, required this.tiene, this.textoCon = 'Telemetría'});

  @override
  Widget build(BuildContext context) {
    return tiene
        ? Insignia(textoCon, fondo: Pal.azulBg, color: Pal.azul, icono: Icons.sensors)
        : const Insignia('Sin telemetría', fondo: Pal.grisBg, color: Pal.gris, icono: Icons.sensors_off);
  }
}

/// Fila de vehículo en el panel de flota.
class TarjetaVehiculo extends StatelessWidget {
  final Vehiculo vehiculo;
  final String? conductor;
  final VoidCallback onTap;
  const TarjetaVehiculo({super.key, required this.vehiculo, this.conductor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final v = vehiculo;
    final color = colorEstadoVehiculo(v.estadoOperativo);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: v.estadoOperativo == 'varado' ? Pal.rojo : Pal.borde),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: fondoEstadoVehiculo(v.estadoOperativo),
                child: Icon(iconoVehiculo(v.tipo), color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(v.placa, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        InsigniaTelemetria(tiene: v.hasTelemetry),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(v.nombre, style: const TextStyle(color: Pal.suave, fontSize: 13)),
                    Text(conductor ?? 'Sin conductor asignado', style: const TextStyle(fontSize: 12.5)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Insignia(etiquetaEstadoVehiculo(v.estadoOperativo),
                      fondo: fondoEstadoVehiculo(v.estadoOperativo), color: color),
                  const SizedBox(height: 6),
                  Text(fmtKm(v.kilometrajeActual), style: const TextStyle(fontSize: 12, color: Pal.suave)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
