import 'package:flutter/material.dart';

import '../theme.dart';
import 'basicos.dart';

/// Indicador clave con valor grande y barra opcional.
class Kpi extends StatelessWidget {
  final String titulo;
  final String valor;
  final String detalle;
  final Color color;
  final double? progreso;
  final IconData icono;
  const Kpi({
    super.key,
    required this.titulo,
    required this.valor,
    required this.detalle,
    required this.icono,
    this.color = Pal.azul,
    this.progreso,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, size: 18, color: Pal.suave),
              const SizedBox(width: 6),
              Expanded(
                child: Text(titulo,
                    style: const TextStyle(fontSize: 13, color: Pal.suave, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(valor, style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 4),
          Text(detalle, style: const TextStyle(fontSize: 12.5, color: Pal.suave)),
          if (progreso != null) ...[
            const SizedBox(height: 10),
            BarraProgreso(progreso!, color: color),
          ],
        ],
      ),
    );
  }
}

/// Lectura de un sensor (temperatura, rpm, combustible...).
class TarjetaLectura extends StatelessWidget {
  final String titulo;
  final String valor;
  final double fraccion;
  final Color color;
  final String nota;
  const TarjetaLectura({
    super.key,
    required this.titulo,
    required this.valor,
    required this.fraccion,
    required this.color,
    required this.nota,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 12.5, color: Pal.suave, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(valor, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 8),
          BarraProgreso(fraccion, color: color),
          const SizedBox(height: 6),
          Text(nota, style: const TextStyle(fontSize: 12, color: Pal.suave)),
        ],
      ),
    );
  }
}
