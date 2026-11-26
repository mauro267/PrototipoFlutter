import 'package:rutaviva/models/models.dart';
import 'package:rutaviva/state/datos_iniciales.dart';

/// Datos simulados de la Entrega 2. Ya no los usa la app (todo sale de Supabase):
/// solo las pruebas de AppStore, para no depender de la red.
class DatosSimulados {
  static List<Usuario> usuarios() => const [
        Usuario(id: 1, authUuid: '8f1c2a40-5b7e-4a55-9a1d-0c2f6e7a1b01', nombre: 'Elena Rostova', email: 'coordinador@rutaviva.com', rol: 'coordinador', pais: 'Colombia'),
        Usuario(id: 2, authUuid: '3d9b7e12-6c4a-4f08-8b3e-5a1d9c2e4f02', nombre: 'Carlos Ospina', email: 'mecanico@rutaviva.com', rol: 'mecanico', pais: 'Colombia'),
      ];

  static DatosIniciales cargar() {
    final ahora = DateTime.now();
    DateTime hace(int minutos) => ahora.subtract(Duration(minutes: minutos));
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    DateTime en(int dias) => hoy.add(Duration(days: dias));

    final zonas = <Zona>[
      const Zona(1, 'Bogotá Norte', 'Bogotá', 'Colombia'),
      const Zona(2, 'Medellín', 'Medellín', 'Colombia'),
      const Zona(3, 'Cali', 'Cali', 'Colombia'),
      const Zona(4, 'Quito', 'Quito', 'Ecuador'),
    ];

    final vehiculos = <Vehiculo>[
      Vehiculo(id: 1, placa: 'ABC-123', tipo: 'furgon', marca: 'Mercedes-Benz', modelo: 'Sprinter 519 CDI', idZona: 1, estadoOperativo: 'en_ruta', kilometrajeActual: 142880, hasTelemetry: true, fechaInstalacionIot: DateTime(2024, 3, 12), intervaloPreventivoKm: 20000, kmUltimoPreventivo: 135000),
      Vehiculo(id: 2, placa: 'YAM-88F', tipo: 'moto', marca: 'Yamaha', modelo: 'FZ25', idZona: 4, estadoOperativo: 'en_ruta', kilometrajeActual: 18420, hasTelemetry: true, fechaInstalacionIot: DateTime(2025, 1, 20), intervaloPreventivoKm: 5000, kmUltimoPreventivo: 15000),
      Vehiculo(id: 3, placa: 'BOG-452', tipo: 'camion', marca: 'Chevrolet', modelo: 'N300 Cargo', idZona: 1, estadoOperativo: 'varado', kilometrajeActual: 98210, hasTelemetry: true, fechaInstalacionIot: DateTime(2024, 6, 2), intervaloPreventivoKm: 10000, kmUltimoPreventivo: 91000),
      Vehiculo(id: 4, placa: 'MED-771', tipo: 'tractocamion', marca: 'Kenworth', modelo: 'T680', idZona: 2, estadoOperativo: 'en_ruta', kilometrajeActual: 311400, hasTelemetry: true, fechaInstalacionIot: DateTime(2023, 11, 8), intervaloPreventivoKm: 25000, kmUltimoPreventivo: 295000),
      Vehiculo(id: 5, placa: 'BUC-209', tipo: 'camion', marca: 'Hino', modelo: 'Dutro Pro', idZona: 2, estadoOperativo: 'disponible', kilometrajeActual: 76500, hasTelemetry: false, intervaloPreventivoKm: 10000, kmUltimoPreventivo: 70200),
      Vehiculo(id: 6, placa: 'CAL-310', tipo: 'furgon', marca: 'Renault', modelo: 'Master', idZona: 3, estadoOperativo: 'en_ruta', kilometrajeActual: 54300, hasTelemetry: true, fechaInstalacionIot: DateTime(2025, 4, 15), intervaloPreventivoKm: 15000, kmUltimoPreventivo: 45000),
      Vehiculo(id: 7, placa: 'CAL-311', tipo: 'furgon', marca: 'Renault', modelo: 'Master', idZona: 3, estadoOperativo: 'disponible', kilometrajeActual: 121900, hasTelemetry: false, intervaloPreventivoKm: 15000, kmUltimoPreventivo: 108000),
      Vehiculo(id: 8, placa: 'UIO-120', tipo: 'camion', marca: 'Isuzu', modelo: 'NPR', idZona: 4, estadoOperativo: 'en_ruta', kilometrajeActual: 203300, hasTelemetry: true, fechaInstalacionIot: DateTime(2024, 9, 30), intervaloPreventivoKm: 15000, kmUltimoPreventivo: 192000),
      Vehiculo(id: 9, placa: 'UIO-121', tipo: 'camion', marca: 'Isuzu', modelo: 'NPR', idZona: 4, estadoOperativo: 'mantenimiento', kilometrajeActual: 188000, hasTelemetry: false, intervaloPreventivoKm: 15000, kmUltimoPreventivo: 172000),
      Vehiculo(id: 10, placa: 'BOG-901', tipo: 'furgon', marca: 'Ford', modelo: 'Transit', idZona: 1, estadoOperativo: 'disponible', kilometrajeActual: 33100, hasTelemetry: true, fechaInstalacionIot: DateTime(2025, 7, 1), intervaloPreventivoKm: 15000, kmUltimoPreventivo: 30000),
      Vehiculo(id: 11, placa: 'MED-455', tipo: 'furgon', marca: 'Hyundai', modelo: 'H100', idZona: 2, estadoOperativo: 'alerta', kilometrajeActual: 167400, hasTelemetry: true, fechaInstalacionIot: DateTime(2024, 2, 18), intervaloPreventivoKm: 15000, kmUltimoPreventivo: 155000),
      Vehiculo(id: 12, placa: 'CAL-880', tipo: 'camion', marca: 'Hino', modelo: '300', idZona: 3, estadoOperativo: 'en_ruta', kilometrajeActual: 90100, hasTelemetry: false, intervaloPreventivoKm: 10000, kmUltimoPreventivo: 83000),
    ];

    final conductores = <Conductor>[
      const Conductor(id: 1, nombre: 'Mateo Silva', documento: '1010223344', telefono: '300 555 0101', licencia: 'C2', idZona: 1),
      const Conductor(id: 2, nombre: 'Camila Restrepo', documento: '1020334455', telefono: '300 555 0102', licencia: 'A2', idZona: 4),
      const Conductor(id: 3, nombre: 'Javier Ortiz', documento: '1030445566', telefono: '300 555 0103', licencia: 'C2', idZona: 1),
      const Conductor(id: 4, nombre: 'Hernando Gómez', documento: '1040556677', telefono: '300 555 0104', licencia: 'C3', idZona: 2),
      const Conductor(id: 5, nombre: 'Laura Peña', documento: '1050667788', telefono: '300 555 0105', licencia: 'C2', idZona: 2),
      const Conductor(id: 6, nombre: 'Andrés Cárdenas', documento: '1060778899', telefono: '300 555 0106', licencia: 'C1', idZona: 3),
      const Conductor(id: 7, nombre: 'Sofía Almeida', documento: '1070889900', telefono: '300 555 0107', licencia: 'C1', idZona: 3),
      const Conductor(id: 8, nombre: 'Diego Narváez', documento: '1080990011', telefono: '300 555 0108', licencia: 'C2', idZona: 4),
      const Conductor(id: 9, nombre: 'Paula Rincón', documento: '1091001122', telefono: '300 555 0109', licencia: 'C1', idZona: 1),
      const Conductor(id: 10, nombre: 'Esteban Mora', documento: '1101112233', telefono: '300 555 0110', licencia: 'C2', idZona: 2),
    ];

    final asignaciones = <AsignacionTurno>[
      AsignacionTurno(1, 1, 1, hoy),
      AsignacionTurno(2, 2, 2, hoy),
      AsignacionTurno(3, 3, 3, hoy),
      AsignacionTurno(4, 4, 4, hoy),
      AsignacionTurno(5, 5, 5, hoy),
      AsignacionTurno(6, 6, 6, hoy),
      AsignacionTurno(7, 7, 7, hoy),
      AsignacionTurno(8, 8, 8, hoy),
      AsignacionTurno(9, 9, 10, hoy),
      AsignacionTurno(10, 10, 11, hoy),
    ];

    // 400 viajes repartidos entre las asignaciones; los 4 más recientes siguen en curso.
    final viajes = <Viaje>[];
    for (var i = 0; i < 400; i++) {
      final a = asignaciones[i % asignaciones.length];
      final inicio = ahora.subtract(Duration(hours: 6 + i * 5));
      final enCurso = i < 4;
      final paradas = 8 + (i % 7);
      viajes.add(Viaje(
        id: i + 1,
        codigo: 'VJ-${1000 + i}',
        idAsignacion: a.id,
        fechaInicio: inicio,
        fechaFin: enCurso ? null : inicio.add(const Duration(hours: 5)),
        kmRecorridos: (60 + (i * 13) % 140).toDouble(),
        paradasTotales: paradas,
        paradasCompletadas: enCurso ? paradas ~/ 2 : paradas,
        estado: enCurso ? 'en_curso' : 'completado',
      ));
    }

    int? viajeDe(int idVehiculo) {
      for (final a in asignaciones) {
        if (a.idVehiculo != idVehiculo) continue;
        for (final v in viajes) {
          if (v.idAsignacion == a.id) return v.id;
        }
      }
      return null;
    }

    // Telemetría simulada: solo para vehículos con has_telemetry = true (AD-04).
    final gps = <TelemetriaGps>[
      TelemetriaGps(idVehiculo: 1, fechaHora: hace(1), lat: 4.7110, lon: -74.0721, velocidad: 64),
      TelemetriaGps(idVehiculo: 2, fechaHora: hace(2), lat: -0.1807, lon: -78.4678, velocidad: 38),
      TelemetriaGps(idVehiculo: 3, fechaHora: hace(3), lat: 4.8120, lon: -74.0350, velocidad: 0),
      TelemetriaGps(idVehiculo: 4, fechaHora: hace(1), lat: 6.2518, lon: -75.5636, velocidad: 72),
      TelemetriaGps(idVehiculo: 6, fechaHora: hace(2), lat: 3.4516, lon: -76.5320, velocidad: 51),
      TelemetriaGps(idVehiculo: 8, fechaHora: hace(1), lat: -0.2200, lon: -78.5120, velocidad: 45),
      TelemetriaGps(idVehiculo: 10, fechaHora: hace(5), lat: 4.6486, lon: -74.1100, velocidad: 0),
      TelemetriaGps(idVehiculo: 11, fechaHora: hace(2), lat: 6.2100, lon: -75.6000, velocidad: 28),
    ];

    final obd = <TelemetriaObd>[
      TelemetriaObd(idVehiculo: 1, fechaHora: hace(1), codigoFalla: null, tempMotor: 92, rpm: 2150, nivelCombustible: 78),
      TelemetriaObd(idVehiculo: 2, fechaHora: hace(2), codigoFalla: null, tempMotor: 84, rpm: 6200, nivelCombustible: 92),
      TelemetriaObd(idVehiculo: 3, fechaHora: hace(3), codigoFalla: 'P0301', tempMotor: 114, rpm: 0, nivelCombustible: 41),
      TelemetriaObd(idVehiculo: 4, fechaHora: hace(1), codigoFalla: null, tempMotor: 95, rpm: 1650, nivelCombustible: 94),
      TelemetriaObd(idVehiculo: 6, fechaHora: hace(2), codigoFalla: null, tempMotor: 89, rpm: 1900, nivelCombustible: 63),
      TelemetriaObd(idVehiculo: 8, fechaHora: hace(1), codigoFalla: 'P0087', tempMotor: 99, rpm: 2300, nivelCombustible: 55),
      TelemetriaObd(idVehiculo: 10, fechaHora: hace(5), codigoFalla: null, tempMotor: 70, rpm: 780, nivelCombustible: 88),
      TelemetriaObd(idVehiculo: 11, fechaHora: hace(2), codigoFalla: 'P0299', tempMotor: 103, rpm: 2050, nivelCombustible: 36),
    ];

    final eventos = <EventoConduccion>[
      EventoConduccion(id: 1, idVehiculo: 1, idViaje: viajeDe(1), fechaHora: hace(35), tipo: 'Frenada brusca', magnitud: 0.62, unidad: 'g', ubicacion: 'Autopista Norte km 42'),
      EventoConduccion(id: 2, idVehiculo: 1, idViaje: viajeDe(1), fechaHora: hace(190), tipo: 'Frenada brusca', magnitud: 0.48, unidad: 'g', ubicacion: 'Salida del depósito'),
      EventoConduccion(id: 3, idVehiculo: 3, idViaje: viajeDe(3), fechaHora: hace(75), tipo: 'Exceso de velocidad', magnitud: 92, unidad: 'km/h', ubicacion: 'Calle 80 con Boyacá'),
      EventoConduccion(id: 4, idVehiculo: 4, idViaje: viajeDe(4), fechaHora: hace(120), tipo: 'Aceleración brusca', magnitud: 0.41, unidad: 'g', ubicacion: 'Alto de Minas'),
      EventoConduccion(id: 5, idVehiculo: 5, idViaje: viajeDe(5), fechaHora: hace(300), tipo: 'Giro brusco', magnitud: 0.38, unidad: 'g', ubicacion: 'Bucaramanga, Carrera 27'),
      EventoConduccion(id: 6, idVehiculo: 7, idViaje: viajeDe(7), fechaHora: hace(410), tipo: 'Frenada brusca', magnitud: 0.55, unidad: 'g', ubicacion: 'Cali, Calle 5'),
      EventoConduccion(id: 7, idVehiculo: 7, idViaje: viajeDe(7), fechaHora: hace(900), tipo: 'Exceso de velocidad', magnitud: 84, unidad: 'km/h', ubicacion: 'Vía Cali–Jamundí'),
      EventoConduccion(id: 8, idVehiculo: 11, idViaje: viajeDe(11), fechaHora: hace(60), tipo: 'Giro brusco', magnitud: 0.44, unidad: 'g', ubicacion: 'Medellín, Av. Regional'),
    ];

    // Las predicciones solo existen para vehículos con telemetría (AD-05: se cargan, no se calculan).
    final predicciones = <PrediccionFalla>[
      PrediccionFalla(id: 1, idVehiculo: 1, fechaPrediccion: en(0), componente: 'Pastillas y rotor de freno delantero', probabilidad: 0.87, fechaLimiteMantenimiento: en(2)),
      PrediccionFalla(id: 2, idVehiculo: 3, fechaPrediccion: en(0), componente: 'Sistema de refrigeración', probabilidad: 0.93, fechaLimiteMantenimiento: en(1)),
      PrediccionFalla(id: 3, idVehiculo: 11, fechaPrediccion: en(-1), componente: 'Turbocompresor', probabilidad: 0.64, fechaLimiteMantenimiento: en(9)),
      PrediccionFalla(id: 4, idVehiculo: 4, fechaPrediccion: en(-2), componente: 'Alternador', probabilidad: 0.41, fechaLimiteMantenimiento: en(21)),
      PrediccionFalla(id: 5, idVehiculo: 8, fechaPrediccion: en(-3), componente: 'Embrague', probabilidad: 0.72, fechaLimiteMantenimiento: en(6), estado: 'programada', fechaProgramada: en(4), idUsuarioRevision: 1),
    ];

    final mantenimientos = <Mantenimiento>[
      Mantenimiento(id: 1, idVehiculo: 3, fecha: en(-12), origen: 'correctivo', tipoFalla: 'Falla eléctrica', descripcion: 'Cambio de batería y revisión del cableado.', kilometraje: 97500, costo: 780000, horasFueraServicio: 9, enRuta: true, idUsuarioRegistro: 1),
      Mantenimiento(id: 2, idVehiculo: 1, fecha: en(-20), origen: 'preventivo', tipoFalla: 'Preventivo programado', descripcion: 'Cambio de aceite y filtros.', kilometraje: 135000, costo: 1450000, horasFueraServicio: 5, enRuta: false, idUsuarioRegistro: 1),
      Mantenimiento(id: 3, idVehiculo: 4, fecha: en(-27), origen: 'correctivo', tipoFalla: 'Neumático', descripcion: 'Pinchazo en ruta; cambio de llanta trasera.', kilometraje: 309900, costo: 920000, horasFueraServicio: 4, enRuta: true, idUsuarioRegistro: 1),
      Mantenimiento(id: 4, idVehiculo: 9, fecha: en(-3), origen: 'correctivo', tipoFalla: 'Transmisión', descripcion: 'Ruido en caja de cambios; en revisión en taller.', kilometraje: 187600, costo: 3200000, horasFueraServicio: 52, enRuta: true, idUsuarioRegistro: 1),
      Mantenimiento(id: 5, idVehiculo: 7, fecha: en(-40), origen: 'preventivo', tipoFalla: 'Preventivo por kilometraje', descripcion: 'Cambio de aceite, frenos y alineación.', kilometraje: 108000, costo: 1100000, horasFueraServicio: 6, enRuta: false, idUsuarioRegistro: 1),
      Mantenimiento(id: 6, idVehiculo: 6, fecha: en(-55), origen: 'preventivo', tipoFalla: 'Preventivo programado', descripcion: 'Revisión general y cambio de filtros.', kilometraje: 45000, costo: 870000, horasFueraServicio: 4, enRuta: false, idUsuarioRegistro: 1),
    ];

    final clientes = <ClienteRetailer>[
      const ClienteRetailer(1, 'Éxito', 'Colombia', 'API REST', 'JSON'),
      const ClienteRetailer(2, 'Falabella', 'Colombia', 'SFTP', 'CSV'),
      const ClienteRetailer(3, 'Farmatodo', 'Colombia', 'API REST', 'JSON'),
      const ClienteRetailer(4, 'Alkosto', 'Colombia', 'Webhook', 'XML'),
      const ClienteRetailer(5, 'Jumbo', 'Colombia', 'SFTP', 'CSV'),
    ];

    const estados = [
      'a_tiempo', 'a_tiempo', 'en_camino', 'en_riesgo', 'a_tiempo',
      'a_tiempo', 'pendiente', 'en_camino', 'a_tiempo', 'a_tiempo',
      'retrasada', 'a_tiempo', 'en_riesgo', 'a_tiempo', 'pendiente',
      'a_tiempo', 'a_tiempo', 'a_tiempo', 'en_camino', 'a_tiempo',
    ];
    const ciudades = ['Bogotá', 'Medellín', 'Cali', 'Quito', 'Bogotá'];
    const calles = [
      'Calle 80 # 69-20',
      'Carrera 43A # 1-50',
      'Av. 6N # 28-10',
      'Av. Amazonas N24-15',
      'Carrera 7 # 72-41',
    ];

    final base = DateTime(ahora.year, ahora.month, ahora.day, 8);
    final ordenes = <OrdenEntrega>[];
    for (var i = 0; i < estados.length; i++) {
      final estado = estados[i];
      final promesa = base.add(Duration(minutes: 90 * i - 600));
      DateTime? real;
      if (estado == 'a_tiempo') real = promesa.subtract(Duration(minutes: 5 + (i * 7) % 20));
      if (estado == 'retrasada') real = promesa.add(const Duration(minutes: 70));
      int? idViaje;
      if (estado == 'en_camino' || estado == 'en_riesgo') {
        idViaje = (i % 4) + 1; // viajes en curso
      } else if (estado != 'pendiente') {
        idViaje = 5 + i; // viajes completados
      }
      ordenes.add(OrdenEntrega(
        id: i + 1,
        codigo: 'RV-${88291 + i}',
        idCliente: (i % 5) + 1,
        idViaje: idViaje,
        direccionDestino: calles[i % 5],
        ciudad: ciudades[i % 5],
        fechaCreacion: promesa.subtract(const Duration(hours: 20)),
        fechaPromesa: promesa,
        fechaEntregaReal: real,
        estado: estado,
      ));
    }

    return DatosIniciales(
      zonas: zonas,
      conductores: conductores,
      vehiculos: vehiculos,
      asignaciones: asignaciones,
      viajes: viajes,
      eventos: eventos,
      gps: gps,
      obd: obd,
      predicciones: predicciones,
      mantenimientos: mantenimientos,
      clientes: clientes,
      ordenes: ordenes,
    );
  }
}
