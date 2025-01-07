import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/models/coisa_model.dart';
import 'package:gtd_app/pages/tarefas/repository/tarefas_repository.dart';
import 'package:gtd_app/visual/cores_sistema.dart';
import 'package:intl/intl.dart';

class CoisasItemWidget extends StatefulWidget {
  const CoisasItemWidget({
    super.key,
    required this.onEditar,
    required this.coisa,
    required this.lAcoes,
  });

  final VoidCallback onEditar;
  final CoisaModel coisa;
  final List<Widget> lAcoes;

  @override
  State<CoisasItemWidget> createState() => _CoisasItemWidgetState();
}

class _CoisasItemWidgetState extends State<CoisasItemWidget> {
  final TarefasRepository tarefasRepository = TarefasRepository();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            _EditarItemWidget(
              onSalvar: widget.onEditar,
              tarefasRepository: tarefasRepository,
              coisa: widget.coisa,
              formKey: formKey,
            )
          ],
        ),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: widget.lAcoes,
        ),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CoresSistema.primaryColor.withOpacity(0.30),
          ),
          padding: const EdgeInsets.all(16),
          child: _ConteudoCoisaWidget(
            coisa: widget.coisa,
          ),
        ),
      ),
    );
  }
}

class _ConteudoCoisaWidget extends StatelessWidget {
  const _ConteudoCoisaWidget({required this.coisa});

  final CoisaModel coisa;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('dd/MM/yyyy - HH:mm:ss').format(coisa.dataCriacao),
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          coisa.descricao,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _EditarItemWidget extends StatelessWidget {
  const _EditarItemWidget({
    required this.onSalvar,
    required this.tarefasRepository,
    required this.formKey,
    required this.coisa,
  });

  final VoidCallback onSalvar;
  final TarefasRepository tarefasRepository;
  final GlobalKey<FormState> formKey;
  final CoisaModel coisa;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: (BuildContext context) => onEditar(context, coisa),
      backgroundColor: Colors.lightGreen,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: AppMgsConsts.labelBotaoEditar,
    );
  }

  void onEditar(BuildContext context, CoisaModel coisa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppMgsConsts.labelJanelaEditar),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_InputDescricaoWidget(coisa: coisa)],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppMgsConsts.labelBotaoCancelar),
          ),
          ElevatedButton(
            onPressed: () => _onSalvar(context),
            child: const Text(AppMgsConsts.labelBotaoSalvar),
          ),
        ],
      ),
    );
  }

  void _onSalvar(BuildContext context) {
    if (formKey.currentState!.validate()) {
      onSalvar();
      Navigator.of(context).pop();
    }
  }
}

class _InputDescricaoWidget extends StatelessWidget {
  const _InputDescricaoWidget({
    required this.coisa,
  });

  final CoisaModel coisa;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(100)],
      decoration: const InputDecoration(labelText: AppMgsConsts.labelDescricao),
      onChanged: (value) => coisa.descricao = value,
      validator: _onValidar,
    );
  }

  String? _onValidar(value) {
    if (value == null || value.isEmpty) {
      return AppMgsConsts.msgDescricaoObrigatoria;
    }
    return null;
  }
}
