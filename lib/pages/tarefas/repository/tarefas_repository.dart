import 'dart:convert';

import 'package:gtd_app/models/tarefa_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const listaTarefasKey = 'lista_tarefas';

class TarefasRepository {
  late SharedPreferences sharedPreferences;

  Future<List<TarefaModel>> getLista() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(listaTarefasKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => TarefaModel.fromJson(e)).toList();
  }

  void salvaLista(List<TarefaModel> lTarefas) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = json.encode(lTarefas);
    sharedPreferences.setString(listaTarefasKey, jsonString);
  }
}
