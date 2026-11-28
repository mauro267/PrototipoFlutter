import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rutaviva/components/formulario_mantenimiento.dart';
import 'package:rutaviva/models/models.dart';
import 'package:rutaviva/pages/login_page.dart';
import 'package:rutaviva/utils/format.dart';

void main() {
  test('formato es-CO', () {
    expect(fmtEntero(1234567), '1.234.567');
    expect(fmtDec(1234.5, 1), '1.234,5');
    expect(fmtPct(0.923), '92,3 %');
  });

  testWidgets('T-16 / CA-2: correctivo sin tipo de falla no se guarda y muestra Obligatorio', (tester) async {
    var guardado = false;
    final vehiculos = [
      Vehiculo(
        id: 1,
        placa: 'CAL-311',
        tipo: 'Van',
        marca: 'Chevrolet',
        modelo: 'N300',
        idZona: 1,
        estadoOperativo: 'operativo',
        kilometrajeActual: 100000,
        hasTelemetry: true,
        intervaloPreventivoKm: 10000,
        kmUltimoPreventivo: 90000,
      )
    ];

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => mostrarFormularioMantenimiento(
            context,
            vehiculos: vehiculos,
            alertas: [],
            onGuardar: (_) async {
              guardado = true;
              return true;
            },
          ),
          child: const Text('Abrir'),
        ),
      ),
    ));

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    // Cambiar a Correctivo
    await tester.tap(find.text('Preventivo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Correctivo').last);
    await tester.pumpAndSettle();

    // Rellenar costo y horas para probar exclusivamente la validación del tipo de falla
    final camposTexto = find.byType(TextField);
    // campos: [0] tipoFalla, [1] descripcion, [2] km (ya tiene 100000), [3] costo, [4] horas
    await tester.enterText(camposTexto.at(3), '500000');
    await tester.enterText(camposTexto.at(4), '4');
    await tester.pumpAndSettle();

    // Intentar guardar con tipo de falla vacío
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Obligatorio'), findsOneWidget);
    expect(guardado, isFalse);
  });

  // El flujo completo de inicio de sesión necesita Supabase; aquí se prueba la Page sola.
  testWidgets('la Page de inicio de sesión deshabilita el botón mientras carga', (tester) async {
    var creada = false;
    Widget page(bool cargando) => MaterialApp(
          home: Scaffold(
            body: LoginPage(
              formKey: GlobalKey<FormState>(),
              correo: TextEditingController(),
              clave: TextEditingController(),
              verClave: false,
              error: 'Correo o contraseña incorrectos.',
              cargando: cargando,
              onAlternarClave: () {},
              onEntrar: () {},
              onCrearCuenta: () => creada = true,
            ),
          ),
        );

    await tester.pumpWidget(page(false));
    expect(find.text('Inicia sesión'), findsOneWidget);
    expect(find.text('Correo o contraseña incorrectos.'), findsOneWidget);
    await tester.tap(find.text('¿No tienes cuenta? Crea una'));
    expect(creada, isTrue);

    await tester.pumpWidget(page(true));
    expect(find.text('Validando…'), findsOneWidget);
  });
}
