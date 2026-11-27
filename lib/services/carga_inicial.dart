import '../models/models.dart';
import '../state/datos_iniciales.dart';
import 'fleet_service.dart';
import 'maintenance_service.dart';
import 'order_service.dart';
import 'parametro_service.dart';

/// Pide en paralelo todas las tablas que necesita el AppStore al entrar (TS-02).
/// Si una consulta falla, falla la carga completa y HomeScreen muestra el error.
Future<DatosIniciales> cargarDatosIniciales() async {
  final flota = FleetService();
  final mantenimiento = MaintenanceService();
  final ordenes = OrderService();

  final r = await Future.wait<Object>([
    flota.getZonas(),
    flota.getConductores(),
    flota.getVehiculos(),
    flota.getAsignaciones(),
    flota.getViajes(),
    flota.getEventos(),
    flota.getGps(),
    flota.getObd(),
    mantenimiento.getPredicciones(),
    mantenimiento.getMantenimientos(),
    ordenes.getClientes(),
    ordenes.getOrdenes(),
    ParametroService().getMetaOtd(),
  ]);

  return DatosIniciales(
    zonas: r[0] as List<Zona>,
    conductores: r[1] as List<Conductor>,
    vehiculos: r[2] as List<Vehiculo>,
    asignaciones: r[3] as List<AsignacionTurno>,
    viajes: r[4] as List<Viaje>,
    eventos: r[5] as List<EventoConduccion>,
    gps: r[6] as List<TelemetriaGps>,
    obd: r[7] as List<TelemetriaObd>,
    predicciones: r[8] as List<PrediccionFalla>,
    mantenimientos: r[9] as List<Mantenimiento>,
    clientes: r[10] as List<ClienteRetailer>,
    ordenes: r[11] as List<OrdenEntrega>,
    metaOtd: r[12] as double,
  );
}
