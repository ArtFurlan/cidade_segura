import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../dados/dados_simulados.dart';

class GraficoEnergia extends StatelessWidget {
  const GraficoEnergia({super.key});

  @override
  Widget build(BuildContext context) {
    final historico = DadosSimulados.historicoEnergia;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 4500,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(
            historico.length,
            (index) => criarBarra(index, historico[index]),
          ),
        ),
      ),
    );
  }

  BarChartGroupData criarBarra(int dia, double consumo) {
    return BarChartGroupData(
      x: dia,
      barRods: [
        BarChartRodData(
          toY: consumo,
          color: Colors.orange,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
