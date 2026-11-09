import 'package:flutter/material.dart';

import '../components/dialogs.dart';
import '../components/formulario_orden.dart';
import '../models/models.dart';
import '../pages/orders_page.dart';
import '../state/app_store.dart';

/// Screen anfitriona de órdenes: guarda los filtros y ejecuta crear, entregar
/// y eliminar sobre el store.
class OrdersScreen extends StatefulWidget {
  final AppStore store;
  const OrdersScreen({super.key, required this.store});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int? _idCliente;
  String? _estado;

  AppStore get _s => widget.store;

  void _aviso(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  void _nueva() {
    mostrarFormularioOrden(
      context,
      clientes: _s.clientes,
      onGuardar: (b) {
        _s.agregarOrden(b);
        _aviso('Orden creada.');
      },
    );
  }

  Future<void> _eliminar(OrdenEntrega o) async {
    final ok = await confirmar(
      context,
      titulo: 'Eliminar orden',
      mensaje: 'Se eliminará la orden ${o.codigo}. Esta acción no se puede deshacer.',
    );
    if (!ok) return;
    _s.eliminarOrden(o.id);
    _aviso('Orden eliminada.');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _s,
      builder: (context, _) {
        return OrdersPage(
          ordenes: _s.ordenesFiltradas(idCliente: _idCliente, estado: _estado),
          clientes: _s.clientes,
          nombresCliente: _s.nombresCliente,
          idCliente: _idCliente,
          estado: _estado,
          onCliente: (v) => setState(() => _idCliente = v),
          onEstado: (v) => setState(() => _estado = v),
          otd: _s.otd,
          meta: _s.metaOtd,
          cumpleMeta: _s.cumpleMeta,
          conteos: {for (final e in estadosOrden) e: _s.contarOrdenes(e)},
          onEditarMeta: () => mostrarDialogoMeta(context, actual: _s.metaOtd, onGuardar: _s.cambiarMeta),
          onNuevaOrden: _nueva,
          onMarcarEntregada: (o) {
            _s.marcarEntregada(o.id);
            _aviso('Orden ${o.codigo} marcada como entregada.');
          },
          onEliminar: _eliminar,
        );
      },
    );
  }
}
