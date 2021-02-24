import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model para rede.
class RedeModel extends Model{

  //#region Atributos
  //#endregion Atributos

  //#region Constantes
  /// Nome do identificador para a coleção "redes" utilizado no Firebase.
  static const String NOME_COLECAO = "redes";

  /// Nome do identificador para o campo "nome_rede" utilizado na collection.
  static const String CAMPO_REDE = "nome_rede";

  /// Nome do identificador para o campo "vlr_unitario" utilizado na collection do Firebase.
  static const String CAMPO_VALOR_UNITARIO = "vlr_unitario";

  //#region Métodos
  ///Cadastra um redeiro no Firebase.
  void cadastrarRede({@required Map<String, dynamic> dadosDaRede, @required VoidCallback onSuccess, @required VoidCallback onFail}){
    FirebaseFirestore.instance.collection(NOME_COLECAO).add({
      CAMPO_REDE : dadosDaRede[CAMPO_REDE],
      CAMPO_VALOR_UNITARIO : dadosDaRede[CAMPO_VALOR_UNITARIO]
    }).then((value) => onSuccess()).catchError((e){
      onFail();
    });
  }
  //#endregion Métodos

}