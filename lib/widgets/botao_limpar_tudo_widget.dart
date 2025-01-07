import 'package:flutter/material.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';

class BotaoLimparTudoWidget extends StatelessWidget {
  const BotaoLimparTudoWidget({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(14)),
      child: const Text(AppMgsConsts.labelBotaoLimparTudo),
    );
  }
}
