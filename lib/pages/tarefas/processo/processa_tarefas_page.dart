import 'package:flutter/material.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/models/projeto_model.dart';
import 'package:gtd_app/models/tarefa_model.dart';
import 'package:gtd_app/pages/listas/repository/lista_repository.dart';
import 'package:gtd_app/pages/projetos/repository/projetos_repository.dart';
import 'package:gtd_app/pages/tarefas/repository/tarefas_repository.dart';

class ProcessaTarefasPage extends StatefulWidget {
  const ProcessaTarefasPage({
    super.key,
    required this.lProjetos,
    required this.lTarefas,
    required this.onAtualizaListagem,
  }); 

  final List<ProjetoModel> lProjetos;
  final List<TarefaModel> lTarefas;
  final VoidCallback onAtualizaListagem;

  @override
  State<ProcessaTarefasPage> createState() => _ProcessaTarefasPageState();
}

class _ProcessaTarefasPageState extends State<ProcessaTarefasPage> {
  final TarefasRepository tarefasRepository = TarefasRepository();
  final ListaRepository listaRepository = ListaRepository();
  final ProjetosRepository projetosRepository = ProjetosRepository();
  final TextEditingController controller = TextEditingController();

  late TarefaModel tarefaAtual;

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
              _DescricaoTarefaWidget(
                tarefaAtual: tarefaAtual,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: _AcoesWidget(
                    controller: controller,
                    listaRepository: listaRepository,
                    tarefasRepository: tarefasRepository,
                    projetosRepository: projetosRepository,
                    tarefaAtual: tarefaAtual,
                    lProjetos: widget.lProjetos,
                    lTarefas: widget.lTarefas,
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
    if (widget.lTarefas.isNotEmpty) {
      final tarefa = widget.lTarefas[0];
      setState(() => tarefaAtual = tarefa);
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

class _DescricaoTarefaWidget extends StatelessWidget {
  const _DescricaoTarefaWidget({
    required this.tarefaAtual,
  });

  final TarefaModel tarefaAtual;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 250),
      child: SingleChildScrollView(
        child: Center(
          child: Text(
            tarefaAtual.descricao,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

class _AcoesWidget extends StatefulWidget {
  const _AcoesWidget({
    required this.controller,
    required this.listaRepository,
    required this.tarefasRepository,
    required this.projetosRepository,
    required this.tarefaAtual,
    required this.lProjetos,
    required this.lTarefas,
    required this.onProcessar,
  });

  final TextEditingController controller;
  final ListaRepository listaRepository;
  final TarefasRepository tarefasRepository;
  final ProjetosRepository projetosRepository;
  final List<ProjetoModel> lProjetos;
  final TarefaModel tarefaAtual;
  final List<TarefaModel> lTarefas;
  final VoidCallback onProcessar;

  @override
  State<_AcoesWidget> createState() => _AcoesWidgetState();
}

class _AcoesWidgetState extends State<_AcoesWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return _ComboProjetos(
                maxWidth: constraints.maxWidth,
                lProjetos: widget.lProjetos,
                tarefaAtual: widget.tarefaAtual,
              );
            },
          ),
          const SizedBox(height: 20),
          _BotaoMoverProximasWidget(
            onPressed: () async => await moverParaLista(
              widget.listaRepository.getListaProximas,
              widget.listaRepository.salvaListaProximas,
            ),
          ),
          const SizedBox(width: 10),
          _BotaoMoverEsperaWidget(
            onPressed: () async => await moverParaLista(
              widget.listaRepository.getListaEspera,
              widget.listaRepository.salvaListaEspera,
            ),
          ),
          const SizedBox(width: 10),
          _BotaoMoverTalvezWidget(
            onPressed: () async => await moverParaLista(
              widget.listaRepository.getListaTalvez,
              widget.listaRepository.salvaListaTalvez,
            ),
          ),
          const SizedBox(width: 10),
          _BotaoMoverAgendaWidget(
            onPressed: () async => await moverParaLista(
              widget.listaRepository.getListaAgendados,
              widget.listaRepository.salvaListaAgendados,
            ),
          ),
          const SizedBox(width: 10),
          _BotaoFinalizarWidget(
            onPressed: () async => await moverParaLista(
              widget.listaRepository.getListaFinalizados,
              widget.listaRepository.salvaListaFinalizados,
            ),
          ),
          const SizedBox(width: 10),
          _BotaoRemoverWidget(
            onPressed: () {
              widget.lTarefas.remove(widget.tarefaAtual);
              widget.tarefasRepository.salvaLista(widget.lTarefas);
              widget.controller.text = "";
              widget.onProcessar();
            },
          ),
        ],
      ),
    );
  }

  Future<void> moverParaLista(
    Future<List<TarefaModel>> Function() getLista,
    Future<void> Function(List<TarefaModel>) salvaLista,
  ) async {
    await trataNomeTarefa();

    await getLista().then((lista) {
      lista.add(widget.tarefaAtual);
      widget.lTarefas.remove(widget.tarefaAtual);
      salvaLista(lista);
      widget.tarefasRepository.salvaLista(widget.lTarefas);
      widget.onProcessar();
    });
  }

  Future<void> trataNomeTarefa() async {
    if (widget.tarefaAtual.projetoId != null) {
      ProjetoModel? projeto = await widget.projetosRepository.getProjetoById(widget.tarefaAtual.projetoId!);
      if (projeto?.descricao != null) {
        widget.tarefaAtual.descricao = "[${projeto!.descricao}]: ${widget.tarefaAtual.descricao}";
      }
    }
  }
}

class _ComboProjetos extends StatelessWidget {
  const _ComboProjetos({
    required this.maxWidth,
    required this.lProjetos,
    required this.tarefaAtual,
  });

  final double maxWidth;
  final List<ProjetoModel> lProjetos;
  final TarefaModel tarefaAtual;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 300),
      child: DropdownMenu<ProjetoModel?>(
        width: maxWidth,
        label: const Text(AppMgsConsts.labelProjetos),
        dropdownMenuEntries: [
          const DropdownMenuEntry<ProjetoModel?>(
            value: null,
            label: AppMgsConsts.labelComboVazia,
          ),
          ...lProjetos.map(
            (umProjeto) => DropdownMenuEntry<ProjetoModel?>(
              value: umProjeto,
              label: umProjeto.descricao,
            ),
          ),
        ],
        onSelected: (value) {
          tarefaAtual.projetoId = value?.id;
        },
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
