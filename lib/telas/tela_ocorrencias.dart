import 'package:flutter/material.dart';

class TelaOcorrencias extends StatefulWidget {
  const TelaOcorrencias({super.key});

  @override
  State<TelaOcorrencias> createState() => _TelaOcorrenciasState();
}

class _TelaOcorrenciasState extends State<TelaOcorrencias> {
  final formulario = GlobalKey<FormState>();

  final bairroController = TextEditingController();
  final descricaoController = TextEditingController();

  String? tipoSelecionado;

  final List<String> tipos = [
    'Vazamento de agua',
    'Falta de energia',
    'Alagamento',
    'Acumulo de lixo',
    'Outro',
  ];

  @override
  void dispose() {
    bairroController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  void registrarOcorrencia() {
    if (formulario.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Formulario validado! O registro sera implementado em breve.',
          ),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registro de ocorrencias',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF142B49),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cadastre problemas identificados na cidade.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipo de ocorrencia',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: tipoSelecionado,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Selecione o tipo',
                      ),
                      items: tipos.map((tipo) {
                        return DropdownMenuItem(value: tipo, child: Text(tipo));
                      }).toList(),
                      onChanged: (valor) {
                        setState(() {
                          tipoSelecionado = valor;
                        });
                      },
                      validator: (valor) {
                        if (valor == null) {
                          return 'Selecione um tipo de ocorrencia';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bairro',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: bairroController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Digite o bairro',
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Informe o bairro';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Descricao',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descricaoController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Descreva o problema identificado',
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Descreva a ocorrencia';
                        }
                        if (valor.trim().length < 10) {
                          return 'Digite pelo menos 10 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: registrarOcorrencia,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Registrar ocorrencia'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
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
