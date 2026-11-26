import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

/// Clientes retailer y órdenes de entrega. Las escrituras llegan en TS-06.
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
}
