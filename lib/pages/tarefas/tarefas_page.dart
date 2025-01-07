import 'package:flutter/material.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/models/projeto_model.dart';
import 'package:gtd_app/models/tarefa_model.dart';
import 'package:gtd_app/pages/projetos/repository/projetos_repository.dart';
import 'package:gtd_app/pages/tarefas/processo/processa_tarefas_page.dart';
import 'package:gtd_app/pages/tarefas/repository/tarefas_repository.dart';
import 'package:gtd_app/widgets/botao_cancelar_limpeza_widget.dart';
import 'package:gtd_app/widgets/botao_confirmar_limpeza_widget.dart';
import 'package:gtd_app/widgets/botao_limpar_tudo_widget.dart';
import 'package:gtd_app/widgets/cadastro_coisas_widget.dart';
import 'package:gtd_app/widgets/contador_itens_widget.dart';
import 'package:gtd_app/widgets/lista_coisas_widget.dart';
import 'package:uuid/uuid.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  final TextEditingController controller = TextEditingController();
  final ProjetosRepository projetoRepository = ProjetosRepository();
  final TarefasRepository tarefaRepository = TarefasRepository();
  var uuid = const Uuid();

  List<ProjetoModel> lProjetos = [];
  List<TarefaModel> lTarefas = [];
  String? errorText;

  @override
  void initState() {
    super.initState();

    tarefaRepository.getLista().then((value) {
      setState(() => lTarefas = value);
    });

    projetoRepository.getLista().then((value) {
      setState(() => lProjetos = value);
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
                CadastroCoisasWidget(
                  controller: controller,
                  onAdicionar: _onAdicionar,
                  errorText: errorText,
                ),
                const SizedBox(height: 16),
                ListaCoisasWidget(
                  lCoisas: lTarefas,
                  onDelete: (coisa) => onDelete(coisa as TarefaModel),
                  onAtualizaListagem: () {
                    tarefaRepository.salvaLista(lTarefas);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ContadorItensWidget(
                      qtdItens: lTarefas.length,
                    ),
                    const SizedBox(width: 8),
                    BotaoLimparTudoWidget(
                      onPressed: showConfirmaLimpeza,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _BotaoProcessamentoWidget(
                  onPressed: _executarProcesso,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onAdicionar() {
    String text = controller.text;

    if (text.isEmpty) {
      setState(() {
        errorText = AppMgsConsts.msgDescriaoObrigatoria;
      });
      return;
    }

    setState(() {
      lTarefas.add(TarefaModel(
        id: uuid.v4(),
        descricao: text,
        dataCriacao: DateTime.now(),
      ));
      errorText = null;
    });

    controller.clear();
    tarefaRepository.salvaLista(lTarefas);
  }

  void onDelete(TarefaModel tarefa) {
    TarefaModel? deletado = tarefa;
    int deletadoIndex = lTarefas.indexOf(tarefa);

    setState(() => lTarefas.remove(tarefa));
    tarefaRepository.salvaLista(lTarefas);
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppMgsConsts.msgRemocao(tarefa.descricao),
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: AppMgsConsts.labelBotaoDesfazer,
          onPressed: () {
            setState(() => lTarefas.insert(deletadoIndex, deletado));
            tarefaRepository.salvaLista(lTarefas);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showConfirmaLimpeza() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppMgsConsts.titleLimpaTudo),
        content: const Text(AppMgsConsts.msgLimpaTudo),
        actions: [
          BotaoCancelarLimpezaWidget(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          BotaoConfirmarLimpezaWidget(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => lTarefas.clear());
              tarefaRepository.salvaLista(lTarefas);
            },
          ),
        ],
      ),
    );
  }

  void _executarProcesso() {
    if (lTarefas.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return ProcessaTarefasPage(
            lProjetos: lProjetos,
            lTarefas: lTarefas,
            onAtualizaListagem: () => setState(() {}),
          );
        },
      );
    }
  }
}

class _BotaoProcessamentoWidget extends StatelessWidget {
  const _BotaoProcessamentoWidget({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 20),
      child: TextButton(
        onPressed: onPressed,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppMgsConsts.labelProcessar),
            SizedBox(width: 8),
            Icon(Icons.cached_rounded),
          ],
        ),
      ),
    );
  }
}
