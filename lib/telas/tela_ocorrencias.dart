import 'package:flutter/material.dart';

import '../services/ocorrencia_service.dart';

class TelaOcorrencias extends StatefulWidget {
  const TelaOcorrencias({super.key});

  @override
  State<TelaOcorrencias> createState() => _TelaOcorrenciasState();
}

class _TelaOcorrenciasState extends State<TelaOcorrencias> {
  final formulario = GlobalKey<FormState>();
  final ocorrenciaService = OcorrenciaService();

  final bairroController = TextEditingController();
  final descricaoController = TextEditingController();

  String? tipoSelecionado;

  bool carregando = true;
  bool salvando = false;

  final List<String> tipos = [
    'Vazamento de agua',
    'Falta de energia',
    'Alagamento',
    'Acumulo de lixo',
    'Outro',
  ];

  List<Map<String, String>> ocorrencias = [];

  @override
  void initState() {
    super.initState();
    carregarOcorrencias();
  }

  Future<void> carregarOcorrencias() async {
    try {
      final lista = await ocorrenciaService.carregarOcorrencias();

      if (!mounted) return;

      setState(() {
        ocorrencias = lista;
        carregando = false;
      });
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        carregando = false;
      });

      mostrarMensagem('Erro ao carregar ocorrencias', Colors.red);
    }
  }

  void mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem), backgroundColor: cor));
  }

  Future<void> registrarOcorrencia() async {
    if (salvando || carregando) return;

    if (!formulario.currentState!.validate()) return;

    final novaOcorrencia = {
      'tipo': tipoSelecionado!,
      'bairro': bairroController.text.trim(),
      'descricao': descricaoController.text.trim(),
      'data': DateTime.now().toString().substring(0, 16),
    };

    final novaLista = [...ocorrencias, novaOcorrencia];

    setState(() {
      salvando = true;
    });

    try {
      await ocorrenciaService.salvarOcorrencias(novaLista);

      if (!mounted) return;

      setState(() {
        ocorrencias = novaLista;
        tipoSelecionado = null;
        salvando = false;
      });

      formulario.currentState!.reset();
      bairroController.clear();
      descricaoController.clear();

      mostrarMensagem('Ocorrencia registrada com sucesso!', Colors.green);
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        salvando = false;
      });

      mostrarMensagem('Erro ao salvar ocorrencia', Colors.red);
    }
  }

  Future<void> excluirOcorrencia(int index) async {
    if (salvando || carregando) return;

    final novaLista = List<Map<String, String>>.from(ocorrencias);
    novaLista.removeAt(index);

    setState(() {
      salvando = true;
    });

    try {
      await ocorrenciaService.salvarOcorrencias(novaLista);

      if (!mounted) return;

      setState(() {
        ocorrencias = novaLista;
        salvando = false;
      });

      mostrarMensagem('Ocorrencia excluida!', Colors.orange);
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        salvando = false;
      });

      mostrarMensagem('Erro ao excluir ocorrencia', Colors.red);
    }
  }

  @override
  void dispose() {
    bairroController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const corCartao = Color(0xFF292D35);
    const corTitulo = Color(0xFFF5F6F8);
    const corTexto = Color(0xFFD0D5DE);
    const corSecundaria = Color(0xFFB8C0CA);
    const corAzul = Color(0xFF42A5F5);

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
              color: corTitulo,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Cadastre e acompanhe problemas da cidade.',
            style: TextStyle(fontSize: 14, color: corTexto),
          ),
          const SizedBox(height: 16),
          Card(
            color: corCartao,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF414752)),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield_outlined, color: corAzul, size: 24),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Privacidade dos registros',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: corTitulo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'As ocorrencias ficam armazenadas neste dispositivo '
                    'e nao sao enviadas a um servidor pelo aplicativo.',
                    style: TextStyle(fontSize: 13, color: corTexto),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Evite informar nomes completos, telefones, '
                    'enderecos residenciais ou outros dados pessoais '
                    'na descricao.',
                    style: TextStyle(fontSize: 12, color: corSecundaria),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: corCartao,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formulario,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipo de ocorrencia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: corTitulo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      key: ValueKey(tipoSelecionado),
                      initialValue: tipoSelecionado,
                      dropdownColor: corCartao,
                      style: const TextStyle(color: corTitulo, fontSize: 16),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Selecione o tipo',
                      ),
                      items: tipos.map((tipo) {
                        return DropdownMenuItem(value: tipo, child: Text(tipo));
                      }).toList(),
                      onChanged: salvando || carregando
                          ? null
                          : (valor) {
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: corTitulo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: bairroController,
                      enabled: !salvando && !carregando,
                      style: const TextStyle(color: corTitulo),
                      cursorColor: corAzul,
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: corTitulo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descricaoController,
                      enabled: !salvando && !carregando,
                      maxLines: 4,
                      style: const TextStyle(color: corTitulo),
                      cursorColor: corAzul,
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
                        onPressed: salvando || carregando
                            ? null
                            : registrarOcorrencia,
                        icon: const Icon(Icons.add_circle_outline),
                        label: Text(
                          salvando ? 'Salvando...' : 'Registrar ocorrencia',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: corAzul,
                          foregroundColor: const Color(0xFF17191E),
                          padding: const EdgeInsets.all(16),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
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
              color: corTitulo,
            ),
          ),
          const SizedBox(height: 16),
          if (carregando)
            const Center(child: CircularProgressIndicator())
          else if (ocorrencias.isEmpty)
            const Card(
              color: corCartao,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: corAzul),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Nenhuma ocorrencia registrada.',
                        style: TextStyle(color: corTexto),
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
              itemCount: ocorrencias.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },
              itemBuilder: (context, index) {
                final ocorrencia = ocorrencias[index];

                return Card(
                  color: corCartao,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.assignment, color: corAzul),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ocorrencia['tipo']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: corTitulo,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: salvando
                                  ? null
                                  : () => excluirOcorrencia(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFFF6B6B),
                              ),
                              tooltip: 'Excluir ocorrencia',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bairro: ${ocorrencia['bairro']}',
                          style: const TextStyle(color: corTexto),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Descricao: ${ocorrencia['descricao']}',
                          style: const TextStyle(color: corTexto),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Data: ${ocorrencia['data']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: corSecundaria,
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
