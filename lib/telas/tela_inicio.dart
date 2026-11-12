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
    final alertaService = AlertaService();

    final consumoAgua = DadosSimulados.consumoAguaAtual;
    final consumoEnergia = DadosSimulados.consumoEnergiaAtual;

    final alertasSimulados = alertaService.analisarIndicadores(
      consumoAgua: consumoAgua,
      consumoEnergia: consumoEnergia,
    );

    final temperaturaAtual = climaProvider.temperatura;
    final umidadeAtual = climaProvider.umidade;

    final climaDisponivel = temperaturaAtual != null && umidadeAtual != null;

    final alertasClimaticos = climaDisponivel
        ? alertaService.analisarClima(
            temperatura: temperaturaAtual,
            umidade: umidadeAtual,
          )
        : [];

    final chuvaAcumulada = climaProvider.chuvaAcumulada;
    final maiorChuvaHoraria = climaProvider.maiorChuvaHoraria;
    final horasAnalisadas = climaProvider.horasAnalisadas;

    final previsaoDisponivel =
        chuvaAcumulada != null &&
        maiorChuvaHoraria != null &&
        horasAnalisadas == 24;

    final alertasChuva = previsaoDisponivel
        ? alertaService.analisarPrevisaoChuva(
            chuvaAcumulada: chuvaAcumulada,
            maiorChuvaHoraria: maiorChuvaHoraria,
          )
        : [];

    final totalAlertas =
        alertasSimulados.length +
        alertasClimaticos.length +
        alertasChuva.length;

    final totalMeteorologicos = alertasClimaticos.length + alertasChuva.length;

    String descricaoAlertas =
        '${alertasSimulados.length} simulados, '
        '$totalMeteorologicos meteorologicos';

    if (!climaDisponivel || !previsaoDisponivel) {
      descricaoAlertas = 'Contagem parcial - dados indisponiveis';
    } else if (climaProvider.erro != null ||
        climaProvider.erroPrevisao != null) {
      descricaoAlertas = 'Contagem com dados possivelmente antigos';
    }

    String temperatura = '...';
    String umidade = '...';
    String descricaoClima = 'Carregando clima';

    if (climaProvider.erro != null && climaProvider.dadosClima == null) {
      temperatura = '--';
      umidade = '--';
      descricaoClima = 'Erro ao consultar API';
    } else if (climaProvider.dadosClima != null) {
      temperatura =
          '${climaProvider.temperatura?.toStringAsFixed(1) ?? '--'} C';

      umidade = '${climaProvider.umidade ?? '--'}%';

      descricaoClima = climaProvider.erro != null
          ? 'Dados anteriores - Open-Meteo'
          : 'Atual - Open-Meteo';
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
            'Agua e energia: simulados. '
            'Clima e previsao: Open-Meteo.',
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
                      descricao: descricaoClima,
                      icone: Icons.thermostat,
                      cor: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Umidade do ar',
                      valor: umidade,
                      descricao: descricaoClima,
                      icone: Icons.cloud,
                      cor: Colors.teal,
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Alertas ativos',
                      valor: '$totalAlertas',
                      descricao: descricaoAlertas,
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
            onPressed:
                climaProvider.carregando || climaProvider.carregandoPrevisao
                ? null
                : () {
                    final provider = context.read<ClimaProvider>();
                    provider.atualizarClima();
                    provider.atualizarPrevisao();
                  },
            icon: const Icon(Icons.refresh),
            label: Text(
              climaProvider.carregando || climaProvider.carregandoPrevisao
                  ? 'Atualizando dados...'
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
