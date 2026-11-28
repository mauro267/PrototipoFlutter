// Modelos Dart alineados con docs/modelo.md (nombres en camelCase).
// fromMap lee una fila de Supabase (columnas en snake_case).

double _num(dynamic v) => (v as num).toDouble();
DateTime _fecha(dynamic v) => DateTime.parse(v as String).toLocal();
DateTime? _fechaOpt(dynamic v) => v == null ? null : _fecha(v);

class Usuario {
  final int id;
  final String authUuid; // uuid de Supabase Auth (AD-03)
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

  factory Usuario.fromMap(Map<String, dynamic> m) => Usuario(
        id: m['id_usuario'] as int,
        authUuid: m['auth_uuid'] as String,
        nombre: m['nombre'] as String,
        email: m['email'] as String,
        rol: m['rol'] as String,
        pais: m['pais'] as String,
        activo: m['activo'] as bool,
      );

  /// Fila nueva: sin id_usuario, que lo pone la base de datos.
  Map<String, dynamic> toMap() => {
        'auth_uuid': authUuid,
        'nombre': nombre,
        'email': email,
        'rol': rol,
        'pais': pais,
        'activo': activo,
      };
}

class Zona {
  final int id;
  final String nombre;
  final String ciudad;
  final String pais;
  const Zona(this.id, this.nombre, this.ciudad, this.pais);

  factory Zona.fromMap(Map<String, dynamic> m) =>
      Zona(m['id_zona'] as int, m['nombre'] as String, m['ciudad'] as String, m['pais'] as String);
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

  factory Conductor.fromMap(Map<String, dynamic> m) => Conductor(
        id: m['id_conductor'] as int,
        nombre: m['nombre'] as String,
        documento: m['documento'] as String,
        telefono: (m['telefono'] as String?) ?? '',
        licencia: m['licencia'] as String,
        idZona: m['id_zona'] as int,
        activo: m['activo'] as bool,
      );
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

  factory Vehiculo.fromMap(Map<String, dynamic> m) => Vehiculo(
        id: m['id_vehiculo'] as int,
        placa: m['placa'] as String,
        tipo: m['tipo'] as String,
        marca: m['marca'] as String,
        modelo: m['modelo'] as String,
        idZona: m['id_zona'] as int,
        estadoOperativo: m['estado_operativo'] as String,
        kilometrajeActual: _num(m['kilometraje_actual']),
        hasTelemetry: m['has_telemetry'] as bool,
        fechaInstalacionIot: _fechaOpt(m['fecha_instalacion_iot']),
        intervaloPreventivoKm: _num(m['intervalo_preventivo_km']),
        kmUltimoPreventivo: _num(m['km_ultimo_preventivo']),
      );

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

  factory AsignacionTurno.fromMap(Map<String, dynamic> m) => AsignacionTurno(
      m['id_asignacion'] as int, m['id_conductor'] as int, m['id_vehiculo'] as int, _fecha(m['fecha']));
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

  factory Viaje.fromMap(Map<String, dynamic> m) => Viaje(
        id: m['id_viaje'] as int,
        codigo: m['codigo'] as String,
        idAsignacion: m['id_asignacion'] as int,
        fechaInicio: _fecha(m['fecha_inicio']),
        fechaFin: _fechaOpt(m['fecha_fin']),
        kmRecorridos: _num(m['km_recorridos']),
        paradasTotales: m['paradas_totales'] as int,
        paradasCompletadas: m['paradas_completadas'] as int,
        estado: m['estado'] as String,
      );
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

  factory EventoConduccion.fromMap(Map<String, dynamic> m) => EventoConduccion(
        id: m['id_evento'] as int,
        idVehiculo: m['id_vehiculo'] as int,
        idViaje: m['id_viaje'] as int?,
        fechaHora: _fecha(m['fecha_hora']),
        tipo: m['tipo'] as String,
        magnitud: _num(m['magnitud']),
        unidad: m['unidad'] as String,
        ubicacion: (m['ubicacion'] as String?) ?? '',
      );
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

  factory TelemetriaGps.fromMap(Map<String, dynamic> m) => TelemetriaGps(
        idVehiculo: m['id_vehiculo'] as int,
        fechaHora: _fecha(m['fecha_hora']),
        lat: _num(m['lat']),
        lon: _num(m['lon']),
        velocidad: _num(m['velocidad']),
      );
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

  factory TelemetriaObd.fromMap(Map<String, dynamic> m) => TelemetriaObd(
        idVehiculo: m['id_vehiculo'] as int,
        fechaHora: _fecha(m['fecha_hora']),
        codigoFalla: m['codigo_falla'] as String?,
        tempMotor: _num(m['temp_motor']),
        rpm: _num(m['rpm']),
        nivelCombustible: _num(m['nivel_combustible']),
      );
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

  factory PrediccionFalla.fromMap(Map<String, dynamic> m) => PrediccionFalla(
        id: m['id_prediccion'] as int,
        idVehiculo: m['id_vehiculo'] as int,
        fechaPrediccion: _fecha(m['fecha_prediccion']),
        componente: m['componente'] as String,
        probabilidad: _num(m['probabilidad']),
        fechaLimiteMantenimiento: _fecha(m['fecha_limite_mantenimiento']),
        estado: m['estado'] as String,
        fechaProgramada: _fechaOpt(m['fecha_programada']),
        idUsuarioRevision: m['id_usuario_revision'] as int?,
      );
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
  final int? idUsuarioRegistro;
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

  factory Mantenimiento.fromMap(Map<String, dynamic> m) => Mantenimiento(
        id: m['id_mantenimiento'] as int,
        idVehiculo: m['id_vehiculo'] as int,
        idPrediccion: m['id_prediccion'] as int?,
        fecha: _fecha(m['fecha']),
        origen: m['origen'] as String,
        tipoFalla: m['tipo_falla'] as String,
        descripcion: m['descripcion'] as String,
        kilometraje: _num(m['kilometraje']),
        costo: _num(m['costo']),
        moneda: m['moneda'] as String,
        horasFueraServicio: _num(m['horas_fuera_servicio']),
        enRuta: m['en_ruta'] as bool,
        idUsuarioRegistro: m['id_usuario_registro'] as int?,
      );

  /// Fila nueva para Supabase: sin id_mantenimiento (lo genera la BD), fecha como yyyy-MM-dd.
  Map<String, dynamic> toMap() => {
        'id_vehiculo': idVehiculo,
        'id_prediccion': idPrediccion,
        'fecha':
            '${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}',
        'origen': origen,
        'tipo_falla': tipoFalla,
        'descripcion': descripcion,
        'kilometraje': kilometraje,
        'costo': costo,
        'moneda': moneda,
        'horas_fuera_servicio': horasFueraServicio,
        'en_ruta': enRuta,
        'id_usuario_registro': idUsuarioRegistro,
      };
}

class ClienteRetailer {
  final int id;
  final String nombre;
  final String pais;
  final String canalIntegracion;
  final String formatoOrigen;
  const ClienteRetailer(
      this.id, this.nombre, this.pais, this.canalIntegracion, this.formatoOrigen);

  factory ClienteRetailer.fromMap(Map<String, dynamic> m) => ClienteRetailer(m['id_cliente'] as int,
      m['nombre'] as String, m['pais'] as String, m['canal_integracion'] as String, m['formato_origen'] as String);
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

  factory OrdenEntrega.fromMap(Map<String, dynamic> m) => OrdenEntrega(
        id: m['id_orden'] as int,
        codigo: m['codigo'] as String,
        idCliente: m['id_cliente'] as int,
        idViaje: m['id_viaje'] as int?,
        direccionDestino: m['direccion_destino'] as String,
        ciudad: m['ciudad'] as String,
        fechaCreacion: _fecha(m['fecha_creacion']),
        fechaPromesa: _fecha(m['fecha_promesa']),
        fechaEntregaReal: _fechaOpt(m['fecha_entrega_real']),
        estado: m['estado'] as String,
      );

  /// Fila nueva: sin id_orden, que lo pone la base de datos.
  Map<String, dynamic> toMap() => {
        'codigo': codigo,
        'id_cliente': idCliente,
        'id_viaje': idViaje,
        'direccion_destino': direccionDestino,
        'ciudad': ciudad,
        'fecha_creacion': fechaCreacion.toUtc().toIso8601String(),
        'fecha_promesa': fechaPromesa.toUtc().toIso8601String(),
        'fecha_entrega_real': fechaEntregaReal?.toUtc().toIso8601String(),
        'estado': estado,
      };
}

/// Foto de evidencia de un mantenimiento (RF-13), guardada en el bucket evidencias.
class Evidencia {
  final int id;
  final int idMantenimiento;
  final String ruta;
  final String url;
  final DateTime fechaSubida;
  const Evidencia({
    required this.id,
    required this.idMantenimiento,
    required this.ruta,
    required this.url,
    required this.fechaSubida,
  });

  factory Evidencia.fromMap(Map<String, dynamic> m) => Evidencia(
        id: m['id_evidencia'] as int,
        idMantenimiento: m['id_mantenimiento'] as int,
        ruta: m['ruta'] as String,
        url: m['url'] as String,
        fechaSubida: _fecha(m['fecha_subida']),
      );
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
