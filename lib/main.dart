import 'package:flutter/material.dart';

import 'telas/tela_inicio.dart';
import 'telas/tela_indicadores.dart';
import 'telas/tela_alertas.dart';
import 'telas/tela_ocorrencias.dart';

void main() {
  runApp(const CidadeSeguraApp());
}

class CidadeSeguraApp extends StatelessWidget {
  const CidadeSeguraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cidade Segura',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int paginaAtual = 0;

  final List<Widget> telas = const [
    TelaInicio(),
    TelaIndicadores(),
    TelaAlertas(),
    TelaOcorrencias(),
  ];

  final List<String> titulos = [
    'Cidade Segura',
    'Indicadores',
    'Alertas',
    'Ocorrencias',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulos[paginaAtual]),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: telas[paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Indicadores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Ocorrencias',
          ),
        ],
      ),
    );
  }
}
