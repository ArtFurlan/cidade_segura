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

  final List<Map<String, String>> ocorrencias = [];

  @override
  void dispose() {
    bairroController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  void registrarOcorrencia() {
    if (formulario.currentState!.validate()) {
      setState(() {
        ocorrencias.add({
          'tipo': tipoSelecionado!,
          'bairro': bairroController.text.trim(),
          'descricao': descricaoController.text.trim(),
          'data': DateTime.now().toString().substring(0, 16),
        });
      });

      formulario.currentState!.reset();
      bairroController.clear();
      descricaoController.clear();

      setState(() {
        tipoSelecionado = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorrencia registrada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void excluirOcorrencia(int index) {
    setState(() {
      ocorrencias.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ocorrencia excluida!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
            'Cadastre e acompanhe problemas da cidade.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formulario,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipo de ocorrencia',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      key: ValueKey(tipoSelecionado),
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
          ),
          const SizedBox(height: 32),
          Text(
            'Ocorrencias registradas (${ocorrencias.length})',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF142B49),
            ),
          ),
          const SizedBox(height: 16),
          if (ocorrencias.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(child: Text('Nenhuma ocorrencia registrada.')),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ocorrencias.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },
              itemBuilder: (context, index) {
                final ocorrencia = ocorrencias[index];

                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.assignment, color: Colors.blue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ocorrencia['tipo']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                excluirOcorrencia(index);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              tooltip: 'Excluir ocorrencia',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Bairro: ${ocorrencia['bairro']}'),
                        const SizedBox(height: 8),
                        Text('Descricao: ${ocorrencia['descricao']}'),
                        const SizedBox(height: 8),
                        Text(
                          'Data: ${ocorrencia['data']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
