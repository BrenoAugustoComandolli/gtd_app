import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gtd_app/consts/app_mgs_consts.dart';
import 'package:gtd_app/models/coisa_model.dart';
import 'package:gtd_app/widgets/coisas_item_widget.dart';

class ListaCoisasWidget extends StatelessWidget {
  const ListaCoisasWidget({
    super.key,
    required this.lCoisas,
    required this.onDelete,
    required this.onAtualizaListagem,
  });

  final List<CoisaModel> lCoisas;
  final Function(CoisaModel coisa) onDelete;
  final VoidCallback onAtualizaListagem;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ReorderableListView(
        shrinkWrap: true,
        onReorder: _onReorder,
        children: [
          for (CoisaModel coisa in lCoisas)
            CoisasItemWidget(
              key: Key(coisa.id),
              coisa: coisa,
              onEditar: onAtualizaListagem,
              lAcoes: [
                SlidableAction(
                  onPressed: (BuildContext context) => onDelete(coisa),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: AppMgsConsts.labelBotaoDeletar,
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    lCoisas.insert(newIndex, lCoisas.removeAt(oldIndex));
    onAtualizaListagem();
  }
}
