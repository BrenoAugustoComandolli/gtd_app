abstract class CoisaModel {
  CoisaModel({
    required this.id,
    required this.descricao,
    required this.dataCriacao,
  });

  final String id;
  String descricao;
  final DateTime dataCriacao;
}