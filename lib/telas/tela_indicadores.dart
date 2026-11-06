import 'package:flutter/material.dart';

class TelaIndicadores extends StatelessWidget {
  const TelaIndicadores({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Dados simulados para demonstracao',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),
          const CartaoDetalhado(
            titulo: 'Consumo de agua',
            valor: '1.250 m3',
            descricao: 'Consumo nas ultimas 24 horas',
            icone: Icons.water_drop,
            cor: Colors.blue,
          ),
          const SizedBox(height: 16),
          const CartaoDetalhado(
            titulo: 'Consumo de energia',
            valor: '3.480 kWh',
            descricao: 'Consumo nas ultimas 24 horas',
            icone: Icons.bolt,
            cor: Colors.orange,
          ),
          const SizedBox(height: 16),
          const CartaoDetalhado(
            titulo: 'Temperatura',
            valor: '28 C',
            descricao: 'Temperatura atual simulada',
            icone: Icons.thermostat,
            cor: Colors.deepOrange,
          ),
          const SizedBox(height: 16),
          const CartaoDetalhado(
            titulo: 'Umidade do ar',
            valor: '65%',
            descricao: 'Umidade relativa simulada',
            icone: Icons.cloud,
            cor: Colors.teal,
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
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.insert_chart_outlined, color: cor, size: 32),
                    const SizedBox(height: 8),
                    const Text(
                      'Grafico em desenvolvimento',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
