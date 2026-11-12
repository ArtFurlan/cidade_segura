import 'dart:convert';

import 'package:http/http.dart' as http;

class PrevisaoChuvaService {
  Future<Map<String, dynamic>> buscarPrevisao() async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=-23.55'
      '&longitude=-46.63'
      '&hourly=precipitation'
      '&forecast_hours=24'
      '&timezone=America%2FSao_Paulo',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao consultar previsao de chuva');
    }

    final dados = jsonDecode(resposta.body);

    final horarios = dados['hourly']['time'] as List;
    final precipitacoes = dados['hourly']['precipitation'] as List;

    if (horarios.length != 24 || precipitacoes.length != 24) {
      throw Exception('Previsao incompleta');
    }

    double chuvaAcumulada = 0;
    double maiorChuvaHoraria = 0;

    for (final valor in precipitacoes) {
      if (valor is! num) {
        throw Exception('Valor de precipitacao indisponivel');
      }

      final chuva = valor.toDouble();

      if (!chuva.isFinite || chuva < 0) {
        throw Exception('Valor de precipitacao invalido');
      }

      chuvaAcumulada += chuva;

      if (chuva > maiorChuvaHoraria) {
        maiorChuvaHoraria = chuva;
      }
    }

    return {
      'chuvaAcumulada': chuvaAcumulada,
      'maiorChuvaHoraria': maiorChuvaHoraria,
      'horasAnalisadas': precipitacoes.length,
      'periodo': 'Proximas 24 horas',
      'inicioPrevisao': horarios.first.toString(),
      'fimPrevisao': horarios.last.toString(),
    };
  }
}
