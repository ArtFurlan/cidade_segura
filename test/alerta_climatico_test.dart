import 'package:flutter_test/flutter_test.dart';

import 'package:cidade_segura/models/alerta.dart';
import 'package:cidade_segura/services/alerta_service.dart';

void main() {
  final alertaService = AlertaService();

  group('Alertas de chuva prevista', () {
    test('Nao gera alerta com chuva abaixo de 20 mm', () {
      final alertas = alertaService.analisarPrevisaoChuva(
        chuvaAcumulada: 19.9,
        maiorChuvaHoraria: 5,
      );

      expect(alertas, isEmpty);
    });

    test('Gera alerta medio com exatamente 20 mm', () {
      final alertas = alertaService.analisarPrevisaoChuva(
        chuvaAcumulada: 20,
        maiorChuvaHoraria: 8,
      );

      expect(alertas.length, 1);
      expect(alertas.first.nivel, NivelRisco.medio);
    });

    test('Mantem alerta medio abaixo de 50 mm', () {
      final alertas = alertaService.analisarPrevisaoChuva(
        chuvaAcumulada: 49.9,
        maiorChuvaHoraria: 12,
      );

      expect(alertas.length, 1);
      expect(alertas.first.nivel, NivelRisco.medio);
    });

    test('Gera alerta alto com exatamente 50 mm', () {
      final alertas = alertaService.analisarPrevisaoChuva(
        chuvaAcumulada: 50,
        maiorChuvaHoraria: 15,
      );

      expect(alertas.length, 1);
      expect(alertas.first.nivel, NivelRisco.alto);
    });

    test('Gera alerta alto acima de 50 mm', () {
      final alertas = alertaService.analisarPrevisaoChuva(
        chuvaAcumulada: 80,
        maiorChuvaHoraria: 25,
      );

      expect(alertas.length, 1);
      expect(alertas.first.nivel, NivelRisco.alto);
      expect(alertas.first.fonte, contains('Open-Meteo'));
    });
  });

  group('Alertas climaticos atuais', () {
    test('Nao gera alertas em condicoes normais', () {
      final alertas = alertaService.analisarClima(temperatura: 25, umidade: 60);

      expect(alertas, isEmpty);
    });

    test('Gera alerta de baixa umidade abaixo de 30%', () {
      final alertas = alertaService.analisarClima(temperatura: 25, umidade: 29);

      expect(alertas.length, 1);
      expect(alertas.first.nivel, NivelRisco.medio);
      expect(alertas.first.titulo, 'Baixa umidade do ar');
    });

    test('Nao gera alerta de baixa umidade com 30%', () {
      final alertas = alertaService.analisarClima(temperatura: 25, umidade: 30);

      expect(alertas, isEmpty);
    });

    test('Gera alerta de temperatura com 35 C', () {
      final alertas = alertaService.analisarClima(temperatura: 35, umidade: 60);

      expect(alertas.length, 1);
      expect(alertas.first.nivel, NivelRisco.medio);
      expect(alertas.first.titulo, 'Temperatura elevada');
    });

    test('Gera dois alertas quando ambos os limites sao ultrapassados', () {
      final alertas = alertaService.analisarClima(temperatura: 38, umidade: 20);

      expect(alertas.length, 2);
    });
  });
}
