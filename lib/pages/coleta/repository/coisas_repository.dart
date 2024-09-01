import 'dart:convert';

import 'package:gtd_app/models/coisa_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const listaCoisasKey = 'lista_coisas';

class CoisasRepository {
  late SharedPreferences sharedPreferences;

  Future<List<CoisaModel>> getListaCoisas() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(listaCoisasKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => CoisaModel.fromJson(e)).toList();
  }

  void salvaListaCoisas(List<CoisaModel> lCoisas) {
    final String jsonString = json.encode(lCoisas);
    sharedPreferences.setString(listaCoisasKey, jsonString);
  }
}
