import 'package:flutter/material.dart';

class IndicadorEnergiaOficial extends StatelessWidget {
  const IndicadorEnergiaOficial({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.bolt, color: Colors.orange, size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Consumo municipal de energia eletrica',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '28.076.109 MWh',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF142B49),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Municipio de Sao Paulo - ano-base 2024',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              'Consumo total anual de energia eletrica '
              'do municipio, considerando as diferentes '
              'classes de consumidores.',
            ),
            const SizedBox(height: 12),
            const Text(
              'Fonte consultada: CircuitoBR, com dados '
              'atribuidos ao Anuario de Energeticos '
              'por Municipios 2025 da SEMIL.',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            const Text(
              'Conferencia na tabela original pendente. '
              'Dado historico anual, nao atualizado em tempo real.',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
