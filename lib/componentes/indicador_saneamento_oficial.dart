import 'package:flutter/material.dart';

class IndicadorSaneamentoOficial extends StatelessWidget {
  const IndicadorSaneamentoOficial({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF292D35),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.water, color: Color(0xFF42A5F5), size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Perdas na distribuicao de agua',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5F6F8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '304 L/ligacao/dia',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF5F6F8),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Municipio de Sao Paulo - 2024',
              style: TextStyle(fontSize: 14, color: Color(0xFFD0D5DE)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Indicador preliminar referente ao primeiro '
              'semestre de 2024. Representa as perdas '
              'na distribuicao por ligacao de agua.',
              style: TextStyle(color: Color(0xFFF5F6F8)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Fonte: Prefeitura de Sao Paulo, '
              'Plano Municipal de Saneamento Basico. '
              'Dados adaptados da Sabesp.',
              style: TextStyle(fontSize: 12, color: Color(0xFFB8C0CA)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Dado oficial de referencia historica. '
              'Nao representa monitoramento em tempo real.',
              style: TextStyle(fontSize: 12, color: Color(0xFFB8C0CA)),
            ),
          ],
        ),
      ),
    );
  }
}
