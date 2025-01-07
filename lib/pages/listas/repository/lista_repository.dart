import 'dart:convert';

import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/models/tarefa_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const listaProximas = 'lista_proximas';
const listaEspera = 'lista_espera';
const listaTalvez = 'lista_talvez';
const listaFinalizados = 'lista_finalizados';
const listaAgendados = 'lista_agendados';

class ListaRepository {
  late SharedPreferences sharedPreferences;

  Future<List<TarefaModel>> getListaProximas() async {
    return _getLista(listaProximas);
  }

  Future<List<TarefaModel>> getListaEspera() async {
    return _getLista(listaEspera);
  }

  Future<List<TarefaModel>> getListaTalvez() async {
    return _getLista(listaTalvez);
  }

  Future<List<TarefaModel>> getListaFinalizados() async {
    return _getLista(listaFinalizados);
  }

  Future<List<TarefaModel>> getListaAgendados() async {
    return _getLista(listaAgendados);
  }

  Future<List<TarefaModel>> _getLista(String listaKey) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(listaKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => TarefaModel.fromJson(e)).toList();
  }

  Future<void> salvaListaProximas(List<TarefaModel> lTarefas) async {
    await _salvaLista(listaProximas, lTarefas);
  }

  Future<void> salvaListaEspera(List<TarefaModel> lTarefas) async {
    await _salvaLista(listaEspera, lTarefas);
  }

  Future<void> salvaListaTalvez(List<TarefaModel> lTarefas) async {
    await _salvaLista(listaTalvez, lTarefas);
  }

  Future<void> salvaListaFinalizados(List<TarefaModel> lTarefas) async {
    await _salvaLista(listaFinalizados, lTarefas);
  }

  Future<void> salvaListaAgendados(List<TarefaModel> lTarefas) async {
    await _salvaLista(listaAgendados, lTarefas);
  }

  Future<void> _salvaLista(String listaKey, List<TarefaModel> lTarefas) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(listaKey, json.encode(lTarefas));
  }

  void salvaListas(Map<String, List<TarefaModel>> lTarefas) async {
    sharedPreferences = await SharedPreferences.getInstance();
    lTarefas.forEach((key, value) {
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
