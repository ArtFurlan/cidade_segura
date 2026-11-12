import 'package:flutter/material.dart';

import '../services/clima_service.dart';

class ClimaProvider extends ChangeNotifier {
  final ClimaService climaService = ClimaService();

  Map<String, dynamic>? dadosClima;

  bool carregando = false;
  String? erro;

  double? get temperatura {
    final valor = dadosClima?['temperatura'];

    if (valor is num) {
      return valor.toDouble();
    }

    return null;
  }

  int? get umidade {
    final valor = dadosClima?['umidade'];

    if (valor is num) {
      return valor.round();
    }

    return null;
  }

  String? get horario {
    return dadosClima?['horario']?.toString();
  }

  Future<void> atualizarClima() async {
    if (carregando) return;

    carregando = true;
    erro = null;
    notifyListeners();

    try {
      dadosClima = await climaService.buscarClima();
    } catch (e) {
      erro = 'Nao foi possivel carregar os dados do clima.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
