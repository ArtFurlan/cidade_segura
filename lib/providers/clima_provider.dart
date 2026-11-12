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

  DateTime? ultimaAtualizacaoClima;
  DateTime? ultimaAtualizacaoHistorico;
  DateTime? ultimaAtualizacaoPrevisao;

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

  bool get climaDesatualizado {
    return verificarDesatualizacao(
      ultimaAtualizacaoClima,
      const Duration(minutes: 30),
      erro,
    );
  }

  bool get historicoDesatualizado {
    return verificarDesatualizacao(
      ultimaAtualizacaoHistorico,
      const Duration(hours: 24),
      erroHistorico,
    );
  }

  bool get previsaoDesatualizada {
    return verificarDesatualizacao(
      ultimaAtualizacaoPrevisao,
      const Duration(minutes: 60),
      erroPrevisao,
    );
  }

  bool verificarDesatualizacao(
    DateTime? ultimaAtualizacao,
    Duration validade,
    String? erroConsulta,
  ) {
    if (ultimaAtualizacao == null || erroConsulta != null) {
      return true;
    }

    final tempoDecorrido = DateTime.now().difference(ultimaAtualizacao);

    return tempoDecorrido.isNegative || tempoDecorrido >= validade;
  }

  String formatarAtualizacao(DateTime? data) {
    if (data == null) {
      return 'Nunca atualizado';
    }

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');

    return '$dia/$mes $hora:$minuto';
  }

  String get horarioAtualizacaoClima {
    return formatarAtualizacao(ultimaAtualizacaoClima);
  }

  String get horarioAtualizacaoHistorico {
    return formatarAtualizacao(ultimaAtualizacaoHistorico);
  }

  String get horarioAtualizacaoPrevisao {
    return formatarAtualizacao(ultimaAtualizacaoPrevisao);
  }

  Future<void> atualizarClima() async {
    if (carregando) return;

    carregando = true;
    erro = null;
    notifyListeners();

    try {
      final novosDados = await climaService.buscarClima();

      dadosClima = novosDados;
      ultimaAtualizacaoClima = DateTime.now();
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
      final novosDados = await historicoService.buscarHistorico();

      dadosHistoricos = novosDados;
      ultimaAtualizacaoHistorico = DateTime.now();
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
      final novosDados = await previsaoService.buscarPrevisao();

      dadosPrevisao = novosDados;
      ultimaAtualizacaoPrevisao = DateTime.now();
    } catch (e) {
      erroPrevisao = 'Nao foi possivel carregar a previsao de chuva.';
    } finally {
      carregandoPrevisao = false;
      notifyListeners();
    }
  }
}
