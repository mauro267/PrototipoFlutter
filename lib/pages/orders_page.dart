import 'package:flutter/material.dart';

import '../components/app_button.dart';
import '../components/basicos.dart';
import '../components/campos.dart';
import '../components/fila_orden.dart';
import '../models/models.dart';
import '../theme.dart';
import '../utils/estados.dart';
import '../utils/format.dart';

const estadosOrden = ['a_tiempo', 'en_camino', 'en_riesgo', 'retrasada', 'pendiente'];

/// Page de órdenes y entregas (RF-08, RF-09, RF-10).
class OrdersPage extends StatelessWidget {
  final List<OrdenEntrega> ordenes; // ya filtradas
  final List<ClienteRetailer> clientes;
  final Map<int, String> nombresCliente;
  final int? idCliente;
  final String? estado;
  final ValueChanged<int?> onCliente;
  final ValueChanged<String?> onEstado;
  final double otd;
  final double meta;
  final bool cumpleMeta;
  final Map<String, int> conteos;
  final VoidCallback onEditarMeta;
  final VoidCallback onNuevaOrden;
  final ValueChanged<OrdenEntrega> onMarcarEntregada;
  final ValueChanged<OrdenEntrega> onEliminar;

  const OrdersPage({
    super.key,
    required this.ordenes,
    required this.clientes,
    required this.nombresCliente,
    required this.idCliente,
    required this.estado,
    required this.onCliente,
    required this.onEstado,
    required this.otd,
    required this.meta,
    required this.cumpleMeta,
    required this.conteos,
    required this.onEditarMeta,
    required this.onNuevaOrden,
    required this.onMarcarEntregada,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final color = cumpleMeta ? Pal.verde : Pal.rojo;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        EncabezadoPagina(
          titulo: 'Órdenes y entregas',
          subtitulo: 'Cumplimiento consolidado de los cinco retailers sobre un modelo común de orden.',
          accion: AppButton('Nueva', icono: Icons.add, onPressed: onNuevaOrden),
        ),
        const SizedBox(height: 20),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(fmtPct(otd), style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: color)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        cumpleMeta
                            ? 'Cumple la meta de ${fmtPct(meta)}'
                            : 'Por debajo de la meta de ${fmtPct(meta)}',
                        style: const TextStyle(color: Pal.suave),
                      ),
                    ),
                  ),
                  AppButton('Meta', tipo: TipoBoton.texto, icono: Icons.edit_outlined, onPressed: onEditarMeta),
                ],
              ),
              const SizedBox(height: 8),
              BarraProgreso(otd, color: color),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  for (final e in estadosOrden)
                    Insignia('${etiquetaEstadoOrden(e)}: ${fmtEntero(conteos[e] ?? 0)}',
                        fondo: fondoEstadoOrden(e), color: colorEstadoOrden(e)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Rejilla(
          minAncho: 240,
          children: [
            AppSelect<int?>(
              etiqueta: 'Cliente retailer',
              value: idCliente,
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('Todos los clientes')),
                for (final c in clientes) DropdownMenuItem<int?>(value: c.id, child: Text(c.nombre)),
              ],
              onChanged: onCliente,
            ),
            AppSelect<String?>(
              etiqueta: 'Estado',
              value: estado,
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('Todos los estados')),
                for (final e in estadosOrden)
                  DropdownMenuItem<String?>(value: e, child: Text(etiquetaEstadoOrden(e))),
              ],
              onChanged: onEstado,
            ),
          ],
        ),
        TituloSeccion('Órdenes (${fmtEntero(ordenes.length)})'),
        if (ordenes.isEmpty)
          const EstadoVacio('No hay órdenes con esos filtros.')
        else
          for (final o in ordenes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FilaOrden(
                orden: o,
                nombreCliente: nombresCliente[o.idCliente] ?? '?',
                onMarcarEntregada: () => onMarcarEntregada(o),
                onEliminar: () => onEliminar(o),
              ),
            ),
      ],
    );
  }
}
