import 'package:flutter/material.dart';

import '../theme.dart';

/// Contenedor blanco con borde: base de casi todas las tarjetas.
class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final Color? borde;
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borde,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borde ?? Pal.borde),
      ),
      child: child,
    );
  }
}

/// Etiqueta de estado (píldora de color).
class Insignia extends StatelessWidget {
  final String texto;
  final Color fondo;
  final Color color;
  final IconData? icono;
  const Insignia(this.texto, {super.key, required this.fondo, required this.color, this.icono});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(texto, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

/// Distribuye hijos en columnas según el ancho disponible.
class Rejilla extends StatelessWidget {
  final List<Widget> children;
  final double minAncho;
  final double espacio;
  const Rejilla({super.key, required this.children, this.minAncho = 280, this.espacio = 12});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final ancho = c.maxWidth;
      var cols = ((ancho + espacio) / (minAncho + espacio)).floor();
      if (cols < 1) cols = 1;
      if (children.isNotEmpty && cols > children.length) cols = children.length;
      final cw = (ancho - (cols - 1) * espacio) / cols;
      return Wrap(
        spacing: espacio,
        runSpacing: espacio,
        children: [for (final w in children) SizedBox(width: cw, child: w)],
      );
    });
  }
}

class TituloSeccion extends StatelessWidget {
  final String texto;
  final Widget? accion;
  const TituloSeccion(this.texto, {super.key, this.accion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(texto,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Pal.texto)),
          ),
          if (accion != null) accion!,
        ],
      ),
    );
  }
}

class EncabezadoPagina extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final Widget? accion;
  const EncabezadoPagina({super.key, required this.titulo, required this.subtitulo, this.accion});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Pal.texto)),
              const SizedBox(height: 4),
              Text(subtitulo, style: const TextStyle(color: Pal.suave)),
            ],
          ),
        ),
        if (accion != null) ...[const SizedBox(width: 12), accion!],
      ],
    );
  }
}

class BarraProgreso extends StatelessWidget {
  final double valor; // 0..1
  final Color color;
  const BarraProgreso(this.valor, {super.key, this.color = Pal.azul});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: valor.clamp(0.0, 1.0).toDouble(),
      minHeight: 7,
      backgroundColor: Pal.grisBg,
      color: color,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

/// Mensaje cuando una lista no tiene elementos.
class EstadoVacio extends StatelessWidget {
  final String mensaje;
  final IconData icono;
  const EstadoVacio(this.mensaje, {super.key, this.icono = Icons.inbox_outlined});

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Row(
        children: [
          Icon(icono, color: Pal.gris),
          const SizedBox(width: 10),
          Expanded(child: Text(mensaje, style: const TextStyle(color: Pal.suave))),
        ],
      ),
    );
  }
}
