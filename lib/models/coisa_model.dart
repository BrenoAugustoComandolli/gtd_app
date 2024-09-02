class CoisaModel {
  CoisaModel({
    required this.descricao,
    required this.dataCriacao,
  });

  String descricao;
  final DateTime dataCriacao;

  factory CoisaModel.fromJson(Map<String, dynamic> json) {
    return CoisaModel(
      descricao: json['descricao'],
      dataCriacao: DateTime.parse(json['dataCriacao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }
}
