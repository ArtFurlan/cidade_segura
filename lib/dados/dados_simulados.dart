class DadosSimulados {
  static const List<double> historicoAgua = [
    1100,
    1250,
    1180,
    1400,
    1320,
    1500,
    1250,
  ];

  static const List<double> historicoEnergia = [
    2900,
    3200,
    3100,
    3700,
    3500,
    4100,
    3480,
  ];

  static double get consumoAguaAtual {
    return historicoAgua.last;
  }

  static double get consumoEnergiaAtual {
    return historicoEnergia.last;
  }
}
