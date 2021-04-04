import 'package:flutter/material.dart';
import 'package:jsvillela_app/models/checklist_item_model.dart';

/// Widget utilizada nos itens de lista do tipo Checkbox.
class ChecklistItem extends StatefulWidget {

  //#region Atributos
  /// Model que contém os atributos para o Checkbox.
  final CheckListItemModel checkListItemModel;

  /// Ícone a ser exibido do lado esquerdo do CheckBox.
  final Icon iconeDoCheckBox;
  //#endregion Atributos

  //#region Contrutor(es)
  /// Classe de modelo para os
  ChecklistItem({@required this.checkListItemModel, @required this.iconeDoCheckBox});
  //#endregion Contrutor(es)

  @override
  _ChecklistItemState createState() => _ChecklistItemState();
}

class _ChecklistItemState extends State<ChecklistItem> {
  @override
  Widget build(BuildContext context) {

    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4),
      title: Text(widget.checkListItemModel.texto),
      secondary: widget.iconeDoCheckBox,
      value: widget.checkListItemModel.checado,
      onChanged: (bool valor){
        setState(() {
          widget.checkListItemModel.checado = valor;
        });
      },
    );
    return ListTile(
      onTap: (){ setState(() { widget.checkListItemModel.checado = !widget.checkListItemModel.checado;});},
      title: Text(widget.checkListItemModel.texto),
      leading: Checkbox(
        value: widget.checkListItemModel.checado,
        onChanged: (bool valor){
          setState(() {
            widget.checkListItemModel.checado = valor;
          });
        },
      ),
    );
  }
}


