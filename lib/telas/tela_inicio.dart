import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dados/dados_simulados.dart';
import '../providers/clima_provider.dart';
import '../services/alerta_service.dart';

class TelaInicio extends StatelessWidget {
  const TelaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final climaProvider = context.watch<ClimaProvider>();

    final consumoAgua = DadosSimulados.consumoAguaAtual;
    final consumoEnergia = DadosSimulados.consumoEnergiaAtual;

    final alertaService = AlertaService();

    final alertas = alertaService.analisarIndicadores(
      consumoAgua: consumoAgua,
      consumoEnergia: consumoEnergia,
    );

    String temperatura = '...';
    String umidade = '...';
    String descricao = 'Carregando clima';

    if (climaProvider.erro != null && climaProvider.dadosClima == null) {
      temperatura = '--';
      umidade = '--';
      descricao = 'Erro ao consultar API';
    } else if (climaProvider.dadosClima != null) {
      temperatura =
          '${climaProvider.temperatura?.toStringAsFixed(1) ?? '--'} C';

      umidade = '${climaProvider.umidade ?? '--'}%';

      descricao = 'Atual - Open-Meteo';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visao geral',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF142B49),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Monitoramento territorial de Sao Paulo.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Agua, energia e alertas: dados simulados',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final colunas = constraints.maxWidth < 600 ? 2 : 3;
              final largura =
                  (constraints.maxWidth - (colunas - 1) * 12) / colunas;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Consumo de agua',
                      valor: '${consumoAgua.toStringAsFixed(0)} m3',
                      descricao: 'Simulado - ultimas 24 horas',
                      icone: Icons.water_drop,
                      cor: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Consumo de energia',
                      valor: '${consumoEnergia.toStringAsFixed(0)} kWh',
                      descricao: 'Simulado - ultimas 24 horas',
                      icone: Icons.bolt,
                      cor: Colors.orange,
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Temperatura',
                      valor: temperatura,
                      descricao: descricao,
                      icone: Icons.thermostat,
                      cor: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Umidade do ar',
                      valor: umidade,
                      descricao: descricao,
                      icone: Icons.cloud,
                      cor: Colors.teal,
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Alertas ativos',
                      valor: '${alertas.length}',
                      descricao: 'Alertas simulados',
                      icone: Icons.warning_amber,
                      cor: Colors.red,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: climaProvider.carregando
                ? null
                : () {
                    context.read<ClimaProvider>().atualizarClima();
                  },
            icon: const Icon(Icons.refresh),
            label: Text(
              climaProvider.carregando
                  ? 'Atualizando clima...'
                  : 'Atualizar clima',
            ),
          ),
        ],
      ),
    );
  }
}

class CartaoIndicador extends StatelessWidget {
  final String titulo;
  final String valor;
  final String descricao;
  final IconData icone;
  final Color cor;

  const CartaoIndicador({
    super.key,
    required this.titulo,
    required this.valor,
    required this.descricao,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: SizedBox(
        height: 170,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icone, color: cor, size: 28),
              Text(
                titulo,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF142B49),
                  ),
                ),
              ),
              Text(
                descricao,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
