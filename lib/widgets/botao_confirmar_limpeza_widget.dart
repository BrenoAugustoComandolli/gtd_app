import 'package:flutter/material.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';

class BotaoConfirmarLimpezaWidget extends StatelessWidget {
  const BotaoConfirmarLimpezaWidget({
    super.key,
    required this.onPressed,
  });

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
