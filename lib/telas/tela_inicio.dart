import 'package:flutter/material.dart';

import '../services/clima_service.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  final ClimaService climaService = ClimaService();

  late Future<Map<String, dynamic>> dadosClima;

  @override
  void initState() {
    super.initState();
    dadosClima = climaService.buscarClima();
  }

  void atualizarClima() {
    setState(() {
      dadosClima = climaService.buscarClima();
    });
  }

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
                    child: const CartaoIndicador(
                      titulo: 'Consumo de agua',
                      valor: '1.250 m3',
                      descricao: 'Simulado - ultimas 24 horas',
                      icone: Icons.water_drop,
                      cor: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    width: largura,
                    child: const CartaoIndicador(
                      titulo: 'Consumo de energia',
                      valor: '3.480 kWh',
                      descricao: 'Simulado - ultimas 24 horas',
                      icone: Icons.bolt,
                      cor: Colors.orange,
                    ),
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: dadosClima,
                    builder: (context, snapshot) {
                      String temperatura = '...';
                      String umidade = '...';
                      String descricao = 'Carregando clima';

                      if (snapshot.hasError) {
                        temperatura = '--';
                        umidade = '--';
                        descricao = 'Erro ao consultar API';
                      } else if (snapshot.hasData) {
                        final dados = snapshot.data!;

                        temperatura =
                            '${(dados['temperatura'] as num).toStringAsFixed(1)} C';

                        umidade = '${(dados['umidade'] as num).round()}%';

                        descricao = 'Atual - Open-Meteo';
                      }

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
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
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    width: largura,
                    child: const CartaoIndicador(
                      titulo: 'Alertas ativos',
                      valor: '3',
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
            onPressed: atualizarClima,
            icon: const Icon(Icons.refresh),
            label: const Text('Atualizar clima'),
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
