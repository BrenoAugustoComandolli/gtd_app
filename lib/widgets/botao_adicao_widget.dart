import 'package:flutter/material.dart';

class BotaoAdicaoWidget extends StatelessWidget {
  const BotaoAdicaoWidget({
    super.key,
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
