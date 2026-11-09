import 'package:flutter_test/flutter_test.dart';
import 'package:rutaviva/main.dart';
import 'package:rutaviva/utils/format.dart';

void main() {
  test('formato es-CO', () {
    expect(fmtEntero(1234567), '1.234.567');
    expect(fmtDec(1234.5, 1), '1.234,5');
    expect(fmtPct(0.923), '92,3 %');
  });

  testWidgets('inicia sesión y llega al panel de flota', (tester) async {
    await tester.pumpWidget(const RutaVivaApp());
    expect(find.text('Inicia sesión'), findsOneWidget);

    await tester.tap(find.text('Ingresar a Operaciones'));
    await tester.pumpAndSettle();
    expect(find.text('Panel de flota'), findsWidgets);
  });
}
