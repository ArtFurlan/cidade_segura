import 'dart:convert';

import 'package:http/http.dart' as http;

class ClimaService {
  Future<Map<String, dynamic>> buscarClima() async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=-23.55'
      '&longitude=-46.63'
      '&current=temperature_2m,relative_humidity_2m'
      '&timezone=America%2FSao_Paulo',
    );

    final resposta = await http.get(url).timeout(const Duration(seconds: 15));

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;

      final atual = dados['current'] as Map<String, dynamic>;

      return {
        'temperatura': atual['temperature_2m'],
        'umidade': atual['relative_humidity_2m'],
        'horario': atual['time'],
      };
    } else {
      throw Exception('Erro ao buscar dados do clima');
    }
  }
}
