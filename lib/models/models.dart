// Modelos Dart alineados con docs/modelo.md (nombres en camelCase).

class Usuario {
  final int id;
  final String authUuid; // uuid de Supabase Auth (AD-03), simulado en esta entrega
  final String nombre;
  final String email;
  final String rol; // coordinador | mecanico (v2)
  final String pais;
  final bool activo;
  const Usuario({
    required this.id,
    required this.authUuid,
    required this.nombre,
    required this.email,
    required this.rol,
    required this.pais,
    this.activo = true,
  });
}

class Zona {
  final int id;
  final String nombre;
  final String ciudad;
  final String pais;
  const Zona(this.id, this.nombre, this.ciudad, this.pais);
}

class Conductor {
  final int id;
  final String nombre;
  final String documento;
  final String telefono;
  final String licencia;
  final int idZona;
  final bool activo;
  const Conductor({
    required this.id,
    required this.nombre,
    required this.documento,
    required this.telefono,
    required this.licencia,
    required this.idZona,
    this.activo = true,
  });
}

/// estadoOperativo: en_ruta | disponible | alerta | varado | mantenimiento
class Vehiculo {
  final int id;
  final String placa;
  final String tipo; // furgon | moto | camion | tractocamion
  final String marca;
  final String modelo;
  final int idZona;
  String estadoOperativo;
  double kilometrajeActual;
  final bool hasTelemetry;
  final DateTime? fechaInstalacionIot;
  final double intervaloPreventivoKm;
  double kmUltimoPreventivo;

  Vehiculo({
    required this.id,
    required this.placa,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.idZona,
    required this.estadoOperativo,
    required this.kilometrajeActual,
    required this.hasTelemetry,
    this.fechaInstalacionIot,
    required this.intervaloPreventivoKm,
    required this.kmUltimoPreventivo,
  });

  String get nombre => '$marca $modelo';

  /// Kilómetros recorridos desde el último preventivo.
  double get kmDesdePreventivo => kilometrajeActual - kmUltimoPreventivo;

  /// Kilómetros que faltan para el próximo preventivo (negativo si está vencido).
  double get kmParaPreventivo => intervaloPreventivoKm - kmDesdePreventivo;
}

class AsignacionTurno {
  final int id;
  final int idConductor;
  final int idVehiculo;
  final DateTime fecha;
  const AsignacionTurno(this.id, this.idConductor, this.idVehiculo, this.fecha);
}

/// estado: en_curso | completado
class Viaje {
  final int id;
  final String codigo;
  final int idAsignacion;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final double kmRecorridos;
  final int paradasTotales;
  final int paradasCompletadas;
  final String estado;
  const Viaje({
    required this.id,
    required this.codigo,
    required this.idAsignacion,
    required this.fechaInicio,
    this.fechaFin,
    required this.kmRecorridos,
    required this.paradasTotales,
    required this.paradasCompletadas,
    required this.estado,
  });
}

class EventoConduccion {
  final int id;
  final int idVehiculo;
  final int? idViaje;
  final DateTime fechaHora;
  final String tipo;
  final double magnitud;
  final String unidad;
  final String ubicacion;
  const EventoConduccion({
    required this.id,
    required this.idVehiculo,
    this.idViaje,
    required this.fechaHora,
    required this.tipo,
    required this.magnitud,
    required this.unidad,
    required this.ubicacion,
  });
}

class TelemetriaGps {
  final int idVehiculo;
  final DateTime fechaHora;
  final double lat;
  final double lon;
  final double velocidad;
  const TelemetriaGps({
    required this.idVehiculo,
    required this.fechaHora,
    required this.lat,
    required this.lon,
    required this.velocidad,
  });
}

class TelemetriaObd {
  final int idVehiculo;
  final DateTime fechaHora;
  final String? codigoFalla;
  final double tempMotor;
  final double rpm;
  final double nivelCombustible;
  const TelemetriaObd({
    required this.idVehiculo,
    required this.fechaHora,
    required this.codigoFalla,
    required this.tempMotor,
    required this.rpm,
    required this.nivelCombustible,
  });
}

/// estado: pendiente | programada | confirmada
class PrediccionFalla {
  final int id;
  final int idVehiculo;
  final DateTime fechaPrediccion;
  final String componente;
  final double probabilidad; // 0..1
  final DateTime fechaLimiteMantenimiento;
  String estado;
  DateTime? fechaProgramada;
  int? idUsuarioRevision;

  PrediccionFalla({
    required this.id,
    required this.idVehiculo,
    required this.fechaPrediccion,
    required this.componente,
    required this.probabilidad,
    required this.fechaLimiteMantenimiento,
    this.estado = 'pendiente',
    this.fechaProgramada,
    this.idUsuarioRevision,
  });
}

/// origen: preventivo | correctivo
class Mantenimiento {
  final int id;
  final int idVehiculo;
  final int? idPrediccion;
  final DateTime fecha;
  final String origen;
  final String tipoFalla;
  final String descripcion;
  final double kilometraje;
  final double costo;
  final String moneda;
  final double horasFueraServicio;
  final bool enRuta;
  final int idUsuarioRegistro;
  const Mantenimiento({
    required this.id,
    required this.idVehiculo,
    this.idPrediccion,
    required this.fecha,
    required this.origen,
    required this.tipoFalla,
    required this.descripcion,
    required this.kilometraje,
    required this.costo,
    this.moneda = 'COP',
    required this.horasFueraServicio,
    required this.enRuta,
    required this.idUsuarioRegistro,
  });
}

class ClienteRetailer {
  final int id;
  final String nombre;
  final String pais;
  final String canalIntegracion;
  final String formatoOrigen;
  const ClienteRetailer(
      this.id, this.nombre, this.pais, this.canalIntegracion, this.formatoOrigen);
}

/// estado: a_tiempo | en_camino | en_riesgo | retrasada | pendiente
class OrdenEntrega {
  final int id;
  final String codigo;
  final int idCliente;
  final int? idViaje;
  final String direccionDestino;
  final String ciudad;
  final DateTime fechaCreacion;
  final DateTime fechaPromesa;
  final DateTime? fechaEntregaReal;
  final String estado;
  const OrdenEntrega({
    required this.id,
    required this.codigo,
    required this.idCliente,
    this.idViaje,
    required this.direccionDestino,
    required this.ciudad,
    required this.fechaCreacion,
    required this.fechaPromesa,
    this.fechaEntregaReal,
    required this.estado,
  });
}

/// Datos que captura el formulario de mantenimiento (crear o editar).
class MantenimientoBorrador {
  final int idVehiculo;
  final int? idPrediccion;
  final String origen;
  final String tipoFalla;
  final String descripcion;
  final double kilometraje;
  final double costo;
  final double horasFuera;
  final bool enRuta;
  const MantenimientoBorrador({
    required this.idVehiculo,
    this.idPrediccion,
    required this.origen,
    required this.tipoFalla,
    required this.descripcion,
    required this.kilometraje,
    required this.costo,
    required this.horasFuera,
    required this.enRuta,
  });
}

/// Datos que captura el formulario de nueva orden de entrega.
class OrdenBorrador {
  final int idCliente;
  final String direccion;
  final String ciudad;
  final DateTime fechaPromesa;
  const OrdenBorrador({
    required this.idCliente,
    required this.direccion,
    required this.ciudad,
    required this.fechaPromesa,
  });
}
