import 'package:flutter/material.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';

class ContadorItensWidget extends StatelessWidget {
  const ContadorItensWidget({
    super.key,
    required this.qtdItens,
  });

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
