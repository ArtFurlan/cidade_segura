import '../models/alerta.dart';

class AlertaService {
  List<Alerta> analisarIndicadores({
    required double consumoAgua,
    required double consumoEnergia,
  }) {
    final List<Alerta> alertas = [];

    if (consumoAgua > 1400) {
      alertas.add(
        const Alerta(
          titulo: 'Consumo elevado de agua',
          nivel: NivelRisco.alto,
          confianca: ConfiancaAlerta.baixa,
          justificativa: 'O consumo ultrapassou 1400 m3 nas ultimas 24 horas.',
          limitacao:
              'Os dados sao simulados e o limite e ilustrativo. '
              'O alerta nao confirma vazamentos.',
          recomendacao:
              'Verificar os registros e investigar possiveis desperdicios.',
          fonte: 'Dados simulados',
        ),
      );
    } else if (consumoAgua > 1200) {
      alertas.add(
        const Alerta(
          titulo: 'Consumo de agua acima do limite',
          nivel: NivelRisco.medio,
          confianca: ConfiancaAlerta.baixa,
          justificativa: 'O consumo ultrapassou 1200 m3 nas ultimas 24 horas.',
          limitacao:
              'Os dados e os limites sao simulados. '
              'Nao e possivel confirmar a causa do aumento.',
          recomendacao: 'Acompanhar o consumo e comparar com outros periodos.',
          fonte: 'Dados simulados',
        ),
      );
    }

    if (consumoEnergia > 4000) {
      alertas.add(
        const Alerta(
          titulo: 'Consumo elevado de energia',
          nivel: NivelRisco.alto,
          confianca: ConfiancaAlerta.baixa,
          justificativa: 'O consumo ultrapassou 4000 kWh nas ultimas 24 horas.',
          limitacao: 'Os dados sao simulados e nao consideram sazonalidade.',
          recomendacao: 'Verificar os registros de consumo da regiao.',
          fonte: 'Dados simulados',
        ),
      );
    } else if (consumoEnergia > 3200) {
      alertas.add(
        const Alerta(
          titulo: 'Aumento no consumo de energia',
          nivel: NivelRisco.medio,
          confianca: ConfiancaAlerta.baixa,
          justificativa: 'O consumo ultrapassou 3200 kWh nas ultimas 24 horas.',
          limitacao:
              'Os dados e os limites sao simulados. '
              'O aumento nao indica necessariamente uma falha.',
          recomendacao: 'Acompanhar o consumo antes de tomar qualquer decisao.',
          fonte: 'Dados simulados',
        ),
      );
    }

    return alertas;
  }

  double estimarProximoConsumo(List<double> historico) {
    if (historico.length < 2) {
      throw ArgumentError('Informe pelo menos dois valores.');
    }

    final primeiro = historico.first;
    final ultimo = historico.last;

    final variacaoMedia = (ultimo - primeiro) / (historico.length - 1);

    final estimativa = ultimo + variacaoMedia;

    return estimativa < 0 ? 0 : estimativa;
  }

  List<Alerta> analisarTendencias({
    required List<double> historicoAgua,
    required List<double> historicoEnergia,
  }) {
    final List<Alerta> alertas = [];

    final estimativaAgua = estimarProximoConsumo(historicoAgua);
    final estimativaEnergia = estimarProximoConsumo(historicoEnergia);

    if (historicoAgua.last <= 1400 && estimativaAgua > 1400) {
      alertas.add(
        Alerta(
          titulo: 'Tendencia de consumo elevado de agua',
          nivel: NivelRisco.alto,
          confianca: ConfiancaAlerta.baixa,
          justificativa:
              'A estimativa para o proximo dia e de '
              '${estimativaAgua.toStringAsFixed(0)} m3, '
              'acima do limite ilustrativo de 1400 m3.',
          limitacao:
              'Estimativa baseada na variacao media entre o primeiro '
              'e o ultimo dia. Nao considera sazonalidade, '
              'clima ou mudancas no comportamento do consumo.',
          recomendacao:
              'Acompanhar os proximos registros e verificar '
              'a tendencia antes de tomar medidas.',
          fonte: 'Historico simulado de consumo de agua',
        ),
      );
    }

    if (historicoEnergia.last <= 4000 && estimativaEnergia > 4000) {
      alertas.add(
        Alerta(
          titulo: 'Tendencia de consumo elevado de energia',
          nivel: NivelRisco.alto,
          confianca: ConfiancaAlerta.baixa,
          justificativa:
              'A estimativa para o proximo dia e de '
              '${estimativaEnergia.toStringAsFixed(0)} kWh, '
              'acima do limite ilustrativo de 4000 kWh.',
          limitacao:
              'Estimativa baseada em dados simulados. '
              'Nao considera sazonalidade, temperatura '
              'ou eventos extraordinarios.',
          recomendacao:
              'Monitorar o consumo e comparar a estimativa '
              'com os registros dos proximos dias.',
          fonte: 'Historico simulado de consumo de energia',
        ),
      );
    }

    return alertas;
  }

  List<Alerta> analisarClima({
    required double temperatura,
    required int umidade,
  }) {
    final List<Alerta> alertas = [];

    if (umidade < 30) {
      alertas.add(
        Alerta(
          titulo: 'Baixa umidade do ar',
          nivel: NivelRisco.medio,
          confianca: ConfiancaAlerta.baixa,
          justificativa:
              'A umidade atual informada pela Open-Meteo e de '
              '$umidade%, abaixo do limite ilustrativo de 30%.',
          limitacao:
              'O valor e uma estimativa meteorologica. '
              'O limite foi definido para demonstracao e '
              'nao representa uma classificacao oficial de risco.',
          recomendacao:
              'Acompanhar as atualizacoes meteorologicas '
              'e consultar orientacoes de fontes oficiais.',
          fonte: 'Open-Meteo - umidade atual',
        ),
      );
    }

    if (temperatura >= 35) {
      alertas.add(
        Alerta(
          titulo: 'Temperatura elevada',
          nivel: NivelRisco.medio,
          confianca: ConfiancaAlerta.baixa,
          justificativa:
              'A temperatura atual informada pela Open-Meteo e de '
              '${temperatura.toStringAsFixed(1)} C, '
              'atingindo o limite ilustrativo de 35 C.',
          limitacao:
              'O alerta considera apenas a temperatura atual. '
              'Nao avalia indice de calor, duracao da exposicao '
              'ou condicoes individuais de vulnerabilidade.',
          recomendacao:
              'Monitorar as condicoes meteorologicas '
              'e consultar orientacoes oficiais sobre calor.',
          fonte: 'Open-Meteo - temperatura atual',
        ),
      );
    }

    return alertas;
  }

  List<Alerta> analisarPrevisaoChuva({
    required double chuvaAcumulada,
    required double maiorChuvaHoraria,
  }) {
    final List<Alerta> alertas = [];

    if (chuvaAcumulada >= 50) {
      alertas.add(
        Alerta(
          titulo: 'Previsao de chuva acumulada elevada',
          nivel: NivelRisco.alto,
          confianca: ConfiancaAlerta.baixa,
          justificativa:
              'A Open-Meteo preve '
              '${chuvaAcumulada.toStringAsFixed(1)} mm '
              'de precipitacao acumulada nas proximas 24 horas. '
              'A maior precipitacao horaria prevista e de '
              '${maiorChuvaHoraria.toStringAsFixed(1)} mm.',
          limitacao:
              'O limite de 50 mm e ilustrativo. '
              'A previsao pode mudar e o acumulado de chuva '
              'nao determina sozinho o risco de alagamento.',
          recomendacao:
              'Acompanhar as previsoes oficiais e avaliar '
              'as condicoes locais antes de qualquer medida.',
          fonte: 'Open-Meteo - previsao de precipitacao',
        ),
      );
    } else if (chuvaAcumulada >= 20) {
      alertas.add(
        Alerta(
          titulo: 'Previsao de chuva acima do limite',
          nivel: NivelRisco.medio,
          confianca: ConfiancaAlerta.baixa,
          justificativa:
              'A Open-Meteo preve '
              '${chuvaAcumulada.toStringAsFixed(1)} mm '
              'de chuva nas proximas 24 horas. '
              'O maior valor horario previsto e de '
              '${maiorChuvaHoraria.toStringAsFixed(1)} mm.',
          limitacao:
              'O limite de 20 mm foi definido para demonstracao. '
              'A intensidade da chuva e as condicoes locais '
              'podem alterar seus impactos.',
          recomendacao:
              'Monitorar a evolucao da previsao '
              'e verificar comunicados meteorologicos oficiais.',
          fonte: 'Open-Meteo - previsao de precipitacao',
        ),
      );
    }

    return alertas;
  }
}
