import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../providers/clima_provider.dart';

class GraficoUmidade extends StatelessWidget {
  const GraficoUmidade({super.key});

  @override
  Widget build(BuildContext context) {
    final climaProvider = context.watch<ClimaProvider>();

    final umidades = climaProvider.umidadesHistoricas;
    final datas = climaProvider.datasHistoricas;

    if (climaProvider.carregandoHistorico && umidades.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (umidades.isEmpty || datas.isEmpty || umidades.length != datas.length) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            climaProvider.erroHistorico ?? 'Historico de umidade indisponivel.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final pontos = List.generate(
      umidades.length,
      (index) => FlSpot(index.toDouble(), umidades[index]),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final mostrarTodasDatas = constraints.maxWidth >= 500;

        return SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (umidades.length - 1).toDouble(),
              minY: 0,
              maxY: 100,
              gridData: const FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 20,
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
                    interval: 20,
                    minIncluded: true,
                    maxIncluded: true,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        meta: meta,
                        space: 6,
                        child: Text(
                          '${value.toStringAsFixed(0)}%',
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
      },
    );
  }
}
