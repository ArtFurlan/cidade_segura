import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoUmidade extends StatelessWidget {
  const GraficoUmidade({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 100,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 70),
                FlSpot(1, 68),
                FlSpot(2, 72),
                FlSpot(3, 60),
                FlSpot(4, 63),
                FlSpot(5, 58),
                FlSpot(6, 65),
              ],
              isCurved: true,
              color: Colors.teal,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.teal.withValues(alpha: 0.10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
