import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_segura/main.dart';

void main() {
  testWidgets('Verifica a tela inicial', (WidgetTester tester) async {
    await tester.pumpWidget(const CidadeSeguraApp());

    expect(find.text('Cidade Segura'), findsWidgets);
    expect(find.text('Painel geral da cidade'), findsOneWidget);
  });
}
