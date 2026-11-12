import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cidade_segura/main.dart';
import 'package:cidade_segura/providers/clima_provider.dart';

void main() {
  testWidgets('Verifica a tela inicial', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ClimaProvider>(
        create: (context) => ClimaProvider(),
        child: const CidadeSeguraApp(),
      ),
    );

    expect(find.text('Visao geral'), findsOneWidget);

    expect(find.text('Consumo de agua'), findsOneWidget);
    expect(find.text('Consumo de energia'), findsOneWidget);
    expect(find.text('Temperatura'), findsOneWidget);
    expect(find.text('Umidade do ar'), findsOneWidget);
    expect(find.text('Alertas ativos'), findsOneWidget);
  });
}
