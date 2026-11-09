import 'package:flutter/material.dart';

import '../theme.dart';
import 'basicos.dart';

class PuntoMapa {
  final String placa;
  final double lat;
  final double lon;
  final Color color;
  const PuntoMapa(this.placa, this.lat, this.lon, this.color);
}

/// Mapa esquemático con la última posición GPS (solo vehículos con telemetría, AD-04).
class MapaFlota extends StatelessWidget {
  final List<PuntoMapa> puntos;
  final int sinSensores;
  const MapaFlota({super.key, required this.puntos, required this.sinSensores});

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ubicación de la flota', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 2),
          const Text('Mapa esquemático con la última posición GPS reportada.',
              style: TextStyle(color: Pal.suave, fontSize: 12.5)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 300,
              width: double.infinity,
              child: CustomPaint(painter: _MapaPainter(puntos)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            sinSensores == 0
                ? 'Todos los vehículos visibles reportan posición.'
                : '$sinSensores vehículo(s) sin telemetría no aparecen en el mapa.',
            style: const TextStyle(fontSize: 12, color: Pal.suave),
          ),
        ],
      ),
    );
  }
}

class _MapaPainter extends CustomPainter {
  final List<PuntoMapa> puntos;
  _MapaPainter(this.puntos);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFEAF0FA));

    final rejilla = Paint()
      ..color = const Color(0xFFD5DEEF)
      ..strokeWidth = 1;
    for (var i = 1; i < 6; i++) {
      final dx = size.width * i / 6;
      final dy = size.height * i / 6;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), rejilla);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), rejilla);
    }
    if (puntos.isEmpty) return;

    var minLat = puntos.first.lat, maxLat = puntos.first.lat;
    var minLon = puntos.first.lon, maxLon = puntos.first.lon;
    for (final p in puntos) {
      if (p.lat < minLat) minLat = p.lat;
      if (p.lat > maxLat) maxLat = p.lat;
      if (p.lon < minLon) minLon = p.lon;
      if (p.lon > maxLon) maxLon = p.lon;
    }
    final rangoLat = (maxLat - minLat) < 0.05 ? 0.05 : (maxLat - minLat);
    final rangoLon = (maxLon - minLon) < 0.05 ? 0.05 : (maxLon - minLon);
    const margen = 34.0;

    for (final p in puntos) {
      final x = margen + (p.lon - minLon) / rangoLon * (size.width - 2 * margen);
      final y = margen + (maxLat - p.lat) / rangoLat * (size.height - 2 * margen);
      canvas.drawCircle(Offset(x, y), 9, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(x, y), 6.5, Paint()..color = p.color);
      final tp = TextPainter(
        text: TextSpan(
          text: p.placa,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Pal.texto),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y + 11));
    }
  }

  @override
  bool shouldRepaint(covariant _MapaPainter oldDelegate) => true;
}
