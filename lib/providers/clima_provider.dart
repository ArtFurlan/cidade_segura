import 'package:flutter/material.dart';

import '../services/clima_service.dart';
import '../services/historico_clima_service.dart';
import '../services/previsao_chuva_service.dart';

class ClimaProvider extends ChangeNotifier {
  final ClimaService climaService = ClimaService();
  final HistoricoClimaService historicoService = HistoricoClimaService();
  final PrevisaoChuvaService previsaoService = PrevisaoChuvaService();

  Map<String, dynamic>? dadosClima;
  Map<String, dynamic>? dadosHistoricos;
  Map<String, dynamic>? dadosPrevisao;

  bool carregando = false;
  bool carregandoHistorico = false;
  bool carregandoPrevisao = false;

  String? erro;
  String? erroHistorico;
  String? erroPrevisao;

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

  List<String> get datasHistoricas {
    final datas = dadosHistoricos?['datas'];

    if (datas is List<String>) {
      return datas;
    }

    return [];
  }

  List<double> get temperaturasHistoricas {
    final temperaturas = dadosHistoricos?['temperaturas'];

    if (temperaturas is List<double>) {
      return temperaturas;
    }

    return [];
  }

  List<double> get umidadesHistoricas {
    final umidades = dadosHistoricos?['umidades'];

    if (umidades is List<double>) {
      return umidades;
    }

    return [];
  }

  double? get chuvaAcumulada {
    final valor = dadosPrevisao?['chuvaAcumulada'];

    if (valor is num) {
      return valor.toDouble();
    }

    return null;
  }

  double? get maiorChuvaHoraria {
    final valor = dadosPrevisao?['maiorChuvaHoraria'];

    if (valor is num) {
      return valor.toDouble();
    }

    return null;
  }

  int? get horasAnalisadas {
    final valor = dadosPrevisao?['horasAnalisadas'];

    if (valor is num) {
      return valor.toInt();
    }

    return null;
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

  Future<void> atualizarHistorico() async {
    if (carregandoHistorico) return;

    carregandoHistorico = true;
    erroHistorico = null;
    notifyListeners();

    try {
      dadosHistoricos = await historicoService.buscarHistorico();
    } catch (e) {
      erroHistorico = 'Nao foi possivel carregar o historico climatico.';
    } finally {
      carregandoHistorico = false;
      notifyListeners();
    }
  }

  Future<void> atualizarPrevisao() async {
    if (carregandoPrevisao) return;

    carregandoPrevisao = true;
    erroPrevisao = null;
    notifyListeners();

    try {
      dadosPrevisao = await previsaoService.buscarPrevisao();
    } catch (e) {
      erroPrevisao = 'Nao foi possivel carregar a previsao de chuva.';
    } finally {
      carregandoPrevisao = false;
      notifyListeners();
    }
  }
}
