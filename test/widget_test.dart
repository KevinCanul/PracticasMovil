import 'package:flutter_test/flutter_test.dart';
import 'package:practica_08_geolocalizacion/main.dart';

void main() {
  testWidgets('La aplicación muestra la pantalla principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiAplicacion());

    expect(find.text('Puntos de Interés GPS'), findsOneWidget);
    expect(find.text('Mi ubicación actual'), findsOneWidget);
    expect(find.text('Obtener ubicación'), findsOneWidget);
  });
}
