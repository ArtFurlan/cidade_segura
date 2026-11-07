import 'package:flutter_test/flutter_test.dart';
import 'package:cidade_segura/services/alerta_service.dart';
import 'package:cidade_segura/models/alerta.dart';

void main() {
  final alertaService = AlertaService();

  test('Calcula a estimativa do proximo consumo de agua', () {
    final historico = [1050.0, 1100.0, 1160.0, 1200.0, 1250.0, 1310.0, 1380.0];

    final estimativa = alertaService.estimarProximoConsumo(historico);

    expect(estimativa, closeTo(1435, 0.01));
  });

  test('Gera alerta de tendencia para agua', () {
    final alertas = alertaService.analisarTendencias(
      historicoAgua: [1050, 1100, 1160, 1200, 1250, 1310, 1380],
      historicoEnergia: [2900, 3000, 3100, 3200, 3300, 3400, 3500],
    );

    expect(alertas.length, 1);
    expect(alertas.first.nivel, NivelRisco.alto);
    expect(alertas.first.titulo, contains('agua'));
  });

  test('Nao gera alertas quando a tendencia fica abaixo do limite', () {
    final alertas = alertaService.analisarTendencias(
      historicoAgua: [1100, 1250, 1180, 1400, 1320, 1500, 1250],
      historicoEnergia: [2900, 3200, 3100, 3700, 3500, 4100, 3480],
    );

    expect(alertas, isEmpty);
  });

  test('Gera alerta quando o consumo atual ultrapassa o limite', () {
    final alertas = alertaService.analisarIndicadores(
      consumoAgua: 1500,
      consumoEnergia: 4200,
    );

    expect(alertas.length, 2);
    expect(alertas[0].nivel, NivelRisco.alto);
    expect(alertas[1].nivel, NivelRisco.alto);
  });
}
