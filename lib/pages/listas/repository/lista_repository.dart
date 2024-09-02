import 'dart:convert';

import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/models/coisa_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const listaProximas = 'lista_proximas';
const listaEspera = 'lista_espera';
const listaTalvez = 'lista_talvez';
const listaFinalizados = 'lista_finalizados';
const listaAgendados = 'lista_agendados';

class ListaRepository {
  late SharedPreferences sharedPreferences;

  Future<List<CoisaModel>> getListaProximas() async {
    return _getLista(listaProximas);
  }

  Future<List<CoisaModel>> getListaEspera() async {
    return _getLista(listaEspera);
  }

  Future<List<CoisaModel>> getListaTalvez() async {
    return _getLista(listaTalvez);
  }

  Future<List<CoisaModel>> getListaFinalizados() async {
    return _getLista(listaFinalizados);
  }

  Future<List<CoisaModel>> getListaAgendados() async {
    return _getLista(listaAgendados);
  }

  Future<List<CoisaModel>> _getLista(String listaKey) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(listaKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => CoisaModel.fromJson(e)).toList();
  }

  Future<void> salvaListaProximas(List<CoisaModel> lCoisas) async {
    await _salvaLista(listaProximas, lCoisas);
  }

  Future<void> salvaListaEspera(List<CoisaModel> lCoisas) async {
    await _salvaLista(listaEspera, lCoisas);
  }

  Future<void> salvaListaTalvez(List<CoisaModel> lCoisas) async {
    await _salvaLista(listaTalvez, lCoisas);
  }

  Future<void> salvaListaFinalizados(List<CoisaModel> lCoisas) async {
    await _salvaLista(listaFinalizados, lCoisas);
  }

  Future<void> salvaListaAgendados(List<CoisaModel> lCoisas) async {
    await _salvaLista(listaAgendados, lCoisas);
  }

  Future<void> _salvaLista(String listaKey, List<CoisaModel> lCoisas) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(listaKey, json.encode(lCoisas));
  }

  void salvaListas(Map<String, List<CoisaModel>> lCoisas) async {
    sharedPreferences = await SharedPreferences.getInstance();
    lCoisas.forEach((key, value) {
      final String jsonString = json.encode(value);
      ListasType? tipoLista = ListasType.valueOfTitulo(key);
      if (tipoLista != null) {
        sharedPreferences.setString(tipoLista.keyLocal, jsonString);
      }
    });
  }
}

enum ListasType {
  proximas(AppMgsConsts.titleProximas, listaProximas),
  espera(AppMgsConsts.titleEspera, listaEspera),
  talvez(AppMgsConsts.titleTalvez, listaTalvez),
  finalizados(AppMgsConsts.titleFinalizados, listaFinalizados),
  agendados(AppMgsConsts.titleAgendados, listaAgendados);

  const ListasType(this.titulo, this.keyLocal);

  final String titulo;
  final String keyLocal;

  static ListasType? valueOfTitulo(String titulo) {
    for (ListasType type in ListasType.values) {
      if (type.titulo == titulo) {
        return type;
      }
    }
    return null;
  }
}
