import '../models/models.dart';

/// Las listas con las que arranca el AppStore. En la app las arma
/// cargarDatosIniciales() con lo que devuelve Supabase; en las pruebas, test/datos_simulados.dart.
class DatosIniciales {
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
  final double metaOtd;

  DatosIniciales({
    required this.zonas,
    required this.conductores,
    required this.vehiculos,
    required this.asignaciones,
    required this.viajes,
    required this.eventos,
    required this.gps,
    required this.obd,
    required this.predicciones,
    required this.mantenimientos,
    required this.clientes,
    required this.ordenes,
    this.metaOtd = 0.95,
  });
}
