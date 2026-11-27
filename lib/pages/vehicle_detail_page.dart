import 'package:flutter/material.dart';

import '../components/basicos.dart';
import '../components/fila_mantenimiento.dart';
import '../components/kpi.dart';
import '../components/tarjeta_alerta.dart';
import '../components/tarjeta_preventivo.dart';
import '../components/tarjeta_vehiculo.dart';
import '../models/models.dart';
import '../theme.dart';
import '../utils/estados.dart';
import '../utils/format.dart';

/// Page de detalle de vehículo (RF-05, RF-06, RF-11). Con telemetría muestra
/// lecturas y alertas; sin telemetría solo el preventivo por km (AD-04).
class VehicleDetailPage extends StatelessWidget {
  final Vehiculo vehiculo;
  final Zona zona;
  final Conductor? conductor;
  final TelemetriaObd? obd;
  final TelemetriaGps? gps;
  final List<PrediccionFalla> alertas;
  final List<EventoConduccion> eventos;
  final List<Mantenimiento> historial;
  final VoidCallback onRegistrarMantenimiento;
  final ValueChanged<PrediccionFalla> onProgramar;
  final ValueChanged<PrediccionFalla> onCancelarProgramacion;
  final ValueChanged<Mantenimiento> onEditar;
  final ValueChanged<Mantenimiento> onEliminar;
  final Function(Mantenimiento)? onEvidencia;

  const VehicleDetailPage({
    super.key,
    required this.vehiculo,
    required this.zona,
    required this.conductor,
    required this.obd,
    required this.gps,
    required this.alertas,
    required this.eventos,
    required this.historial,
    required this.onRegistrarMantenimiento,
    required this.onProgramar,
    required this.onCancelarProgramacion,
    required this.onEditar,
    required this.onEliminar,
    this.onEvidencia,
  });

  @override
  Widget build(BuildContext context) {
    final v = vehiculo;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
      children: [
        _encabezado(),
        if (v.hasTelemetry) ..._telemetria() else ..._sinTelemetria(),
        const TituloSeccion('Conductor asignado'),
        _conductor(),
        const TituloSeccion('Eventos de conducción'),
        if (eventos.isEmpty)
          const EstadoVacio('Sin eventos de conducción registrados.')
        else
          for (final e in eventos) Padding(padding: const EdgeInsets.only(bottom: 8), child: _evento(e)),
        const TituloSeccion('Historial de mantenimiento'),
        if (historial.isEmpty)
          const EstadoVacio('Sin mantenimientos registrados.')
        else
          for (final m in historial)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FilaMantenimiento(
                mantenimiento: m,
                onEditar: () => onEditar(m),
                onEliminar: () => onEliminar(m),
                onEvidencia: onEvidencia == null ? null : () => onEvidencia!(m),
              ),
            ),
      ],
    );
  }

  Widget _encabezado() {
    final v = vehiculo;
    final color = colorEstadoVehiculo(v.estadoOperativo);
    return Panel(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: fondoEstadoVehiculo(v.estadoOperativo),
            child: Icon(iconoVehiculo(v.tipo), color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v.nombre, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('${v.placa} · ${zona.nombre} · Odómetro ${fmtKm(v.kilometrajeActual)}',
                    style: const TextStyle(color: Pal.suave)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Insignia(etiquetaEstadoVehiculo(v.estadoOperativo),
                        fondo: fondoEstadoVehiculo(v.estadoOperativo), color: color),
                    InsigniaTelemetria(tiene: v.hasTelemetry, textoCon: 'Con telemetría'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _telemetria() {
    final o = obd;
    final g = gps;
    return [
      const TituloSeccion('Telemetría reciente'),
      if (o == null || g == null)
        const EstadoVacio('No hay telemetría reciente para este vehículo.')
      else ...[
        Rejilla(
          minAncho: 220,
          children: [
            TarjetaLectura(
              titulo: 'Temperatura del motor',
              valor: '${fmtDec(o.tempMotor, 0)} °C',
              fraccion: o.tempMotor / 130,
              color: o.tempMotor > 105 ? Pal.rojo : (o.tempMotor > 95 ? Pal.ambar : Pal.verde),
              nota: o.tempMotor > 105 ? 'Sobrecalentamiento' : 'Rango normal',
            ),
            TarjetaLectura(
              titulo: 'Revoluciones',
              valor: '${fmtEntero(o.rpm)} rpm',
              fraccion: o.rpm / 6500,
              color: Pal.azul,
              nota: 'Lectura OBD-II',
            ),
            TarjetaLectura(
              titulo: 'Combustible',
              valor: '${fmtDec(o.nivelCombustible, 0)} %',
              fraccion: o.nivelCombustible / 100,
              color: o.nivelCombustible < 25 ? Pal.rojo : Pal.azul,
              nota: o.nivelCombustible < 25 ? 'Nivel bajo' : 'Nivel adecuado',
            ),
            TarjetaLectura(
              titulo: 'Velocidad (GPS)',
              valor: '${fmtDec(g.velocidad, 0)} km/h',
              fraccion: g.velocidad / 120,
              color: Pal.azul,
              nota: 'Lat ${fmtDec(g.lat, 4)} · Lon ${fmtDec(g.lon, 4)}',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Panel(
          child: Row(
            children: [
              Icon(
                o.codigoFalla == null ? Icons.check_circle_outline : Icons.error_outline,
                color: o.codigoFalla == null ? Pal.verde : Pal.rojo,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  o.codigoFalla == null
                      ? 'Sin códigos de falla activos.'
                      : 'Código de falla activo: ${o.codigoFalla}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text('Última lectura: ${fmtFechaHora(o.fechaHora)}',
                  style: const TextStyle(fontSize: 12, color: Pal.suave)),
            ],
          ),
        ),
      ],
      const TituloSeccion('Alertas predictivas'),
      if (alertas.isEmpty)
        const EstadoVacio('Sin alertas predictivas para este vehículo.')
      else
        Rejilla(
          minAncho: 320,
          children: [
            for (final a in alertas)
              TarjetaAlerta(
                prediccion: a,
                onProgramar: () => onProgramar(a),
                onCancelar: () => onCancelarProgramacion(a),
              ),
          ],
        ),
    ];
  }

  List<Widget> _sinTelemetria() {
    return [
      const SizedBox(height: 16),
      const Panel(
        color: Pal.grisBg,
        child: Row(
          children: [
            Icon(Icons.sensors_off, color: Pal.gris),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Este vehículo no tiene telemetría instalada. No se muestran lecturas en tiempo real ni alertas predictivas; se gestiona con mantenimiento preventivo por kilometraje.',
              ),
            ),
          ],
        ),
      ),
      const TituloSeccion('Mantenimiento preventivo por kilometraje'),
      TarjetaPreventivo(
        vehiculo: vehiculo,
        mostrarVehiculo: false,
        onRegistrar: onRegistrarMantenimiento,
      ),
    ];
  }

  Widget _conductor() {
    final c = conductor;
    return Panel(
      child: c == null
          ? const Text('Sin conductor asignado.')
          : Row(
              children: [
                const CircleAvatar(backgroundColor: Pal.azulBg, child: Icon(Icons.person, color: Pal.azul)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('Licencia ${c.licencia} · ${c.telefono}',
                          style: const TextStyle(fontSize: 12.5, color: Pal.suave)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _evento(EventoConduccion e) {
    return Panel(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.speed, color: Pal.ambar),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.tipo, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('${e.ubicacion} · ${fmtFechaHora(e.fechaHora)}',
                    style: const TextStyle(fontSize: 12.5, color: Pal.suave)),
              ],
            ),
          ),
          Text('${fmtDec(e.magnitud, e.unidad == 'g' ? 2 : 0)} ${e.unidad}',
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
