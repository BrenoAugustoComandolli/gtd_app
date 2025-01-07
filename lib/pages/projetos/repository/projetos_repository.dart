import 'dart:convert';

import 'package:gtd_app/models/projeto_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const listaProjetosKey = 'lista_projetos';

class ProjetosRepository {
  late SharedPreferences sharedPreferences;

  Future<List<ProjetoModel>> getLista() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(listaProjetosKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => ProjetoModel.fromJson(e)).toList();
  }

  void salvaLista(List<ProjetoModel> lProjetos) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = json.encode(lProjetos);
    sharedPreferences.setString(listaProjetosKey, jsonString);
  }

  Future<ProjetoModel?> getProjetoById(String projetoId) async {
    List<ProjetoModel> lista = await getLista();
    return lista.firstWhere((e) => e.id == projetoId);
  }
}
