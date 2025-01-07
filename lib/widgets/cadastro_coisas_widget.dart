import 'package:flutter/material.dart';
import 'package:gtd_app/widgets/botao_adicao_widget.dart';
import 'package:gtd_app/widgets/campo_descricao_widget.dart';

class CadastroCoisasWidget extends StatelessWidget {
  const CadastroCoisasWidget({
    super.key,
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
        CampoDescricaoWidget(
          controller: controller,
          errorText: errorText,
        ),
        const SizedBox(width: 8),
        BotaoAdicaoWidget(
          controller: controller,
          onPressed: onAdicionar,
        ),
      ],
    );
  }
}
