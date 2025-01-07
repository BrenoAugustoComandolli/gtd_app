import 'package:gtd_app/models/coisa_model.dart';

class ProjetoModel extends CoisaModel {
  ProjetoModel({
    required super.id,
    required super.descricao,
    required super.dataCriacao,
  });

  factory ProjetoModel.fromJson(Map<String, dynamic> json) {
    return ProjetoModel(
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
