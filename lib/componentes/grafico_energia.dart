import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoEnergia extends StatelessWidget {
  const GraficoEnergia({super.key});

  @override
  Widget build(BuildContext context) {
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
          barGroups: [
            criarBarra(0, 2900),
            criarBarra(1, 3200),
            criarBarra(2, 3100),
            criarBarra(3, 3700),
            criarBarra(4, 3500),
            criarBarra(5, 4100),
            criarBarra(6, 3480),
          ],
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
