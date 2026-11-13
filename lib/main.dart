import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/clima_provider.dart';
import 'telas/tela_inicio.dart';
import 'telas/tela_indicadores.dart';
import 'telas/tela_alertas.dart';
import 'telas/tela_ocorrencias.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      lazy: false,
      create: (context) {
        final climaProvider = ClimaProvider();
        climaProvider.atualizarClima();
        climaProvider.atualizarHistorico();
        climaProvider.atualizarPrevisao();
        return climaProvider;
      },
      child: const CidadeSeguraApp(),
    ),
  );
}

class CidadeSeguraApp extends StatelessWidget {
  const CidadeSeguraApp({super.key});

  @override
  Widget build(BuildContext context) {
    const corFundo = Color(0xFF17191E);
    const corCartao = Color(0xFF292D35);
    const corAzul = Color(0xFF42A5F5);
    const corTexto = Color(0xFFF5F6F8);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cidade Segura',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: corAzul,
          brightness: Brightness.dark,
          surface: corFundo,
          primary: corAzul,
          onPrimary: corFundo,
          onSurface: corTexto,
        ),
        scaffoldBackgroundColor: corFundo,
        cardColor: corCartao,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF21252D),
          foregroundColor: corTexto,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: corCartao,
          labelStyle: const TextStyle(color: Color(0xFFD0D5DE)),
          hintStyle: const TextStyle(color: Color(0xFFB8C0CA)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF59616D)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: corAzul, width: 2),
          ),
        ),
        dividerColor: const Color(0xFF414752),
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

class _TelaPrincipalState extends State<TelaPrincipal>
    with WidgetsBindingObserver {
  int paginaAtual = 0;

  Timer? temporizador;

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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    temporizador = Timer.periodic(const Duration(minutes: 5), (timer) {
      verificarAtualizacoes();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      verificarAtualizacoes();
    }
  }

  void verificarAtualizacoes() {
    if (!mounted) return;

    final climaProvider = context.read<ClimaProvider>();

    if (climaProvider.climaDesatualizado && !climaProvider.carregando) {
      climaProvider.atualizarClima();
    }

    if (climaProvider.historicoDesatualizado &&
        !climaProvider.carregandoHistorico) {
      climaProvider.atualizarHistorico();
    }

    if (climaProvider.previsaoDesatualizada &&
        !climaProvider.carregandoPrevisao) {
      climaProvider.atualizarPrevisao();
    }

    setState(() {});
  }

  @override
  void dispose() {
    temporizador?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulos[paginaAtual])),
      body: telas[paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF21252D),
        selectedItemColor: const Color(0xFF42A5F5),
        unselectedItemColor: const Color(0xFFB8C0CA),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        showSelectedLabels: true,
        showUnselectedLabels: true,
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
