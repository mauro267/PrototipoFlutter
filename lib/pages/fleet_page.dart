import 'package:flutter/material.dart';

import '../components/basicos.dart';
import '../components/kpi.dart';
import '../components/mapa_flota.dart';
import '../components/tarjeta_vehiculo.dart';
import '../models/models.dart';
import '../theme.dart';
import '../utils/format.dart';

/// Page del panel de flota (RF-04, RF-06, RF-07, RF-09, RF-12).
class FleetPage extends StatelessWidget {
  final List<Zona> zonas;
  final int? idZona;
  final ValueChanged<int?> onZona;
  final List<Vehiculo> vehiculos; // ya filtrados por zona
  final Map<int, String> conductores;
  final List<PuntoMapa> puntos;
  final int sinSensores;
  final double otd;
  final double meta;
  final bool cumpleMeta;
  final double tasaVaradas;
  final int varadas;
  final int totalViajes;
  final double cobertura;
  final int conTelemetria;
  final int totalVehiculos;
  final ValueChanged<int> onVehiculo;

  const FleetPage({
    super.key,
    required this.zonas,
    required this.idZona,
    required this.onZona,
    required this.vehiculos,
    required this.conductores,
    required this.puntos,
    required this.sinSensores,
    required this.otd,
    required this.meta,
    required this.cumpleMeta,
    required this.tasaVaradas,
    required this.varadas,
    required this.totalViajes,
    required this.cobertura,
    required this.conTelemetria,
    required this.totalVehiculos,
    required this.onVehiculo,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const EncabezadoPagina(
          titulo: 'Panel de flota',
          subtitulo: 'Estado de los vehículos y cumplimiento de entregas, por zona.',
        ),
        const SizedBox(height: 20),
        Rejilla(
          minAncho: 260,
          children: [
            Kpi(
              titulo: 'Entregas a tiempo (OTD)',
              valor: fmtPct(otd),
              detalle: 'Meta: ${fmtPct(meta)}',
              icono: Icons.schedule,
              color: cumpleMeta ? Pal.verde : Pal.rojo,
              progreso: otd,
            ),
            Kpi(
              titulo: 'Tasa de varadas en ruta',
              valor: fmtPct(tasaVaradas, 2),
              detalle: '${fmtEntero(varadas)} fallas no planificadas en ${fmtEntero(totalViajes)} viajes',
              icono: Icons.report_problem_outlined,
              color: tasaVaradas < 0.01 ? Pal.verde : Pal.rojo,
              progreso: tasaVaradas * 20, // escala visual: 5 % llena la barra
            ),
            Kpi(
              titulo: 'Cobertura de telemetría',
              valor: fmtPct(cobertura),
              detalle: '${fmtEntero(conTelemetria)} de ${fmtEntero(totalVehiculos)} vehículos con sensores',
              icono: Icons.sensors,
              color: Pal.azul,
              progreso: cobertura,
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _chip('Todas las zonas', null),
              for (final z in zonas) _chip(z.nombre, z.id),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final lista = _listaPorZona();
          final mapa = MapaFlota(puntos: puntos, sinSensores: sinSensores);
          if (c.maxWidth >= 900) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: lista),
                const SizedBox(width: 16),
                Expanded(flex: 4, child: mapa),
              ],
            );
          }
          return Column(children: [mapa, const SizedBox(height: 16), lista]);
        }),
      ],
    );
  }

  Widget _chip(String texto, int? id) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(texto),
        selected: idZona == id,
        onSelected: (_) => onZona(id),
      ),
    );
  }

  Widget _listaPorZona() {
    final conVehiculos = zonas.where((z) => vehiculos.any((v) => v.idZona == z.id)).toList();
    if (conVehiculos.isEmpty) return const EstadoVacio('No hay vehículos en esta zona.');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final z in conVehiculos) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text('${z.nombre} · ${z.pais}',
                style: const TextStyle(fontWeight: FontWeight.w700, color: Pal.suave)),
          ),
          for (final v in vehiculos.where((v) => v.idZona == z.id))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TarjetaVehiculo(
                vehiculo: v,
                conductor: conductores[v.id],
                onTap: () => onVehiculo(v.id),
              ),
            ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}
