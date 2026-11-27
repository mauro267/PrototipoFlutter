import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

/// Clientes retailer y órdenes de entrega: lecturas y escrituras (TS-06).
class OrderService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<ClienteRetailer>> getClientes() async {
    final filas = await _client.from('cliente_retailer').select().order('id_cliente');
    return filas.map(ClienteRetailer.fromMap).toList();
  }

  Future<List<OrdenEntrega>> getOrdenes() async {
    final filas = await _client.from('orden_entrega').select().order('fecha_promesa');
    return filas.map(OrdenEntrega.fromMap).toList();
  }

  /// RF-08: guarda una orden nueva como pendiente. El código es RV-<n>, con n el
  /// siguiente número después del mayor código existente.
  Future<OrdenEntrega> crearOrden(OrdenBorrador b) async {
    final codigos = await _client.from('orden_entrega').select('codigo');
    var mayor = 88290;
    for (final f in codigos) {
      final n = int.tryParse((f['codigo'] as String).replaceFirst('RV-', ''));
      if (n != null && n > mayor) mayor = n;
    }
    final nueva = OrdenEntrega(
      id: 0, // lo pone la base de datos; toMap no lo envía
      codigo: 'RV-${mayor + 1}',
      idCliente: b.idCliente,
      direccionDestino: b.direccion,
      ciudad: b.ciudad,
      fechaCreacion: DateTime.now(),
      fechaPromesa: b.fechaPromesa,
      estado: 'pendiente',
    );
    final fila = await _client.from('orden_entrega').insert(nueva.toMap()).select().single();
    return OrdenEntrega.fromMap(fila);
  }

  /// RF-10: la orden queda entregada ahora, a tiempo o retrasada según su promesa.
  Future<OrdenEntrega> marcarEntregada(OrdenEntrega o) async {
    final ahora = DateTime.now();
    final fila = await _client
        .from('orden_entrega')
        .update({
          'fecha_entrega_real': ahora.toUtc().toIso8601String(),
          'estado': ahora.isAfter(o.fechaPromesa) ? 'retrasada' : 'a_tiempo',
        })
        .eq('id_orden', o.id)
        .select()
        .single();
    return OrdenEntrega.fromMap(fila);
  }

  Future<void> eliminarOrden(int id) async {
    await _client.from('orden_entrega').delete().eq('id_orden', id);
  }
}
