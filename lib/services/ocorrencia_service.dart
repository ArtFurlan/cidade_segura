import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class OcorrenciaService {
  static const String chave = 'ocorrencias_cidade_segura';

  Future<void> salvarOcorrencias(List<Map<String, String>> ocorrencias) async {
    final preferencias = await SharedPreferences.getInstance();

    final dados = jsonEncode(ocorrencias);

    final sucesso = await preferencias.setString(chave, dados);

    if (!sucesso) {
      throw Exception('Nao foi possivel salvar as ocorrencias');
    }
  }

  Future<List<Map<String, String>>> carregarOcorrencias() async {
    final preferencias = await SharedPreferences.getInstance();

    final dados = preferencias.getString(chave);

    if (dados == null) {
      return [];
    }

    final lista = jsonDecode(dados) as List<dynamic>;

    return lista.map((item) {
      return Map<String, String>.from(item as Map);
    }).toList();
  }
}
