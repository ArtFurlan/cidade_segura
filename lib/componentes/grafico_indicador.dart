import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../dados/dados_simulados.dart';

class GraficoIndicador extends StatelessWidget {
  const GraficoIndicador({super.key});

  @override
  Widget build(BuildContext context) {
    final historico = DadosSimulados.historicoAgua;

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 1600,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                historico.length,
                (index) => FlSpot(index.toDouble(), historico[index]),
              ),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withValues(alpha: 0.10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
