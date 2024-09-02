import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gtd_app/models/coisa_model.dart';
import 'package:gtd_app/visual/cores_sistema.dart';
import 'package:intl/intl.dart';

class CoisasItemWidget extends StatelessWidget {
  const CoisasItemWidget({
    super.key,
    required this.coisa,
    required this.lAcoes,
  });

  final CoisaModel coisa;
  final List<Widget> lAcoes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: lAcoes,
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
            coisa: coisa,
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
          DateFormat('dd/MM/yyyy - hh:mm:ss').format(coisa.dataCriacao),
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
