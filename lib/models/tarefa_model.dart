import 'package:gtd_app/models/coisa_model.dart';

class TarefaModel extends CoisaModel {
  TarefaModel({
    required super.id,
    required super.descricao,
    required super.dataCriacao,
    this.projetoId,
  });

  String? projetoId;

  factory TarefaModel.fromJson(Map<String, dynamic> json) {
    return TarefaModel(
      id: json['id'],
      descricao: json['descricao'],
      dataCriacao: DateTime.parse(json['dataCriacao']),
      projetoId: json['projetoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'dataCriacao': dataCriacao.toIso8601String(),
      'projetoId': projetoId,
    };
  }
}
