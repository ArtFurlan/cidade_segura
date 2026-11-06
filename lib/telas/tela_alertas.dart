import 'package:flutter/material.dart';

class TelaAlertas extends StatelessWidget {
  const TelaAlertas({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Acompanhe possiveis riscos identificados.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Alertas simulados para demonstracao',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),
          const CartaoAlerta(
            titulo: 'Risco de alagamento',
            nivel: 'Alto',
            confianca: 'Alta (simulada)',
            justificativa:
                'Previsao de chuva intensa e historico de alagamentos.',
            limitacao: 'Os dados sao simulados e a previsao pode mudar.',
            recomendacao: 'Verificar areas vulneraveis e acompanhar o clima.',
            icone: Icons.water,
            cor: Colors.red,
          ),
          const SizedBox(height: 16),
          const CartaoAlerta(
            titulo: 'Consumo elevado de agua',
            nivel: 'Medio',
            confianca: 'Media (simulada)',
            justificativa: 'Consumo acima da media historica da regiao.',
            limitacao: 'O alerta nao confirma a existencia de vazamentos.',
            recomendacao: 'Verificar os registros de consumo da regiao.',
            icone: Icons.water_drop,
            cor: Colors.orange,
          ),
          const SizedBox(height: 16),
          const CartaoAlerta(
            titulo: 'Aumento no consumo de energia',
            nivel: 'Baixo',
            confianca: 'Baixa (simulada)',
            justificativa: 'Tendencia de crescimento no consumo de energia.',
            limitacao:
                'A analise ainda nao considera todos os fatores sazonais.',
            recomendacao: 'Acompanhar a evolucao do consumo nos proximos dias.',
            icone: Icons.bolt,
            cor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class CartaoAlerta extends StatelessWidget {
  final String titulo;
  final String nivel;
  final String confianca;
  final String justificativa;
  final String limitacao;
  final String recomendacao;
  final IconData icone;
  final Color cor;

  const CartaoAlerta({
    super.key,
    required this.titulo,
    required this.nivel,
    required this.confianca,
    required this.justificativa,
    required this.limitacao,
    required this.recomendacao,
    required this.icone,
    required this.cor,
  });

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
                    titulo,
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
                    nivel,
                    style: TextStyle(color: cor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Nivel de risco: $nivel'),
            const SizedBox(height: 8),
            Text('Confianca: $confianca'),
            const SizedBox(height: 8),
            Text('Justificativa: $justificativa'),
            const SizedBox(height: 8),
            Text('Limitacao: $limitacao'),
            const SizedBox(height: 8),
            Text('Recomendacao: $recomendacao'),
          ],
        ),
      ),
    );
  }
}
