import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';
import '../utils/format.dart';
import 'basicos.dart';

/// Fila del historial de mantenimiento con acciones de editar y eliminar.
/// [etiquetaVehiculo] es opcional: se omite en el detalle de un vehículo.
class FilaMantenimiento extends StatelessWidget {
  final Mantenimiento mantenimiento;
  final String? etiquetaVehiculo;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  const FilaMantenimiento({
    super.key,
    required this.mantenimiento,
    this.etiquetaVehiculo,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final m = mantenimiento;
    final preventivo = m.origen == 'preventivo';
    final titulo = etiquetaVehiculo == null ? m.tipoFalla : '$etiquetaVehiculo · ${m.tipoFalla}';

    return Panel(
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      child: Row(
        children: [
          Icon(preventivo ? Icons.event_available : Icons.build, color: preventivo ? Pal.verde : Pal.ambar),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(
                  '${fmtFecha(m.fecha)} · ${preventivo ? 'Preventivo' : 'Correctivo'}${m.enRuta ? ' · En ruta' : ''} · ${fmtKm(m.kilometraje)} · ${fmtDec(m.horasFueraServicio, 0)} h fuera de servicio',
                  style: const TextStyle(fontSize: 12.5, color: Pal.suave),
                ),
                if (m.descripcion.isNotEmpty)
                  Text(m.descripcion, style: const TextStyle(fontSize: 12.5)),
              ],
            ),
          ),
          Text(fmtCop(m.costo), style: const TextStyle(fontWeight: FontWeight.w700)),
          IconButton(tooltip: 'Editar', icon: const Icon(Icons.edit_outlined, size: 20), onPressed: onEditar),
          IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline, size: 20, color: Pal.rojo),
              onPressed: onEliminar),
        ],
      ),
    );
  }
}
