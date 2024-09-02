import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/models/coisa_model.dart';
import 'package:gtd_app/pages/coleta/widgets/coisas_item_widget.dart';
import 'package:gtd_app/pages/listas/repository/lista_repository.dart';
import 'package:gtd_app/visual/cores_sistema.dart';

class ListasPage extends StatefulWidget {
  const ListasPage({super.key});

  @override
  State<ListasPage> createState() => _ListasPageState();
}

class _ListasPageState extends State<ListasPage> {
  final ListaRepository repository = ListaRepository();

  late final Map<String, List<CoisaModel>> listas;
  String selecionada = AppMgsConsts.titleProximas;

  @override
  void initState() {
    super.initState();

    listas = {
      AppMgsConsts.titleProximas: [],
      AppMgsConsts.titleEspera: [],
      AppMgsConsts.titleTalvez: [],
      AppMgsConsts.titleAgendados: [],
      AppMgsConsts.titleFinalizados: [],
    };

    final proximasFuture = repository.getListaProximas();
    final esperaFuture = repository.getListaEspera();
    final talvezFuture = repository.getListaTalvez();
    final agendadosFuture = repository.getListaAgendados();
    final finalizadosFuture = repository.getListaFinalizados();

    Future.wait([
      proximasFuture,
      esperaFuture,
      talvezFuture,
      agendadosFuture,
      finalizadosFuture,
    ]).then((resultados) {
      setState(() {
        listas[AppMgsConsts.titleProximas] = resultados[0];
        listas[AppMgsConsts.titleEspera] = resultados[1];
        listas[AppMgsConsts.titleTalvez] = resultados[2];
        listas[AppMgsConsts.titleAgendados] = resultados[3];
        listas[AppMgsConsts.titleFinalizados] = resultados[4];
      });
    }).catchError((e) {
      debugPrint(AppMgsConsts.msgErroCarregamentoLista(e));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppMgsConsts.titleListasPage),
        actions: [
          _ComboListasWidget(
            listas: listas,
            selecionada: selecionada,
            onChanged: (String? novaLista) {
              setState(() {
                if (novaLista != null) {
                  selecionada = novaLista;
                }
              });
            },
          ),
        ],
      ),
      body: _ListasWidget(
        listas: listas,
        selecionada: selecionada,
        onDelete: onDelete,
        onMove: onMove,
        onAtualizaListagem: () {
          repository.salvaListas(listas);
          setState(() {});
        },
      ),
    );
  }

  void onDelete(CoisaModel coisa) {
    CoisaModel? deletado = coisa;
    List<CoisaModel> lSelecionada = listas[selecionada]!;
    int deletadoIndex = lSelecionada.indexOf(coisa);

    setState(() => lSelecionada.remove(coisa));
    repository.salvaListas(listas);
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppMgsConsts.msgRemocao(coisa.descricao),
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: AppMgsConsts.labelBotaoDesfazer,
          onPressed: () {
            setState(() => lSelecionada.insert(deletadoIndex, deletado));
            repository.salvaListas(listas);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void onMove(CoisaModel coisa) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 50),
                child: const Text(
                  AppMgsConsts.titleMovendoItem,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...listas.keys.map((String key) {
                return ListTile(
                  leading: const Icon(
                    Icons.topic_sharp,
                    color: CoresSistema.primaryColor,
                  ),
                  title: Text(key),
                  onTap: () {
                    setState(() {
                      listas[selecionada]!.remove(coisa);
                      listas[key]!.add(coisa);
                      repository.salvaListas(listas);
                    });
                    Navigator.of(context).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _ComboListasWidget extends StatelessWidget {
  const _ComboListasWidget({
    required this.listas,
    required this.selecionada,
    required this.onChanged,
  });

  final String selecionada;
  final Map<String, List<CoisaModel>> listas;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selecionada,
      dropdownColor: CoresSistema.primaryColor,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      items: listas.keys.map((String key) {
        return DropdownMenuItem<String>(
          value: key,
          child: Text(key),
        );
      }).toList(),
      borderRadius: BorderRadius.circular(10),
      onChanged: onChanged,
    );
  }
}

class _ListasWidget extends StatelessWidget {
  const _ListasWidget({
    required this.selecionada,
    required this.listas,
    required this.onDelete,
    required this.onMove,
    required this.onAtualizaListagem,
  });

  final String selecionada;
  final Map<String, List<CoisaModel>> listas;
  final Function(CoisaModel coisa) onDelete;
  final Function(CoisaModel coisa) onMove;
  final VoidCallback onAtualizaListagem;

  @override
  Widget build(BuildContext context) {
    if (listas[selecionada]!.isEmpty) {
      return const _NenhumItemWidget();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ReorderableListView(
        onReorder: _onReorder,
        children: listas[selecionada]!.map((CoisaModel coisa) {
          return CoisasItemWidget(
            key: Key(coisa.id),
            coisa: coisa,
            lAcoes: [
              SlidableAction(
                onPressed: (BuildContext context) => onDelete(coisa),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: AppMgsConsts.labelBotaoDeletar,
              ),
              SlidableAction(
                onPressed: (BuildContext context) => onMove(coisa),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.move_to_inbox,
                label: AppMgsConsts.labelBotaoMover,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    final lSelecionada = listas[selecionada]!;

    if (newIndex > oldIndex) newIndex -= 1;
 
    lSelecionada.insert(newIndex, lSelecionada.removeAt(oldIndex));
    onAtualizaListagem();
  }
}

class _NenhumItemWidget extends StatelessWidget {
  const _NenhumItemWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        AppMgsConsts.labelNenhumItem,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
