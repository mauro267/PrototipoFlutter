import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rutaviva/pages/login_page.dart';
import 'package:rutaviva/utils/format.dart';

void main() {
  test('formato es-CO', () {
    expect(fmtEntero(1234567), '1.234.567');
    expect(fmtDec(1234.5, 1), '1.234,5');
    expect(fmtPct(0.923), '92,3 %');
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
