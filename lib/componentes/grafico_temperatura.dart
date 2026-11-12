import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../providers/clima_provider.dart';

class GraficoTemperatura extends StatelessWidget {
  const GraficoTemperatura({super.key});

  @override
  Widget build(BuildContext context) {
    final climaProvider = context.watch<ClimaProvider>();

    final temperaturas = climaProvider.temperaturasHistoricas;
    final datas = climaProvider.datasHistoricas;

    if (climaProvider.carregandoHistorico && temperaturas.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (temperaturas.isEmpty ||
        datas.isEmpty ||
        temperaturas.length != datas.length) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text(
            climaProvider.erroHistorico ??
                'Historico de temperatura indisponivel.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final menorTemperatura = temperaturas.reduce(min);
    final maiorTemperatura = temperaturas.reduce(max);

    final minimoY = (menorTemperatura - 3).floorToDouble();
    final maximoY = (maiorTemperatura + 3).ceilToDouble();

    final intervaloY = max(1, ((maximoY - minimoY) / 4).ceil()).toDouble();

    final pontos = List.generate(
      temperaturas.length,
      (index) => FlSpot(index.toDouble(), temperaturas[index]),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final mostrarTodasDatas = constraints.maxWidth >= 500;

        return SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (temperaturas.length - 1).toDouble(),
              minY: minimoY,
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
                    reservedSize: 42,
                    interval: intervaloY,
                    minIncluded: false,
                    maxIncluded: false,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        meta: meta,
                        space: 6,
                        child: Text(
                          '${value.toStringAsFixed(0)} C',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
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
                          index >= datas.length ||
                          value != index.toDouble()) {
                        return const SizedBox.shrink();
                      }

                      if (!mostrarTodasDatas &&
                          index.isOdd &&
                          index != datas.length - 1) {
                        return const SizedBox.shrink();
                      }

                      final partes = datas[index].split('-');

                      if (partes.length != 3) {
                        return const SizedBox.shrink();
                      }

                      final data = '${partes[2]}/${partes[1]}';

                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          data,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
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
      },
    );
  }
}
