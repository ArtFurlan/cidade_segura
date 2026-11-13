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

    final climaValido = climaDisponivel && !climaProvider.climaDesatualizado;

    final alertasClimaticos = climaValido
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

    final previsaoValida =
        previsaoDisponivel && !climaProvider.previsaoDesatualizada;

    final alertasChuva = previsaoValida
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

    if (!climaValido || !previsaoValida) {
      descricaoAlertas = 'Contagem parcial - clima indisponivel';
    }

    String temperatura = '...';
    String umidade = '...';
    String descricaoClima = 'Carregando clima';

    if (climaProvider.dadosClima != null) {
      temperatura =
          '${climaProvider.temperatura?.toStringAsFixed(1) ?? '--'} C';

      umidade = '${climaProvider.umidade ?? '--'}%';

      descricaoClima = climaProvider.climaDesatualizado
          ? 'Dados desatualizados - Open-Meteo'
          : 'Atual - Open-Meteo';
    } else if (climaProvider.erro != null) {
      temperatura = '--';
      umidade = '--';
      descricaoClima = 'Erro ao consultar API';
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
              color: Color(0xFFF5F6F8),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Monitoramento territorial de Sao Paulo.',
            style: TextStyle(fontSize: 14, color: Color(0xFFD0D5DE)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Agua e energia: simulados. '
            'Clima e previsao: Open-Meteo.',
            style: TextStyle(fontSize: 12, color: Color(0xFFB8C0CA)),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final larguraDisponivel = constraints.maxWidth;

              final escalaFonte = MediaQuery.textScalerOf(context).scale(1.0);

              final larguraAjustada = larguraDisponivel / escalaFonte;

              final int colunas;

              if (larguraAjustada < 280) {
                colunas = 1;
              } else if (larguraAjustada < 600) {
                colunas = 2;
              } else {
                colunas = 3;
              }

              final largura =
                  (larguraDisponivel - (colunas - 1) * 12) / colunas;

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
                      cor: const Color(0xFF42A5F5),
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Consumo de energia',
                      valor: '${consumoEnergia.toStringAsFixed(0)} kWh',
                      descricao: 'Simulado - ultimas 24 horas',
                      icone: Icons.bolt,
                      cor: const Color(0xFFFFB74D),
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Temperatura',
                      valor: temperatura,
                      descricao: descricaoClima,
                      icone: Icons.thermostat,
                      cor: const Color(0xFFFF7043),
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Umidade do ar',
                      valor: umidade,
                      descricao: descricaoClima,
                      icone: Icons.cloud,
                      cor: const Color(0xFF26A69A),
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: CartaoIndicador(
                      titulo: 'Alertas ativos',
                      valor: '$totalAlertas',
                      descricao: descricaoAlertas,
                      icone: Icons.warning_amber,
                      cor: const Color(0xFFFF5252),
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
          const SizedBox(height: 12),
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
      color: const Color(0xFF292D35),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 170),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icone, color: cor, size: 28),
              const SizedBox(height: 12),
              Text(
                titulo,
                style: const TextStyle(fontSize: 13, color: Color(0xFFD0D5DE)),
              ),
              const SizedBox(height: 12),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF5F6F8),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                descricao,
                style: const TextStyle(fontSize: 11, color: Color(0xFFB8C0CA)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
