import 'package:flutter/material.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/models/coisa_model.dart';
import 'package:gtd_app/pages/coleta/repository/coisas_repository.dart';
import 'package:gtd_app/pages/coleta/widgets/coisas_item_widget.dart';

class ColetaPage extends StatefulWidget {
  const ColetaPage({super.key});

  @override
  State<ColetaPage> createState() => _ColetaPageState();
}

class _ColetaPageState extends State<ColetaPage> {
  final TextEditingController controller = TextEditingController();
  final CoisasRepository repository = CoisasRepository();

  List<CoisaModel> lCoisas = [];
  String? errorText;

  @override
  void initState() {
    super.initState();

    repository.getListaCoisas().then((value) {
      setState(() => lCoisas = value);
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
                _CadastroCoisasWidget(
                  controller: controller,
                  onAdicionar: _onAdicionar,
                  errorText: errorText,
                ),
                const SizedBox(height: 16),
                _ListaCoisasWidget(
                  lCoisas: lCoisas,
                  onDelete: onDelete,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ContadorItensWidget(
                      qtdItens: lCoisas.length,
                    ),
                    const SizedBox(width: 8),
                    _BotaoLimparTudoWidget(
                      onPressed: showConfirmaLimpeza,
                    ),
                  ],
                )
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
      lCoisas.add(CoisaModel(
        descricao: text,
        dataCriacao: DateTime.now(),
      ));
      errorText = null;
    });

    controller.clear();
    repository.salvaListaCoisas(lCoisas);
  }

  void onDelete(CoisaModel coisa) {
    CoisaModel? deletado = coisa;
    int deletadoIndex = lCoisas.indexOf(coisa);

    setState(() => lCoisas.remove(coisa));
    repository.salvaListaCoisas(lCoisas);
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppMgsConsts.msgRemocao(coisa.descricao)),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: AppMgsConsts.labelBotaoDesfazer,
          onPressed: () {
            setState(() => lCoisas.insert(deletadoIndex, deletado));
            repository.salvaListaCoisas(lCoisas);
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
          _BotaoCancelarLimpezaWidget(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          _BotaConfirmarLimpezaWidget(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => lCoisas.clear());
              repository.salvaListaCoisas(lCoisas);
            },
          ),
        ],
      ),
    );
  }
}

class _CadastroCoisasWidget extends StatelessWidget {
  const _CadastroCoisasWidget({
    required this.controller,
    required this.onAdicionar,
    this.errorText,
  });

  final TextEditingController controller;
  final VoidCallback onAdicionar;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CampoDescricaoWidget(
          controller: controller,
          errorText: errorText,
        ),
        const SizedBox(width: 8),
        _BotaoAdicaoWidget(
          controller: controller,
          onPressed: onAdicionar,
        ),
      ],
    );
  }
}

class _CampoDescricaoWidget extends StatelessWidget {
  const _CampoDescricaoWidget({
    required this.controller,
    this.errorText,
  });

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: AppMgsConsts.labelCampoNovo,
          hintText: AppMgsConsts.hintCampoNovo,
          errorText: errorText,
        ),
      ),
    );
  }
}

class _BotaoAdicaoWidget extends StatelessWidget {
  const _BotaoAdicaoWidget({
    required this.controller,
    required this.onPressed,
  });

  final TextEditingController controller;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(14),
      ),
      child: const Icon(Icons.add, size: 30),
    );
  }
}

class _ListaCoisasWidget extends StatelessWidget {
  const _ListaCoisasWidget({
    required this.lCoisas,
    required this.onDelete,
  });

  final List<CoisaModel> lCoisas;
  final Function(CoisaModel) onDelete;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView(
        shrinkWrap: true,
        children: [
          for (CoisaModel coisa in lCoisas)
            CoisasItemWidget(
              coisa: coisa,
              onDelete: onDelete,
            ),
        ],
      ),
    );
  }
}

class _BotaoCancelarLimpezaWidget extends StatelessWidget {
  const _BotaoCancelarLimpezaWidget({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        AppMgsConsts.labelBotaoCancelar,
      ),
    );
  }
}

class _BotaConfirmarLimpezaWidget extends StatelessWidget {
  const _BotaConfirmarLimpezaWidget({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: const Text(
        AppMgsConsts.labelBotaoConfirmar,
      ),
    );
  }
}

class _ContadorItensWidget extends StatelessWidget {
  const _ContadorItensWidget({required this.qtdItens});

  final int qtdItens;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        AppMgsConsts.msgQtdItensPendentes(qtdItens),
      ),
    );
  }
}

class _BotaoLimparTudoWidget extends StatelessWidget {
  const _BotaoLimparTudoWidget({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(14),
      ),
      child: const Text(AppMgsConsts.labelBotaoLimparTudo),
    );
  }
}
