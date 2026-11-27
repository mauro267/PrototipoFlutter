import 'dart:ui';

import 'package:flutter/material.dart';

import '../components/dialogs.dart';
import '../components/estados_carga.dart';
import '../components/formulario_orden.dart';
import '../models/models.dart';
import '../pages/orders_page.dart';
import '../services/order_service.dart';
import '../services/parametro_service.dart';
import '../state/app_store.dart';
import '../utils/errores.dart';

/// Screen anfitriona de órdenes: guarda los filtros y ejecuta crear, entregar,
/// eliminar y recargar contra Supabase (TS-06); el store cambia solo si salió bien.
class OrdersScreen extends StatefulWidget {
  final AppStore store;
  const OrdersScreen({super.key, required this.store});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int? _idCliente;
  String? _estado;
  String? _error;
  final _servicio = OrderService();

  AppStore get _s => widget.store;

  void _aviso(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  /// T-17: la orden se guarda en Supabase y solo después aparece en el listado.
  void _nueva() {
    mostrarFormularioOrden(
      context,
      clientes: _s.clientes,
      onGuardar: (b) async {
        try {
          final guardada = await _servicio.crearOrden(b);
          _s.agregarOrden(guardada);
          _aviso('Orden ${guardada.codigo} creada.');
          return true;
        } catch (e) {
          _aviso(mensajeDeError(e));
          return false;
        }
      },
    );
  }

  /// F-02 A2: la meta se guarda en Supabase y solo después cambia en el store.
  Future<void> _guardarMeta(double fraccion) async {
    try {
      await ParametroService().guardarMetaOtd(fraccion);
      _s.cambiarMeta(fraccion);
      _aviso('Meta de entregas a tiempo actualizada.');
    } catch (e) {
      _aviso(mensajeDeError(e));
    }
  }

  /// T-18: queda a tiempo o retrasada según la promesa, y el OTD se recalcula.
  Future<void> _marcarEntregada(OrdenEntrega o) async {
    try {
      final guardada = await _servicio.marcarEntregada(o);
      _s.reemplazarOrden(guardada);
      _aviso('Orden ${o.codigo} marcada como entregada.');
    } catch (e) {
      _aviso(mensajeDeError(e));
    }
  }

  /// T-18
  Future<void> _eliminar(OrdenEntrega o) async {
    final ok = await confirmar(
      context,
      titulo: 'Eliminar orden',
      mensaje: 'Se eliminará la orden ${o.codigo}. Esta acción no se puede deshacer.',
    );
    if (!ok) return;
    try {
      await _servicio.eliminarOrden(o.id);
      _s.quitarOrden(o.id);
      _aviso('Orden eliminada.');
    } catch (e) {
      _aviso(mensajeDeError(e));
    }
  }

  /// T-19: recarga el listado; los filtros se aplican después sobre lo cargado.
  Future<void> _recargar() async {
    try {
      final ordenes = await _servicio.getOrdenes();
      if (!mounted) return;
      _s.reemplazarOrdenes(ordenes);
      setState(() => _error = null);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = mensajeDeError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return EstadoError(mensaje: _error!, onReintentar: _recargar);
    }
    return ListenableBuilder(
      listenable: _s,
      builder: (context, _) {
        return RefreshIndicator(
          onRefresh: _recargar,
          // En web el gesto de deslizar también se hace con el mouse.
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: PointerDeviceKind.values.toSet()),
            child: OrdersPage(
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
              onEditarMeta: () => mostrarDialogoMeta(context, actual: _s.metaOtd, onGuardar: _guardarMeta),
              onNuevaOrden: _nueva,
              onMarcarEntregada: _marcarEntregada,
              onEliminar: _eliminar,
            ),
          ),
        );
      },
    );
  }
}
