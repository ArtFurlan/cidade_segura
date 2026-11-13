import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dados/dados_simulados.dart';
import '../models/alerta.dart';
import '../providers/clima_provider.dart';
import '../services/alerta_service.dart';

const corCartaoAlerta = Color(0xFF292D35);
const corTituloAlerta = Color(0xFFF5F6F8);
const corTextoAlerta = Color(0xFFD0D5DE);
const corSecundariaAlerta = Color(0xFFB8C0CA);

class TelaAlertas extends StatelessWidget {
  const TelaAlertas({super.key});

  @override
  Widget build(BuildContext context) {
    final alertaService = AlertaService();
    final climaProvider = context.watch<ClimaProvider>();

    final alertasAtuais = alertaService.analisarIndicadores(
      consumoAgua: DadosSimulados.consumoAguaAtual,
      consumoEnergia: DadosSimulados.consumoEnergiaAtual,
    );

    final alertasTendencia = alertaService.analisarTendencias(
      historicoAgua: DadosSimulados.historicoAgua,
      historicoEnergia: DadosSimulados.historicoEnergia,
    );

    final temperatura = climaProvider.temperatura;
    final umidade = climaProvider.umidade;

    final climaDisponivel = temperatura != null && umidade != null;

    final climaValido = climaDisponivel && !climaProvider.climaDesatualizado;

    final List<Alerta> alertasClimaticos = climaValido
        ? alertaService.analisarClima(
            temperatura: temperatura,
            umidade: umidade,
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

    final List<Alerta> alertasChuva = previsaoValida
        ? alertaService.analisarPrevisaoChuva(
            chuvaAcumulada: chuvaAcumulada,
            maiorChuvaHoraria: maiorChuvaHoraria,
          )
        : [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alertas da cidade',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: corTituloAlerta,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Situacoes identificadas a partir dos indicadores.',
            style: TextStyle(fontSize: 14, color: corTextoAlerta),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dados simulados e dados meteorologicos da Open-Meteo',
            style: TextStyle(fontSize: 12, color: corSecundariaAlerta),
          ),
          const SizedBox(height: 24),
          const Text(
            'Alertas atuais',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: corTituloAlerta,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Indicadores simulados que ultrapassaram os limites definidos.',
            style: TextStyle(fontSize: 13, color: corTextoAlerta),
          ),
          const SizedBox(height: 16),
          if (alertasAtuais.isEmpty)
            const Card(
              color: corCartaoAlerta,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Color(0xFF66BB6A)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Nenhum indicador ultrapassou os limites definidos.',
                        style: TextStyle(color: corTextoAlerta),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListaAlertas(alertas: alertasAtuais),
          const SizedBox(height: 32),
          const Text(
            'Alertas meteorologicos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: corTituloAlerta,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Analise da temperatura e umidade atuais da Open-Meteo.',
            style: TextStyle(fontSize: 13, color: corTextoAlerta),
          ),
          const SizedBox(height: 8),
          Text(
            'Ultima consulta: ${climaProvider.horarioAtualizacaoClima}',
            style: const TextStyle(fontSize: 12, color: corSecundariaAlerta),
          ),
          const SizedBox(height: 16),
          if (climaProvider.carregando && !climaDisponivel)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (!climaValido)
            Card(
              color: corCartaoAlerta,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber, color: Color(0xFFFFB74D)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Dados climaticos indisponiveis ou '
                            'desatualizados. A analise de alertas '
                            'meteorologicos foi suspensa.',
                            style: TextStyle(color: corTextoAlerta),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (climaDisponivel) ...[
                      Text(
                        'Ultima temperatura recebida: '
                        '${temperatura.toStringAsFixed(1)} C',
                        style: const TextStyle(color: corTextoAlerta),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ultima umidade recebida: $umidade%',
                        style: const TextStyle(color: corTextoAlerta),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Esses valores sao apenas referencia historica.',
                        style: TextStyle(
                          fontSize: 12,
                          color: corSecundariaAlerta,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ElevatedButton.icon(
                      onPressed: climaProvider.carregando
                          ? null
                          : () {
                              context.read<ClimaProvider>().atualizarClima();
                            },
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        climaProvider.carregando
                            ? 'Atualizando...'
                            : 'Atualizar clima',
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (alertasClimaticos.isEmpty)
            Card(
              color: corCartaoAlerta,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF66BB6A),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Nenhum limite meteorologico foi ultrapassado.',
                            style: TextStyle(color: corTextoAlerta),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Temperatura atual: ${temperatura.toStringAsFixed(1)} C',
                      style: const TextStyle(color: corTextoAlerta),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Umidade atual: $umidade%',
                      style: const TextStyle(color: corTextoAlerta),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Isso nao significa ausencia de outros riscos climaticos.',
                      style: TextStyle(
                        fontSize: 12,
                        color: corSecundariaAlerta,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListaAlertas(alertas: alertasClimaticos),
          const SizedBox(height: 32),
          const Text(
            'Previsao de chuva - proximas 24 horas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: corTituloAlerta,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Precipitacao prevista pela Open-Meteo para Sao Paulo.',
            style: TextStyle(fontSize: 13, color: corTextoAlerta),
          ),
          const SizedBox(height: 8),
          Text(
            'Ultima consulta: ${climaProvider.horarioAtualizacaoPrevisao}',
            style: const TextStyle(fontSize: 12, color: corSecundariaAlerta),
          ),
          const SizedBox(height: 16),
          if (climaProvider.carregandoPrevisao && !previsaoDisponivel)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (!previsaoValida)
            Card(
              color: corCartaoAlerta,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber, color: Color(0xFFFFB74D)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Previsao de chuva indisponivel ou '
                            'desatualizada. Os alertas de chuva '
                            'foram suspensos ate uma nova consulta.',
                            style: TextStyle(color: corTextoAlerta),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Uma previsao antiga nao deve ser tratada '
                      'como uma previsao atual.',
                      style: TextStyle(
                        fontSize: 12,
                        color: corSecundariaAlerta,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: climaProvider.carregandoPrevisao
                          ? null
                          : () {
                              context.read<ClimaProvider>().atualizarPrevisao();
                            },
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        climaProvider.carregandoPrevisao
                            ? 'Atualizando...'
                            : 'Atualizar previsao',
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            Card(
              color: corCartaoAlerta,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumo da previsao',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: corTituloAlerta,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Chuva acumulada prevista: '
                      '${chuvaAcumulada.toStringAsFixed(1)} mm',
                      style: const TextStyle(color: corTextoAlerta),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Maior precipitacao horaria prevista: '
                      '${maiorChuvaHoraria.toStringAsFixed(1)} mm',
                      style: const TextStyle(color: corTextoAlerta),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Horas analisadas: $horasAnalisadas',
                      style: const TextStyle(color: corTextoAlerta),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Fonte: Open-Meteo. Previsoes podem mudar.',
                      style: TextStyle(
                        fontSize: 12,
                        color: corSecundariaAlerta,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (alertasChuva.isEmpty)
              const Card(
                color: corCartaoAlerta,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF66BB6A),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'A chuva acumulada prevista nao ultrapassou '
                          'os limites ilustrativos definidos.',
                          style: TextStyle(color: corTextoAlerta),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListaAlertas(alertas: alertasChuva),
          ],
          const SizedBox(height: 32),
          const Text(
            'Alertas de tendencia',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: corTituloAlerta,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Estimativas para o proximo dia com base no mesmo '
            'historico simulado apresentado nos graficos.',
            style: TextStyle(fontSize: 13, color: corTextoAlerta),
          ),
          const SizedBox(height: 16),
          if (alertasTendencia.isEmpty)
            const Card(
              color: corCartaoAlerta,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Nenhuma tendencia ultrapassou os limites definidos.',
                  style: TextStyle(color: corTextoAlerta),
                ),
              ),
            )
          else
            ListaAlertas(alertas: alertasTendencia),
          const SizedBox(height: 24),
          const Text(
            'Os alertas apoiam a analise humana. '
            'Os limites sao ilustrativos e as previsoes podem mudar. '
            'Nenhuma decisao de alto impacto deve ser automatizada.',
            style: TextStyle(fontSize: 12, color: corSecundariaAlerta),
          ),
        ],
      ),
    );
  }
}

class ListaAlertas extends StatelessWidget {
  final List<Alerta> alertas;

  const ListaAlertas({super.key, required this.alertas});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: alertas.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16);
      },
      itemBuilder: (context, index) {
        return CartaoAlerta(alerta: alertas[index]);
      },
    );
  }
}

class CartaoAlerta extends StatelessWidget {
  final Alerta alerta;

  const CartaoAlerta({super.key, required this.alerta});

  Color get cor {
    switch (alerta.nivel) {
      case NivelRisco.baixo:
        return const Color(0xFF66BB6A);
      case NivelRisco.medio:
        return const Color(0xFFFFB74D);
      case NivelRisco.alto:
        return const Color(0xFFFF6B6B);
    }
  }

  IconData get icone {
    final titulo = alerta.titulo.toLowerCase();

    if (titulo.contains('agua')) {
      return Icons.water_drop;
    }

    if (titulo.contains('energia')) {
      return Icons.bolt;
    }

    if (titulo.contains('umidade')) {
      return Icons.cloud;
    }

    if (titulo.contains('temperatura')) {
      return Icons.thermostat;
    }

    if (titulo.contains('chuva')) {
      return Icons.water;
    }

    return Icons.warning_amber;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: corCartaoAlerta,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: cor, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    alerta.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: corTituloAlerta,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    alerta.nivelTexto,
                    style: TextStyle(color: cor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Nivel de risco: ${alerta.nivelTexto}',
              style: const TextStyle(color: corTextoAlerta),
            ),
            const SizedBox(height: 8),
            Text(
              'Confianca: ${alerta.confiancaTexto}',
              style: const TextStyle(color: corTextoAlerta),
            ),
            const SizedBox(height: 8),
            Text(
              'Justificativa: ${alerta.justificativa}',
              style: const TextStyle(color: corTextoAlerta),
            ),
            const SizedBox(height: 8),
            Text(
              'Limitacao: ${alerta.limitacao}',
              style: const TextStyle(color: corTextoAlerta),
            ),
            const SizedBox(height: 8),
            Text(
              'Recomendacao: ${alerta.recomendacao}',
              style: const TextStyle(color: corTextoAlerta),
            ),
            const SizedBox(height: 12),
            Text(
              'Fonte: ${alerta.fonte}',
              style: const TextStyle(fontSize: 12, color: corSecundariaAlerta),
            ),
          ],
        ),
      ),
    );
  }
}
