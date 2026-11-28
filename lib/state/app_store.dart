import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'datos_iniciales.dart';

/// Estado de la sesión: los datos que llegaron de Supabase al entrar y los
/// indicadores que se calculan sobre ellos. Lo crea y posee HomeScreen con lo que
/// devuelve cargarDatosIniciales(); las Pages nunca lo ven: las Screens le piden
/// datos y se los pasan a las Pages junto con callbacks.
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
        ordenes = d.ordenes,
        metaOtd = d.metaOtd;

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

  /// Meta de OTD configurable (RF-09), como fracción (0,95 = 95 %). Se guarda en la tabla parametro.
  double metaOtd;

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
  // Cada indicador acepta una zona (F-02 CA-5); con null se calcula para toda la flota.

  Set<int> _vehiculosDe(int? idZona) => vehiculosDeZona(idZona).map((v) => v.id).toSet();

  /// Ids de los viajes hechos con vehículos de la zona.
  Set<int> _viajesDe(int? idZona) {
    final veh = _vehiculosDe(idZona);
    final asig = asignaciones.where((a) => veh.contains(a.idVehiculo)).map((a) => a.id).toSet();
    return viajes.where((v) => asig.contains(v.idAsignacion)).map((v) => v.id).toSet();
  }

  /// RF-07: fallas no planificadas en ruta.
  int varadasDe(int? idZona) {
    final veh = _vehiculosDe(idZona);
    return mantenimientos.where((m) => m.enRuta && m.origen == 'correctivo' && veh.contains(m.idVehiculo)).length;
  }

  int viajesDe(int? idZona) => idZona == null ? viajes.length : _viajesDe(idZona).length;

  /// RF-07: fallas no planificadas en ruta sobre el total de viajes.
  double tasaVaradasDe(int? idZona) {
    final total = viajesDe(idZona);
    return total == 0 ? 0 : varadasDe(idZona) / total;
  }

  /// RF-12: vehículos con sensores sobre el total de la flota.
  int conTelemetriaDe(int? idZona) => vehiculosDeZona(idZona).where((v) => v.hasTelemetry).length;

  double coberturaDe(int? idZona) {
    final total = vehiculosDeZona(idZona).length;
    return total == 0 ? 0 : conTelemetriaDe(idZona) / total;
  }

  /// RF-09: OTD = entregas a tiempo / (a tiempo + retrasadas). Por zona cuentan las
  /// órdenes cuyo viaje se hizo con un vehículo de esa zona.
  double otdDe(int? idZona) {
    final viajesZona = idZona == null ? null : _viajesDe(idZona);
    final sel = ordenes.where((o) => viajesZona == null || (o.idViaje != null && viajesZona.contains(o.idViaje)));
    final aTiempo = sel.where((o) => o.estado == 'a_tiempo').length;
    final total = aTiempo + sel.where((o) => o.estado == 'retrasada').length;
    return total == 0 ? 0 : aTiempo / total;
  }

  bool cumpleMetaDe(int? idZona) => otdDe(idZona) >= metaOtd;

  int get varadas => varadasDe(null);
  double get tasaVaradas => tasaVaradasDe(null);
  int get conTelemetria => conTelemetriaDe(null);
  double get cobertura => coberturaDe(null);
  double get otd => otdDe(null);
  bool get cumpleMeta => cumpleMetaDe(null);

  // ---------------------------------------------------------------- mantenimiento (RF-02, RF-03)

  void agregarMantenimiento(Mantenimiento guardado) {
    mantenimientos.insert(0, guardado);
    final v = vehiculo(guardado.idVehiculo);
    v.kilometrajeActual = math.max(v.kilometrajeActual, guardado.kilometraje);
    if (guardado.origen == 'preventivo') v.kmUltimoPreventivo = guardado.kilometraje;
    if (guardado.idPrediccion != null) {
      for (final p in predicciones) {
        if (p.id == guardado.idPrediccion) {
          p.estado = 'confirmada';
          p.idUsuarioRevision = guardado.idUsuarioRegistro ?? usuario.id;
        }
      }
    }
    notifyListeners();
  }

  void reemplazarMantenimiento(Mantenimiento m) {
    final i = mantenimientos.indexWhere((item) => item.id == m.id);
    if (i >= 0) {
      mantenimientos[i] = m;
      notifyListeners();
    }
  }

  void quitarMantenimiento(int id) {
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

  void editarMantenimiento(int id, MantenimientoBorrador b) {
    final i = mantenimientos.indexWhere((m) => m.id == id);
    if (i < 0) return;
    final m = mantenimientos[i];
    reemplazarMantenimiento(Mantenimiento(
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
    ));
  }

  void eliminarMantenimiento(int id) => quitarMantenimiento(id);

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

  // Las órdenes llegan ya guardadas por OrderService: el store solo refleja lo
  // que Supabase confirmó.

  void agregarOrden(OrdenEntrega guardada) {
    ordenes.add(guardada);
    notifyListeners();
  }

  void reemplazarOrden(OrdenEntrega guardada) {
    final i = ordenes.indexWhere((o) => o.id == guardada.id);
    if (i < 0) return;
    ordenes[i] = guardada;
    notifyListeners();
  }

  void quitarOrden(int id) {
    ordenes.removeWhere((o) => o.id == id);
    notifyListeners();
  }

  /// T-19: el listado recargado desde Supabase reemplaza al que había.
  void reemplazarOrdenes(List<OrdenEntrega> nuevas) {
    ordenes
      ..clear()
      ..addAll(nuevas);
    notifyListeners();
  }

  // ---------------------------------------------------------------- detalle de vehículo (TS-03)

  /// T-09: deja como lectura actual del vehículo la última que llegó de Supabase.
  void reemplazarTelemetria(int idVehiculo, TelemetriaGps? nuevoGps, TelemetriaObd? nuevoObd) {
    gps.removeWhere((t) => t.idVehiculo == idVehiculo);
    obd.removeWhere((t) => t.idVehiculo == idVehiculo);
    // Las listas van de la lectura más reciente a la más antigua: la nueva va adelante.
    if (nuevoGps != null) gps.insert(0, nuevoGps);
    if (nuevoObd != null) obd.insert(0, nuevoObd);
    notifyListeners();
  }

  /// T-10: reemplaza los eventos y el historial de un vehículo por los recargados.
  void reemplazarDelVehiculo(
      int idVehiculo, List<EventoConduccion> nuevosEventos, List<Mantenimiento> nuevosMantenimientos) {
    eventos
      ..removeWhere((e) => e.idVehiculo == idVehiculo)
      ..addAll(nuevosEventos);
    mantenimientos
      ..removeWhere((m) => m.idVehiculo == idVehiculo)
      ..addAll(nuevosMantenimientos);
    notifyListeners();
  }

  void cambiarMeta(double fraccion) {
    metaOtd = fraccion.clamp(0.0, 1.0).toDouble();
    notifyListeners();
  }
}
