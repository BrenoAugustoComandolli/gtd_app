import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';

class CampoDescricaoWidget extends StatelessWidget {
  const CampoDescricaoWidget({
    super.key,
    required this.controller,
    this.errorText,
  });

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        inputFormatters: [LengthLimitingTextInputFormatter(100)],
        decoration: InputDecoration(
          labelText: AppMgsConsts.labelCampoNovo,
          hintText: AppMgsConsts.hintCampoNovo,
          errorText: errorText,
        ),
      ),
    );
  }
}
