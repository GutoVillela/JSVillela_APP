import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model para grupo de redeiros.
class GrupoDeRedeirosModel extends Model{

  //#region Atributos
  //#endregion Atributos

  //#region Constantes
  /// Nome do identificador para a coleção "grupos_de_redeiros" utilizado no Firebase.
  static const String NOME_COLECAO = "grupos_de_redeiros";

  /// Nome do identificador para o campo "nome_grupo" utilizado na collection.
  static const String CAMPO_NOME = "nome_grupo";
  //#endregion Constantes

  //#region Métodos
  ///Cadastra um grupo de redeiros no Firebase.
  void cadastrarGrupoDeRedeiros({@required Map<String, dynamic> dadosDoGrupo, @required VoidCallback onSuccess, @required VoidCallback onFail}){
    FirebaseFirestore.instance.collection(NOME_COLECAO).add({
      CAMPO_NOME : dadosDoGrupo[CAMPO_NOME],
    }).then((value) => onSuccess()).catchError((e){
      onFail();
    });
  }
  //#endregion Métodos

}