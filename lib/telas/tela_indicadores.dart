import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dados/dados_simulados.dart';
import '../componentes/grafico_indicador.dart';
import '../componentes/grafico_energia.dart';
import '../componentes/grafico_temperatura.dart';
import '../componentes/grafico_umidade.dart';
import '../providers/clima_provider.dart';

class TelaIndicadores extends StatelessWidget {
  const TelaIndicadores({super.key});

  @override
  Widget build(BuildContext context) {
    final climaProvider = context.watch<ClimaProvider>();

    final consumoAgua = DadosSimulados.consumoAguaAtual;
    final consumoEnergia = DadosSimulados.consumoEnergiaAtual;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Indicadores da cidade',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF142B49),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Acompanhe os recursos e as condicoes ambientais.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Agua e energia: dados simulados',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),
          CartaoDetalhado(
            titulo: 'Consumo de agua',
            valor: '${consumoAgua.toStringAsFixed(0)} m3',
            descricao: 'Consumo simulado nas ultimas 24 horas',
            icone: Icons.water_drop,
            cor: Colors.blue,
          ),
          const SizedBox(height: 16),
          CartaoDetalhado(
            titulo: 'Consumo de energia',
            valor: '${consumoEnergia.toStringAsFixed(0)} kWh',
            descricao: 'Consumo simulado nas ultimas 24 horas',
            icone: Icons.bolt,
            cor: Colors.orange,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Clima em Sao Paulo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF142B49),
                  ),
                ),
              ),
              IconButton(
                onPressed:
                    climaProvider.carregando ||
                        climaProvider.carregandoHistorico
                    ? null
                    : () {
                        final provider = context.read<ClimaProvider>();
                        provider.atualizarClima();
                        provider.atualizarHistorico();
                      },
                icon: const Icon(Icons.refresh),
                tooltip: 'Atualizar dados climaticos',
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Dados meteorologicos da API Open-Meteo',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 16),
          if (climaProvider.carregando && climaProvider.dadosClima == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(),
              ),
            )
          else if (climaProvider.dadosClima == null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    const Text('Nao foi possivel carregar o clima.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: climaProvider.carregando
                          ? null
                          : () {
                              context.read<ClimaProvider>().atualizarClima();
                            },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atualizacao da API: ${climaProvider.horario ?? '--'}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                CartaoDetalhado(
                  titulo: 'Temperatura',
                  valor:
                      '${climaProvider.temperatura?.toStringAsFixed(1) ?? '--'} C',
                  descricao: 'Temperatura atual - Open-Meteo',
                  icone: Icons.thermostat,
                  cor: Colors.deepOrange,
                ),
                const SizedBox(height: 16),
                CartaoDetalhado(
                  titulo: 'Umidade do ar',
                  valor: '${climaProvider.umidade ?? '--'}%',
                  descricao: 'Umidade atual - Open-Meteo',
                  icone: Icons.cloud,
                  cor: Colors.teal,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class CartaoDetalhado extends StatelessWidget {
  final String titulo;
  final String valor;
  final String descricao;
  final IconData icone;
  final Color cor;

  const CartaoDetalhado({
    super.key,
    required this.titulo,
    required this.valor,
    required this.descricao,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    Widget grafico;
    String fonteGrafico;

    if (titulo == 'Consumo de agua') {
      grafico = const GraficoIndicador();
      fonteGrafico = 'Grafico com dados simulados dos ultimos 7 dias';
    } else if (titulo == 'Consumo de energia') {
      grafico = const GraficoEnergia();
      fonteGrafico = 'Grafico com dados simulados dos ultimos 7 dias';
    } else if (titulo == 'Temperatura') {
      grafico = const GraficoTemperatura();
      fonteGrafico =
          'Media diaria de temperatura dos ultimos 7 dias - Open-Meteo';
    } else {
      grafico = const GraficoUmidade();
      fonteGrafico = 'Media diaria de umidade dos ultimos 7 dias - Open-Meteo';
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: cor, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF142B49),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              descricao,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            grafico,
            const SizedBox(height: 8),
            Text(
              fonteGrafico,
              style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
