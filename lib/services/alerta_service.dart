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
}
