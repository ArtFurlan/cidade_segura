import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoTemperatura extends StatelessWidget {
  const GraficoTemperatura({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 35,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 25),
                FlSpot(1, 27),
                FlSpot(2, 26),
                FlSpot(3, 30),
                FlSpot(4, 29),
                FlSpot(5, 31),
                FlSpot(6, 28),
              ],
              isCurved: true,
              color: Colors.deepOrange,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.deepOrange.withValues(alpha: 0.10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
