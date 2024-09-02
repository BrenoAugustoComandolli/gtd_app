import 'package:flutter/material.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/models/coisa_model.dart';
import 'package:gtd_app/pages/coleta/repository/coisas_repository.dart';
import 'package:gtd_app/pages/listas/repository/lista_repository.dart';
import 'package:gtd_app/visual/cores_sistema.dart';

class ProcessaCoisasPage extends StatefulWidget {
  const ProcessaCoisasPage({
    super.key,
    required this.lCoisas,
    required this.onAtualizaListagem,
  });

  final List<CoisaModel> lCoisas;
  final VoidCallback onAtualizaListagem;

  @override
  State<ProcessaCoisasPage> createState() => _ProcessaCoisasPageState();
}

class _ProcessaCoisasPageState extends State<ProcessaCoisasPage> {
  final CoisasRepository coisaRepository = CoisasRepository();
  final ListaRepository listaRepository = ListaRepository();
  final TextEditingController controller = TextEditingController();

  late CoisaModel coisaAtual;

  @override
  void initState() {
    super.initState();
    _processar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _BotaoVoltarWidget(
          onAtualizaListagem: widget.onAtualizaListagem,
        ),
        title: const Text(
          AppMgsConsts.titleProcessamento,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const _DescricaoOperacaoWidget(),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: SingleChildScrollView(
                  child: Center(
                    child: Text(
                      coisaAtual.descricao,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: _AcoesWidget(
                    controller: controller,
                    listaRepository: listaRepository,
                    coisaRepository: coisaRepository,
                    coisaAtual: coisaAtual,
                    lCoisas: widget.lCoisas,
                    onProcessar: () {
                      _processar();
                      setState(() {});
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _processar() {
    if (widget.lCoisas.isNotEmpty) {
      final coisa = widget.lCoisas[0];
      setState(() => coisaAtual = coisa);
    } else {
      widget.onAtualizaListagem();
      Navigator.of(context).pop();
    }
  }
}

class _BotaoVoltarWidget extends StatelessWidget {
  const _BotaoVoltarWidget({
    required this.onAtualizaListagem,
  });

  final VoidCallback onAtualizaListagem;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        onAtualizaListagem();
        Navigator.of(context).pop();
      },
      style: const ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide.none),
      ),
    );
  }
}

class _AcoesWidget extends StatefulWidget {
  const _AcoesWidget({
    required this.controller,
    required this.listaRepository,
    required this.coisaRepository,
    required this.coisaAtual,
    required this.lCoisas,
    required this.onProcessar,
  });

  final TextEditingController controller;
  final ListaRepository listaRepository;
  final CoisasRepository coisaRepository;
  final CoisaModel coisaAtual;
  final List<CoisaModel> lCoisas;
  final VoidCallback onProcessar;

  @override
  State<_AcoesWidget> createState() => _AcoesWidgetState();
}

class _AcoesWidgetState extends State<_AcoesWidget> {
  bool isProjeto = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _AreaProjetoWidget(
            isProjeto: isProjeto,
            controller: widget.controller,
            onCheck: (bool? value) {
              setState(() => isProjeto = value!);
            },
            errorText: errorText,
          ),
          const SizedBox(height: 20),
          _BotaoMoverProximasWidget(
            onPressed: () => moverParaLista(
              widget.listaRepository.getListaProximas,
              widget.listaRepository.salvaListaProximas,
            ),
          ),
          const SizedBox(width: 10),
          _BotaoMoverEsperaWidget(
            onPressed: () => moverParaLista(
              widget.listaRepository.getListaEspera,
              widget.listaRepository.salvaListaEspera,
            ),
          ),
          const SizedBox(width: 10),
          _BotaoMoverTalvezWidget(
            onPressed: () => moverParaLista(
              widget.listaRepository.getListaTalvez,
              widget.listaRepository.salvaListaTalvez,
            ),
          ),
          const SizedBox(width: 10),
          _BotaoMoverAgendaWidget(
            onPressed: () => moverParaLista(
              widget.listaRepository.getListaAgendados,
              widget.listaRepository.salvaListaAgendados,
            ),
          ),
          const SizedBox(width: 10),
          _BotaoFinalizarWidget(
            onPressed: () => moverParaLista(
              widget.listaRepository.getListaFinalizados,
              widget.listaRepository.salvaListaFinalizados,
            ),
          ),
          const SizedBox(width: 10),
          _BotaoRemoverWidget(
            onPressed: () {
              widget.lCoisas.remove(widget.coisaAtual);
              widget.coisaRepository.salvaListaCoisas(widget.lCoisas);
              widget.controller.text = "";
              widget.onProcessar();
            },
          ),
        ],
      ),
    );
  }

  void moverParaLista(
    Future<List<CoisaModel>> Function() getLista,
    Future<void> Function(List<CoisaModel>) salvaLista,
  ) {
    bool isValido = validaObrigatoriedade();
    if (isValido) {
      getLista().then((lista) {
        lista.add(widget.coisaAtual);
        widget.lCoisas.remove(widget.coisaAtual);
        salvaLista(lista);
        widget.coisaRepository.salvaListaCoisas(widget.lCoisas);
        widget.onProcessar();
      });
    }
  }

  bool validaObrigatoriedade() {
    if (isProjeto) {
      String text = widget.controller.text;
      if (text.isEmpty) {
        setState(() {
          errorText = AppMgsConsts.msgDescriaoObrigatoria;
        });
        return false;
      }
      widget.coisaAtual.descricao = "[${widget.coisaAtual.descricao}]: $text";
    }
    errorText = null;
    return true;
  }
}

class _DescricaoOperacaoWidget extends StatelessWidget {
  const _DescricaoOperacaoWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        AppMgsConsts.labelDescricaoOperacao,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

class _AreaProjetoWidget extends StatelessWidget {
  const _AreaProjetoWidget({
    required this.isProjeto,
    required this.controller,
    required this.onCheck,
    this.errorText,
  });

  final bool isProjeto;
  final TextEditingController controller;
  final ValueChanged<bool?>? onCheck;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100),
      child: Row(
        children: [
          Checkbox(
            value: isProjeto,
            activeColor: CoresSistema.primaryColor,
            onChanged: onCheck,
          ),
          const Text(AppMgsConsts.labelEhProjeto),
          const SizedBox(width: 10),
          Visibility(
            visible: isProjeto,
            child: _CampoEdicaoProjetoWidget(
              controller: controller,
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }
}

class _CampoEdicaoProjetoWidget extends StatelessWidget {
  const _CampoEdicaoProjetoWidget({
    required this.controller,
    this.errorText,
  });

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextField(
          style: const TextStyle(fontSize: 16),
          controller: controller,
          decoration: InputDecoration(
            labelText: AppMgsConsts.labelPrimeiroPasso,
            hintText: AppMgsConsts.hintPrimeiroPasso,
            errorText: errorText,
          ),
        ),
      ),
    );
  }
}

class _BotaoMoverProximasWidget extends StatelessWidget {
  const _BotaoMoverProximasWidget({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppMgsConsts.titleProximaAcao),
          SizedBox(width: 10),
          Icon(Icons.next_plan_outlined),
        ],
      ),
    );
  }
}

class _BotaoMoverEsperaWidget extends StatelessWidget {
  const _BotaoMoverEsperaWidget({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppMgsConsts.labelEmEspera),
          SizedBox(width: 10),
          Icon(Icons.outlined_flag_rounded),
        ],
      ),
    );
  }
}

class _BotaoMoverTalvezWidget extends StatelessWidget {
  const _BotaoMoverTalvezWidget({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppMgsConsts.labelMoverTalvez),
          SizedBox(width: 10),
          Icon(Icons.drive_file_move_rtl_outlined),
        ],
      ),
    );
  }
}

class _BotaoMoverAgendaWidget extends StatelessWidget {
  const _BotaoMoverAgendaWidget({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppMgsConsts.labelAgendar),
          SizedBox(width: 10),
          Icon(Icons.calendar_month),
        ],
      ),
    );
  }
}

class _BotaoFinalizarWidget extends StatelessWidget {
  const _BotaoFinalizarWidget({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.green),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppMgsConsts.labelFinalizar),
          SizedBox(width: 10),
          Icon(Icons.check_circle_outline_sharp),
        ],
      ),
    );
  }
}

class _BotaoRemoverWidget extends StatelessWidget {
  const _BotaoRemoverWidget({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.red),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppMgsConsts.labelBotaoDeletar),
          SizedBox(width: 10),
          Icon(Icons.delete_outline_outlined),
        ],
      ),
    );
  }
}
