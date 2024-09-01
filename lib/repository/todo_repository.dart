import 'dart:convert';

import 'package:gtd_app/model/coisa_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const todoListKey = 'todo_list';

class ToDoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<CoisaModel>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => CoisaModel.fromJson(e)).toList();
  }

  void saveToDoList(List<CoisaModel> toDos) {
    final String jsonString = json.encode(toDos);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
