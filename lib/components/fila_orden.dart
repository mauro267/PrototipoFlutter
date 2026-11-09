import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';
import '../utils/estados.dart';
import '../utils/format.dart';
import 'basicos.dart';

/// Fila de orden de entrega con menú de acciones.
class FilaOrden extends StatelessWidget {
  final OrdenEntrega orden;
  final String nombreCliente;
  final VoidCallback onMarcarEntregada;
  final VoidCallback onEliminar;
  const FilaOrden({
    super.key,
    required this.orden,
    required this.nombreCliente,
    required this.onMarcarEntregada,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final o = orden;
    final entregada = o.fechaEntregaReal != null;

    return Panel(
      padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: fondoEstadoOrden(o.estado),
            child: Text(nombreCliente.substring(0, 1),
                style: TextStyle(fontWeight: FontWeight.w800, color: colorEstadoOrden(o.estado))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('#${o.codigo} · $nombreCliente', style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('${o.direccionDestino}, ${o.ciudad}',
                    style: const TextStyle(fontSize: 12.5, color: Pal.suave)),
                const SizedBox(height: 2),
                Text(
                  'Promesa: ${fmtFechaHora(o.fechaPromesa)}'
                  '${entregada ? ' · Entrega: ${fmtFechaHora(o.fechaEntregaReal!)}' : ''}',
                  style: const TextStyle(fontSize: 12, color: Pal.suave),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Insignia(etiquetaEstadoOrden(o.estado),
              fondo: fondoEstadoOrden(o.estado), color: colorEstadoOrden(o.estado)),
          PopupMenuButton<String>(
            tooltip: 'Acciones',
            onSelected: (accion) {
              if (accion == 'entregar') onMarcarEntregada();
              if (accion == 'eliminar') onEliminar();
            },
            itemBuilder: (_) => [
              if (!entregada)
                const PopupMenuItem<String>(value: 'entregar', child: Text('Marcar como entregada')),
              const PopupMenuItem<String>(value: 'eliminar', child: Text('Eliminar')),
            ],
          ),
        ],
      ),
    );
  }
}
