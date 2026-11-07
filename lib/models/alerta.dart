enum NivelRisco { baixo, medio, alto }

enum ConfiancaAlerta { baixa, media, alta }

class Alerta {
  final String titulo;
  final NivelRisco nivel;
  final ConfiancaAlerta confianca;
  final String justificativa;
  final String limitacao;
  final String recomendacao;
  final String fonte;

  const Alerta({
    required this.titulo,
    required this.nivel,
    required this.confianca,
    required this.justificativa,
    required this.limitacao,
    required this.recomendacao,
    required this.fonte,
  });

  String get nivelTexto {
    switch (nivel) {
      case NivelRisco.baixo:
        return 'Baixo';
      case NivelRisco.medio:
        return 'Medio';
      case NivelRisco.alto:
        return 'Alto';
    }
  }

  String get confiancaTexto {
    switch (confianca) {
      case ConfiancaAlerta.baixa:
        return 'Baixa';
      case ConfiancaAlerta.media:
        return 'Media';
      case ConfiancaAlerta.alta:
        return 'Alta';
    }
  }
}
