import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';
import '../utils/format.dart';
import 'app_button.dart';
import 'basicos.dart';
import 'tarjeta_vehiculo.dart';

/// Seguimiento del preventivo por kilometraje (RF-11).
/// Con [mostrarVehiculo] = false omite el encabezado (detalle del vehículo).
class TarjetaPreventivo extends StatelessWidget {
  final Vehiculo vehiculo;
  final bool mostrarVehiculo;
  final VoidCallback? onVerVehiculo;
  final VoidCallback onRegistrar;
  const TarjetaPreventivo({
    super.key,
    required this.vehiculo,
    this.mostrarVehiculo = true,
    this.onVerVehiculo,
    required this.onRegistrar,
  });

  @override
  Widget build(BuildContext context) {
    final v = vehiculo;
    final restante = v.kmParaPreventivo;
    final vencido = restante < 0;
    final cerca = !vencido && restante <= v.intervaloPreventivoKm * 0.15;
    final color = vencido ? Pal.rojo : (cerca ? Pal.ambar : Pal.verde);

    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mostrarVehiculo) ...[
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onVerVehiculo,
                    child: Text('${v.placa} · ${v.nombre}',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Pal.azul)),
                  ),
                ),
                const InsigniaTelemetria(tiene: false),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(
                child: Text(
                  vencido ? 'Vencido por ${fmtKm(-restante)}' : 'Faltan ${fmtKm(restante)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color),
                ),
              ),
              Insignia(
                vencido ? 'Vencido' : (cerca ? 'Próximo' : 'Al día'),
                fondo: vencido ? Pal.rojoBg : (cerca ? Pal.ambarBg : Pal.verdeBg),
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 8),
          BarraProgreso(v.kmDesdePreventivo / v.intervaloPreventivoKm, color: color),
          const SizedBox(height: 8),
          Text(
            'Odómetro ${fmtKm(v.kilometrajeActual)} · último preventivo ${fmtKm(v.kmUltimoPreventivo)} · cada ${fmtKm(v.intervaloPreventivoKm)}',
            style: const TextStyle(fontSize: 12.5, color: Pal.suave),
          ),
          const SizedBox(height: 8),
          AppButton('Registrar preventivo', tipo: TipoBoton.secundario, icono: Icons.build, onPressed: onRegistrar),
        ],
      ),
    );
  }
}
