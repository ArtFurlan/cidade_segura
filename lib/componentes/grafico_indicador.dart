import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../dados/dados_simulados.dart';

class GraficoIndicador extends StatelessWidget {
  const GraficoIndicador({super.key});

  @override
  Widget build(BuildContext context) {
    final historico = DadosSimulados.historicoAgua;

    if (historico.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Dados de consumo indisponiveis.')),
      );
    }

    final maiorConsumo = historico.reduce(max);
    final maximoY = (maiorConsumo * 1.2).ceilToDouble();
    final intervaloY = maximoY / 4;

    final pontos = List.generate(
      historico.length,
      (index) => FlSpot(index.toDouble(), historico[index]),
    );

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (historico.length - 1).toDouble(),
          minY: 0,
          maxY: maximoY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: intervaloY,
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                interval: intervaloY,
                minIncluded: true,
                maxIncluded: true,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    space: 6,
                    child: Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                minIncluded: true,
                maxIncluded: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 ||
                      index >= historico.length ||
                      value != index.toDouble()) {
                    return const SizedBox.shrink();
                  }

                  return SideTitleWidget(
                    meta: meta,
                    space: 8,
                    child: Text(
                      'D${index + 1}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: pontos,
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
