import 'package:flutter/material.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/models/projeto_model.dart';
import 'package:gtd_app/pages/projetos/repository/projetos_repository.dart';
import 'package:gtd_app/widgets/botao_cancelar_limpeza_widget.dart';
import 'package:gtd_app/widgets/botao_confirmar_limpeza_widget.dart';
import 'package:gtd_app/widgets/botao_limpar_tudo_widget.dart';
import 'package:gtd_app/widgets/cadastro_coisas_widget.dart';
import 'package:gtd_app/widgets/contador_itens_widget.dart';
import 'package:gtd_app/widgets/lista_coisas_widget.dart';
import 'package:uuid/uuid.dart';

class ProjetosPage extends StatefulWidget {
  const ProjetosPage({super.key});

  @override
  State<ProjetosPage> createState() => _ProjetosPageState();
}

class _ProjetosPageState extends State<ProjetosPage> {
  final TextEditingController controller = TextEditingController();
  final ProjetosRepository repository = ProjetosRepository();
  var uuid = const Uuid();

  List<ProjetoModel> lProjetos = [];
  String? errorText;

  @override
  void initState() {
    super.initState();

    repository.getLista().then((value) {
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
                  lCoisas: lProjetos,
                  onDelete: (coisa) => onDelete(coisa as ProjetoModel),
                  onAtualizaListagem: () {
                    repository.salvaLista(lProjetos);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ContadorItensWidget(
                      qtdItens: lProjetos.length,
                    ),
                    const SizedBox(width: 8),
                    BotaoLimparTudoWidget(
                      onPressed: showConfirmaLimpeza,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
      lProjetos.add(ProjetoModel(
        id: uuid.v4(),
        descricao: text,
        dataCriacao: DateTime.now(),
      ));
      errorText = null;
    });

    controller.clear();
    repository.salvaLista(lProjetos);
  }

  void onDelete(ProjetoModel projeto) {
    ProjetoModel? deletado = projeto;
    int deletadoIndex = lProjetos.indexOf(projeto);

    setState(() => lProjetos.remove(projeto));
    repository.salvaLista(lProjetos);
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppMgsConsts.msgRemocao(projeto.descricao),
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: AppMgsConsts.labelBotaoDesfazer,
          onPressed: () {
            setState(() => lProjetos.insert(deletadoIndex, deletado));
            repository.salvaLista(lProjetos);
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
              setState(() => lProjetos.clear());
              repository.salvaLista(lProjetos);
            },
          ),
        ],
      ),
    );
  }
}
