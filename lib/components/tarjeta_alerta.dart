import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';
import '../utils/estados.dart';
import '../utils/format.dart';
import 'app_button.dart';
import 'basicos.dart';

/// Alerta predictiva de falla (RF-01) con acción para programar (RF-02).
/// Si [etiquetaVehiculo] es null no se muestra el encabezado del vehículo
/// (por ejemplo, cuando ya se está en el detalle de ese vehículo).
class TarjetaAlerta extends StatelessWidget {
  final PrediccionFalla prediccion;
  final String? etiquetaVehiculo;
  final VoidCallback? onVerVehiculo;
  final VoidCallback onProgramar;
  final VoidCallback onCancelar;
  const TarjetaAlerta({
    super.key,
    required this.prediccion,
    this.etiquetaVehiculo,
    this.onVerVehiculo,
    required this.onProgramar,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final p = prediccion;
    final color = colorProbabilidad(p.probabilidad);
    final programada = p.estado == 'programada';

    return Panel(
      borde: p.probabilidad >= 0.8 && !programada ? Pal.rojo : Pal.borde,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: etiquetaVehiculo == null
                    ? const SizedBox.shrink()
                    : InkWell(
                        onTap: onVerVehiculo,
                        child: Text(etiquetaVehiculo!,
                            style: const TextStyle(fontWeight: FontWeight.w700, color: Pal.azul)),
                      ),
              ),
              Insignia(programada ? 'Programada' : 'Pendiente',
                  fondo: programada ? Pal.verdeBg : Pal.ambarBg,
                  color: programada ? Pal.verde : Pal.ambar),
            ],
          ),
          const SizedBox(height: 10),
          Text(p.componente, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(fmtPct(p.probabilidad, 0),
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
              const SizedBox(width: 8),
              const Text('probabilidad de falla', style: TextStyle(color: Pal.suave, fontSize: 12.5)),
            ],
          ),
          const SizedBox(height: 6),
          BarraProgreso(p.probabilidad, color: color),
          const SizedBox(height: 10),
          Text('Fecha límite recomendada: ${fmtFecha(p.fechaLimiteMantenimiento)}',
              style: const TextStyle(fontSize: 12.5, color: Pal.suave)),
          const SizedBox(height: 10),
          if (programada && p.fechaProgramada != null)
            Row(
              children: [
                const Icon(Icons.event_available, size: 18, color: Pal.verde),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('Programada para el ${fmtFecha(p.fechaProgramada!)}',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Pal.verde)),
                ),
                AppButton('Cancelar', tipo: TipoBoton.texto, onPressed: onCancelar),
              ],
            )
          else
            AppButton('Programar mantenimiento', icono: Icons.calendar_month, onPressed: onProgramar),
        ],
      ),
    );
  }
}
