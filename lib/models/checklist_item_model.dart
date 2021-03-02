//import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

/// Classe modelo utilizada nos itens de lista do tipo Checkbox.
class CheckListItemModel{
  //#region Atributos
  /// Texto para ser exibido junto com o checkbox.
  String texto;

  /// Define se a checkbox está checada.
  bool checado;

  /// ID para auxiliar na identificação do item.
  String id;
  //#endregion Atributos

  //#region Contrutor(es)
  /// Classe de modelo para os 
  CheckListItemModel({@required this.texto, @required this.checado, @required this.id});
  //#endregion Contrutor(es)
}