import 'dart:convert';

import 'package:http/http.dart' as http;

class HistoricoClimaService {
  Future<Map<String, dynamic>> buscarHistorico() async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=-23.55'
      '&longitude=-46.63'
      '&hourly=temperature_2m,relative_humidity_2m'
      '&past_days=7'
      '&forecast_days=0'
      '&timezone=America%2FSao_Paulo',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao consultar historico climatico');
    }

    final dados = jsonDecode(resposta.body);
    final horarios = dados['hourly']['time'] as List;
    final temperaturas = dados['hourly']['temperature_2m'] as List;
    final umidades = dados['hourly']['relative_humidity_2m'] as List;

    final Map<String, List<double>> temperaturasPorDia = {};
    final Map<String, List<double>> umidadesPorDia = {};

    for (int i = 0; i < horarios.length; i++) {
      final data = horarios[i].toString().substring(0, 10);
      final temperatura = temperaturas[i];
      final umidade = umidades[i];

      if (temperatura is num && umidade is num) {
        temperaturasPorDia.putIfAbsent(data, () => []);
        umidadesPorDia.putIfAbsent(data, () => []);

        temperaturasPorDia[data]!.add(temperatura.toDouble());
        umidadesPorDia[data]!.add(umidade.toDouble());
      }
    }

    final datas = temperaturasPorDia.keys.toList()..sort();

    final mediasTemperatura = <double>[];
    final mediasUmidade = <double>[];

    for (final data in datas) {
      final listaTemperaturas = temperaturasPorDia[data]!;
      final listaUmidades = umidadesPorDia[data]!;

      final mediaTemperatura =
          listaTemperaturas.reduce((a, b) => a + b) / listaTemperaturas.length;

      final mediaUmidade =
          listaUmidades.reduce((a, b) => a + b) / listaUmidades.length;

      mediasTemperatura.add(mediaTemperatura);
      mediasUmidade.add(mediaUmidade);
    }

    return {
      'datas': datas,
      'temperaturas': mediasTemperatura,
      'umidades': mediasUmidade,
    };
  }
}
