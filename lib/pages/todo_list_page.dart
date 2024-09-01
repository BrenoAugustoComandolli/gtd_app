import 'package:flutter/material.dart';
import 'package:gtd_app/model/coisa_model.dart';
import 'package:gtd_app/pages/todo_item.dart';
import 'package:gtd_app/repository/todo_repository.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final ToDoRepository toDoRepository = ToDoRepository();

  List<CoisaModel> toDos = [];

  CoisaModel? deletedToDo;
  int? deletedToDoPos;
  String? errorText;

  @override
  void initState() {
    super.initState();

    toDoRepository.getTodoList().then((value) {
      setState(() {
        toDos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Adicione uma tarefa',
                            hintText: 'Ex. Estudar Flutter',
                            errorText: errorText,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff00d7f3),
                                width: 2,
                              ),
                            ),
                            labelStyle: const TextStyle(
                              color: Color(0xff00d7f3),
                            )),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'O título não pode ser vazio!';
                          });
                          return;
                        }

                        setState(() {
                          CoisaModel newToDo = CoisaModel(descricao: text, dataCriacao: DateTime.now());
                          toDos.add(newToDo);
                          errorText = null;
                        });

                        todoController.clear();
                        toDoRepository.saveToDoList(toDos);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (CoisaModel toDo in toDos)
                        ToDoListItem(
                          toDo: toDo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${toDos.length} tarefas pedentes',
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showDeleteToDosConfirmaDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Text('Limpar tudo'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(CoisaModel toDo) {
    deletedToDo = toDo;
    deletedToDoPos = toDos.indexOf(toDo);

    setState(() {
      toDos.remove(toDo);
    });
    toDoRepository.saveToDoList(toDos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${toDo.descricao} foi removida com sucesso!',
          style: const TextStyle(
            color: Color(0xff00d7f3),
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              toDos.insert(deletedToDoPos!, deletedToDo!);
            });
            toDoRepository.saveToDoList(toDos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteToDosConfirmaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar tudo?'),
        content: const Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(backgroundColor: const Color(0xff00d7f3)),
            child: const Text('Cancelar'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAllTodos();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Limpar tudo')),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      toDos.clear();
    });
    toDoRepository.saveToDoList(toDos);
  }
}
