import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../dados/dados_simulados.dart';

class GraficoEnergia extends StatelessWidget {
  const GraficoEnergia({super.key});

  @override
  Widget build(BuildContext context) {
    final historico = DadosSimulados.historicoEnergia;

    if (historico.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Dados de energia indisponiveis.')),
      );
    }

    final maiorConsumo = historico.reduce(max);
    final maximoY = (maiorConsumo * 1.2).ceilToDouble();
    final intervaloY = maximoY / 4;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: maximoY,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
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
