class CoisaModel {
  CoisaModel({
    required this.id,
    required this.descricao,
    required this.dataCriacao,
  });

  final String id;
  String descricao;
  final DateTime dataCriacao;

  factory CoisaModel.fromJson(Map<String, dynamic> json) {
    return CoisaModel(
      id: json['id'],
      descricao: json['descricao'],
      dataCriacao: DateTime.parse(json['dataCriacao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }
}
