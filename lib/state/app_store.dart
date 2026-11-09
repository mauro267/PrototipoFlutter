import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../services/simulated_data.dart';

/// Datos de la app en memoria y sus operaciones (crear, editar, eliminar).
/// Lo crea y posee la pantalla anfitriona (HomeScreen); las Pages nunca lo ven:
/// las Screens le piden datos y se los pasan a las Pages junto con callbacks.
class AppStore extends ChangeNotifier {
  AppStore(DatosIniciales d, this.usuario)
      : zonas = d.zonas,
        conductores = d.conductores,
        vehiculos = d.vehiculos,
        asignaciones = d.asignaciones,
        viajes = d.viajes,
        eventos = d.eventos,
        gps = d.gps,
        obd = d.obd,
        predicciones = d.predicciones,
        mantenimientos = d.mantenimientos,
        clientes = d.clientes,
        ordenes = d.ordenes;

  final Usuario usuario;
  final List<Zona> zonas;
  final List<Conductor> conductores;
  final List<Vehiculo> vehiculos;
  final List<AsignacionTurno> asignaciones;
  final List<Viaje> viajes;
  final List<EventoConduccion> eventos;
  final List<TelemetriaGps> gps;
  final List<TelemetriaObd> obd;
  final List<PrediccionFalla> predicciones;
  final List<Mantenimiento> mantenimientos;
  final List<ClienteRetailer> clientes;
  final List<OrdenEntrega> ordenes;

  /// Meta de OTD configurable (RF-09), como fracción (0,95 = 95 %).
  double metaOtd = 0.95;

  // ---------------------------------------------------------------- consultas

  Zona zona(int id) => zonas.firstWhere((z) => z.id == id);
  Vehiculo vehiculo(int id) => vehiculos.firstWhere((v) => v.id == id);
  ClienteRetailer cliente(int id) => clientes.firstWhere((c) => c.id == id);

  Conductor? conductorDe(Vehiculo v) {
    for (final a in asignaciones) {
      if (a.idVehiculo == v.id) {
        return conductores.firstWhere((c) => c.id == a.idConductor);
      }
    }
    return null;
  }

  TelemetriaObd? obdDe(int idVehiculo) {
    for (final t in obd) {
      if (t.idVehiculo == idVehiculo) return t;
    }
    return null;
  }

  TelemetriaGps? gpsDe(int idVehiculo) {
    for (final t in gps) {
      if (t.idVehiculo == idVehiculo) return t;
    }
    return null;
  }

  List<EventoConduccion> eventosDe(int idVehiculo) {
    final r = eventos.where((e) => e.idVehiculo == idVehiculo).toList();
    r.sort((a, b) => b.fechaHora.compareTo(a.fechaHora));
    return r;
  }

  List<Vehiculo> vehiculosDeZona(int? idZona) => idZona == null
      ? List<Vehiculo>.of(vehiculos)
      : vehiculos.where((v) => v.idZona == idZona).toList();

  /// Vehículos sin sensores: siguen el esquema preventivo por kilometraje.
  List<Vehiculo> get sinTelemetria {
    final r = vehiculos.where((v) => !v.hasTelemetry).toList();
    r.sort((a, b) => a.kmParaPreventivo.compareTo(b.kmParaPreventivo));
    return r;
  }

  /// "PLACA · Marca Modelo" por id de vehículo.
  Map<int, String> get etiquetasVehiculo =>
      {for (final v in vehiculos) v.id: '${v.placa} · ${v.nombre}'};

  Map<int, String> get nombresCliente => {for (final c in clientes) c.id: c.nombre};

  /// Nombre del conductor asignado, por id de vehículo.
  Map<int, String> get conductoresPorVehiculo {
    final r = <int, String>{};
    for (final v in vehiculos) {
      final c = conductorDe(v);
      if (c != null) r[v.id] = c.nombre;
    }
    return r;
  }

  /// RF-01: alertas vigentes de vehículos con telemetría (AD-04), de mayor a menor probabilidad.
  List<PrediccionFalla> get alertas {
    final r = predicciones
        .where((p) => p.estado != 'confirmada' && vehiculo(p.idVehiculo).hasTelemetry)
        .toList();
    r.sort((a, b) => b.probabilidad.compareTo(a.probabilidad));
    return r;
  }

  List<PrediccionFalla> alertasDe(int idVehiculo) =>
      alertas.where((p) => p.idVehiculo == idVehiculo).toList();

  /// Historial, del más reciente al más antiguo.
  List<Mantenimiento> get historial {
    final r = List<Mantenimiento>.of(mantenimientos);
    r.sort((a, b) => b.fecha.compareTo(a.fecha));
    return r;
  }

  List<Mantenimiento> historialDe(int idVehiculo) =>
      historial.where((m) => m.idVehiculo == idVehiculo).toList();

  List<OrdenEntrega> ordenesFiltradas({int? idCliente, String? estado}) {
    final r = ordenes
        .where((o) =>
            (idCliente == null || o.idCliente == idCliente) &&
            (estado == null || o.estado == estado))
        .toList();
    r.sort((a, b) => a.fechaPromesa.compareTo(b.fechaPromesa));
    return r;
  }

  int contarOrdenes(String estado) => ordenes.where((o) => o.estado == estado).length;

  // ---------------------------------------------------------------- indicadores

  /// RF-07: fallas no planificadas en ruta sobre el total de viajes.
  int get varadas =>
      mantenimientos.where((m) => m.enRuta && m.origen == 'correctivo').length;

  double get tasaVaradas => viajes.isEmpty ? 0 : varadas / viajes.length;

  /// RF-12: vehículos con sensores sobre el total de la flota.
  int get conTelemetria => vehiculos.where((v) => v.hasTelemetry).length;

  double get cobertura => vehiculos.isEmpty ? 0 : conTelemetria / vehiculos.length;

  /// RF-09: OTD = entregas a tiempo / (a tiempo + retrasadas).
  double get otd {
    final aTiempo = contarOrdenes('a_tiempo');
    final total = aTiempo + contarOrdenes('retrasada');
    return total == 0 ? 0 : aTiempo / total;
  }

  bool get cumpleMeta => otd >= metaOtd;

  // ---------------------------------------------------------------- mantenimiento (RF-02, RF-03)

  int _siguiente(Iterable<int> ids) => ids.isEmpty ? 1 : ids.reduce(math.max) + 1;

  void agregarMantenimiento(MantenimientoBorrador b) {
    mantenimientos.add(Mantenimiento(
      id: _siguiente(mantenimientos.map((m) => m.id)),
      idVehiculo: b.idVehiculo,
      idPrediccion: b.idPrediccion,
      fecha: DateTime.now(),
      origen: b.origen,
      tipoFalla: b.tipoFalla,
      descripcion: b.descripcion,
      kilometraje: b.kilometraje,
      costo: b.costo,
      horasFueraServicio: b.horasFuera,
      enRuta: b.origen == 'correctivo' && b.enRuta,
      idUsuarioRegistro: usuario.id,
    ));
    final v = vehiculo(b.idVehiculo);
    v.kilometrajeActual = math.max(v.kilometrajeActual, b.kilometraje);
    if (b.origen == 'preventivo') v.kmUltimoPreventivo = b.kilometraje;
    if (b.idPrediccion != null) {
      for (final p in predicciones) {
        if (p.id == b.idPrediccion) {
          p.estado = 'confirmada';
          p.idUsuarioRevision = usuario.id;
        }
      }
    }
    notifyListeners();
  }

  void editarMantenimiento(int id, MantenimientoBorrador b) {
    final i = mantenimientos.indexWhere((m) => m.id == id);
    if (i < 0) return;
    final m = mantenimientos[i];
    mantenimientos[i] = Mantenimiento(
      id: m.id,
      idVehiculo: b.idVehiculo,
      idPrediccion: m.idPrediccion,
      fecha: m.fecha,
      origen: b.origen,
      tipoFalla: b.tipoFalla,
      descripcion: b.descripcion,
      kilometraje: b.kilometraje,
      costo: b.costo,
      moneda: m.moneda,
      horasFueraServicio: b.horasFuera,
      enRuta: b.origen == 'correctivo' && b.enRuta,
      idUsuarioRegistro: m.idUsuarioRegistro,
    );
    notifyListeners();
  }

  void eliminarMantenimiento(int id) {
    final i = mantenimientos.indexWhere((m) => m.id == id);
    if (i < 0) return;
    final idPred = mantenimientos[i].idPrediccion;
    mantenimientos.removeAt(i);
    // Si el mantenimiento había confirmado una predicción, vuelve a estar pendiente.
    if (idPred != null && !mantenimientos.any((m) => m.idPrediccion == idPred)) {
      for (final p in predicciones) {
        if (p.id == idPred && p.estado == 'confirmada') p.estado = 'pendiente';
      }
    }
    notifyListeners();
  }

  void programarAlerta(int idPrediccion, DateTime fecha) {
    for (final p in predicciones) {
      if (p.id == idPrediccion) {
        p.estado = 'programada';
        p.fechaProgramada = fecha;
        p.idUsuarioRevision = usuario.id;
      }
    }
    notifyListeners();
  }

  void cancelarProgramacion(int idPrediccion) {
    for (final p in predicciones) {
      if (p.id == idPrediccion) {
        p.estado = 'pendiente';
        p.fechaProgramada = null;
      }
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------- órdenes (RF-08, RF-10)

  void agregarOrden(OrdenBorrador b) {
    final id = _siguiente(ordenes.map((o) => o.id));
    ordenes.add(OrdenEntrega(
      id: id,
      codigo: 'RV-${88291 + id - 1}',
      idCliente: b.idCliente,
      direccionDestino: b.direccion,
      ciudad: b.ciudad,
      fechaCreacion: DateTime.now(),
      fechaPromesa: b.fechaPromesa,
      estado: 'pendiente',
    ));
    notifyListeners();
  }

  /// Marca una orden como entregada ahora; queda a tiempo o retrasada según la promesa.
  void marcarEntregada(int idOrden) {
    final i = ordenes.indexWhere((o) => o.id == idOrden);
    if (i < 0) return;
    final o = ordenes[i];
    final ahora = DateTime.now();
    ordenes[i] = OrdenEntrega(
      id: o.id,
      codigo: o.codigo,
      idCliente: o.idCliente,
      idViaje: o.idViaje,
      direccionDestino: o.direccionDestino,
      ciudad: o.ciudad,
      fechaCreacion: o.fechaCreacion,
      fechaPromesa: o.fechaPromesa,
      fechaEntregaReal: ahora,
      estado: ahora.isAfter(o.fechaPromesa) ? 'retrasada' : 'a_tiempo',
    );
    notifyListeners();
  }

  void eliminarOrden(int id) {
    ordenes.removeWhere((o) => o.id == id);
    notifyListeners();
  }

  void cambiarMeta(double fraccion) {
    metaOtd = fraccion.clamp(0.0, 1.0).toDouble();
    notifyListeners();
  }
}
