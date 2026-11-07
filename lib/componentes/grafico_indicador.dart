import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoIndicador extends StatelessWidget {
  const GraficoIndicador({super.key});

  @override
  Widget build(BuildContext context) {
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
              spots: const [
                FlSpot(0, 1100),
                FlSpot(1, 1250),
                FlSpot(2, 1180),
                FlSpot(3, 1400),
                FlSpot(4, 1320),
                FlSpot(5, 1500),
                FlSpot(6, 1250),
              ],
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
