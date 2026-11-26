import 'package:flutter_test/flutter_test.dart';
import 'package:rutaviva/models/models.dart';
import 'datos_simulados.dart';
import 'package:rutaviva/state/app_store.dart';

AppStore nuevo() => AppStore(DatosSimulados.cargar(), DatosSimulados.usuarios().first);

MantenimientoBorrador borrador({int idVehiculo = 1, String origen = 'correctivo', bool enRuta = true, int? idPrediccion}) =>
    MantenimientoBorrador(
      idVehiculo: idVehiculo,
      idPrediccion: idPrediccion,
      origen: origen,
      tipoFalla: 'Prueba',
      descripcion: '',
      kilometraje: 150000,
      costo: 100000,
      horasFuera: 3,
      enRuta: enRuta,
    );

void main() {
  test('los datos simulados respetan las llaves foráneas del modelo', () {
    final s = nuevo();
    final zonas = s.zonas.map((z) => z.id).toSet();
    final vehiculos = s.vehiculos.map((v) => v.id).toSet();
    final viajes = s.viajes.map((v) => v.id).toSet();
    final asignaciones = s.asignaciones.map((a) => a.id).toSet();
    expect(s.vehiculos.every((v) => zonas.contains(v.idZona)), isTrue);
    expect(s.asignaciones.every((a) => vehiculos.contains(a.idVehiculo)), isTrue);
    expect(s.viajes.every((v) => asignaciones.contains(v.idAsignacion)), isTrue);
    expect(s.ordenes.every((o) => o.idViaje == null || viajes.contains(o.idViaje)), isTrue);
    expect(s.predicciones.every((p) => vehiculos.contains(p.idVehiculo)), isTrue);
    expect(s.mantenimientos.every((m) => vehiculos.contains(m.idVehiculo)), isTrue);
  });

  test('AD-04: sin telemetría no hay alertas predictivas ni lecturas', () {
    final s = nuevo();
    for (final v in s.vehiculos.where((v) => !v.hasTelemetry)) {
      expect(s.alertasDe(v.id), isEmpty);
      expect(s.obdDe(v.id), isNull);
      expect(s.gpsDe(v.id), isNull);
    }
  });

  test('crear, editar y eliminar un mantenimiento', () {
    final s = nuevo();
    final antes = s.mantenimientos.length;
    final varadasAntes = s.varadas;

    s.agregarMantenimiento(borrador());
    expect(s.mantenimientos.length, antes + 1);
    expect(s.varadas, varadasAntes + 1);

    final id = s.mantenimientos.last.id;
    s.editarMantenimiento(id, borrador(origen: 'preventivo', enRuta: false));
    expect(s.mantenimientos.last.origen, 'preventivo');
    expect(s.varadas, varadasAntes);

    s.eliminarMantenimiento(id);
    expect(s.mantenimientos.length, antes);
  });

  test('un mantenimiento puede confirmar una predicción', () {
    final s = nuevo();
    s.agregarMantenimiento(borrador(idPrediccion: 1, origen: 'preventivo', enRuta: false));
    expect(s.alertas.any((p) => p.id == 1), isFalse);
  });

  test('programar y cancelar una alerta', () {
    final s = nuevo();
    s.programarAlerta(1, DateTime.now());
    expect(s.predicciones.firstWhere((p) => p.id == 1).estado, 'programada');
    s.cancelarProgramacion(1);
    expect(s.predicciones.firstWhere((p) => p.id == 1).estado, 'pendiente');
  });

  test('crear, entregar y eliminar una orden', () {
    final s = nuevo();
    final antes = s.ordenes.length;
    s.agregarOrden(OrdenBorrador(
      idCliente: 1,
      direccion: 'Calle 1 # 2-3',
      ciudad: 'Bogotá',
      fechaPromesa: DateTime.now().add(const Duration(days: 1)),
    ));
    expect(s.ordenes.length, antes + 1);
    final id = s.ordenes.last.id;

    s.marcarEntregada(id);
    expect(s.ordenes.last.estado, 'a_tiempo');

    s.eliminarOrden(id);
    expect(s.ordenes.length, antes);
  });

  test('F-02 CA-5: los indicadores se recalculan por zona', () {
    final s = nuevo();
    expect(s.otdDe(null), s.otd);
    expect(s.coberturaDe(3), closeTo(1 / 3, 1e-9)); // Cali: 1 de 3 vehículos con sensores
    final porZona = s.zonas.map((z) => s.varadasDe(z.id)).reduce((a, b) => a + b);
    expect(porZona, s.varadas);
    final viajesPorZona = s.zonas.map((z) => s.viajesDe(z.id)).reduce((a, b) => a + b);
    expect(viajesPorZona, s.viajes.length);
  });
}
