import 'package:flutter/material.dart';

class TelaInicio extends StatelessWidget {
  const TelaInicio({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Acompanhe os principais indicadores da cidade.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dados simulados para demonstracao',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: const [
              CartaoIndicador(
                titulo: 'Consumo de agua',
                valor: '1.250 m3',
                descricao: 'Ultimas 24 horas',
                icone: Icons.water_drop,
                cor: Colors.blue,
              ),
              CartaoIndicador(
                titulo: 'Consumo de energia',
                valor: '3.480 kWh',
                descricao: 'Ultimas 24 horas',
                icone: Icons.bolt,
                cor: Colors.orange,
              ),
              CartaoIndicador(
                titulo: 'Temperatura',
                valor: '28 C',
                descricao: 'Valor simulado',
                icone: Icons.thermostat,
                cor: Colors.deepOrange,
              ),
              CartaoIndicador(
                titulo: 'Alertas ativos',
                valor: '3',
                descricao: 'Riscos identificados',
                icone: Icons.warning_amber,
                cor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'O painel ajuda gestores publicos a acompanhar '
                      'indicadores e identificar possiveis problemas.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
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
    );
  }
}
