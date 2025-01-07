import 'package:flutter/material.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';

class BotaoCancelarLimpezaWidget extends StatelessWidget {
  const BotaoCancelarLimpezaWidget({
    super.key,
    required this.onPressed,
  });

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
