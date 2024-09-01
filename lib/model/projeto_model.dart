import 'package:gtd_app/model/coisa_model.dart';

class ProjetoModel extends CoisaModel {
  ProjetoModel({
    required super.descricao,
    required super.dataCriacao,
  });

  final List<CoisaModel> _acoes = [];

  List<CoisaModel> get acoes => _acoes;

  void addAcao(CoisaModel acao) {
    _acoes.add(acao);
  }
}
