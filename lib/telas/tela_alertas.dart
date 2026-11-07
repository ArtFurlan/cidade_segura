import 'package:flutter/material.dart';

import '../dados/dados_simulados.dart';
import '../models/alerta.dart';
import '../services/alerta_service.dart';

class TelaAlertas extends StatelessWidget {
  const TelaAlertas({super.key});

  @override
  Widget build(BuildContext context) {
    final alertaService = AlertaService();

    final alertasAtuais = alertaService.analisarIndicadores(
      consumoAgua: DadosSimulados.consumoAguaAtual,
      consumoEnergia: DadosSimulados.consumoEnergiaAtual,
    );

    final alertasTendencia = alertaService.analisarTendencias(
      historicoAgua: DadosSimulados.historicoAgua,
      historicoEnergia: DadosSimulados.historicoEnergia,
    );

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
              color: Color(0xFF142B49),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Situacoes identificadas a partir dos indicadores.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Analise demonstrativa com dados e limites simulados',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),
          const Text(
            'Alertas atuais',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF142B49),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Indicadores que ultrapassaram os limites definidos.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (alertasAtuais.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Nenhum indicador ultrapassou os limites definidos.',
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alertasAtuais.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
              itemBuilder: (context, index) {
                return CartaoAlerta(alerta: alertasAtuais[index]);
              },
            ),
          const SizedBox(height: 32),
          const Text(
            'Alertas de tendencia',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF142B49),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Estimativas para o proximo dia com base no mesmo '
            'historico simulado apresentado nos graficos.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (alertasTendencia.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Nenhuma tendencia ultrapassou os limites definidos.',
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alertasTendencia.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
              itemBuilder: (context, index) {
                return CartaoAlerta(alerta: alertasTendencia[index]);
              },
            ),
          const SizedBox(height: 24),
          const Text(
            'Os alertas apoiam a analise humana. '
            'As estimativas nao garantem eventos futuros '
            'e nao devem gerar decisoes automaticas.',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}

class CartaoAlerta extends StatelessWidget {
  final Alerta alerta;

  const CartaoAlerta({super.key, required this.alerta});

  Color get cor {
    switch (alerta.nivel) {
      case NivelRisco.baixo:
        return Colors.green;
      case NivelRisco.medio:
        return Colors.orange;
      case NivelRisco.alto:
        return Colors.red;
    }
  }

  IconData get icone {
    if (alerta.titulo.contains('agua')) {
      return Icons.water_drop;
    }

    if (alerta.titulo.contains('energia')) {
      return Icons.bolt;
    }

    return Icons.warning_amber;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
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
            Text('Nivel de risco: ${alerta.nivelTexto}'),
            const SizedBox(height: 8),
            Text('Confianca: ${alerta.confiancaTexto}'),
            const SizedBox(height: 8),
            Text('Justificativa: ${alerta.justificativa}'),
            const SizedBox(height: 8),
            Text('Limitacao: ${alerta.limitacao}'),
            const SizedBox(height: 8),
            Text('Recomendacao: ${alerta.recomendacao}'),
            const SizedBox(height: 12),
            Text(
              'Fonte: ${alerta.fonte}',
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
