import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model para redeiros.
class RedeiroModel extends Model{

  //#region Atributos
  //#endregion Atributos

  //#region Constantes
  /// Nome do identificador para a coleção "redeiros" utilizado no Firebase.
  static const String NOME_COLECAO = "redeiros";

  /// Nome do identificador para o campo "nome" utilizado na collection do Firebase.
  static const String CAMPO_NOME = "nome";

  /// Nome do identificador para o campo "celular" utilizado na collection do Firebase.
  static const String CAMPO_CELULAR = "celular";

  /// Nome do identificador para o campo "email" utilizado na collection do Firebase.
  static const String CAMPO_EMAIL = "email";

  /// Nome do identificador para o campo "whatsapp" utilizado na collection do Firebase.
  static const String CAMPO_WHATSAPP = "whatsapp";

  /// Nome do identificador para o campo "endereco" utilizado na collection do Firebase.
  static const String CAMPO_ENDERECO = "endereco";

  /// Nome do identificador para o campo "ativo" utilizado na collection do Firebase.
  static const String CAMPO_ATIVO = "ativo";

  /// Nome do identificador para a subcoleção "grupos" utilizado na collection do Firebase.
  static const String SUBCOLECAO_GRUPOS = "grupos_do_redeiro";

  /// Nome do identificador para a subcoleção "caderno" utilizado na collection do Firebase.
  static const String SUBCOLECAO_CADERNO = "caderno";
  //#endregion Constantes

  //#region Métodos
  ///Cadastra um redeiro no Firebase.
  void cadastrarRedeiro({@required Map<String, dynamic> dadosDoRedeiro, @required VoidCallback onSuccess, @required VoidCallback onFail}){
    FirebaseFirestore.instance.collection(NOME_COLECAO).add({
      CAMPO_NOME : dadosDoRedeiro[CAMPO_NOME],
      CAMPO_CELULAR : dadosDoRedeiro[CAMPO_CELULAR],
      CAMPO_EMAIL : dadosDoRedeiro[CAMPO_EMAIL],
      CAMPO_WHATSAPP : dadosDoRedeiro[CAMPO_WHATSAPP],
      CAMPO_ENDERECO : dadosDoRedeiro[CAMPO_ENDERECO],
      CAMPO_ATIVO : dadosDoRedeiro[CAMPO_ATIVO],
      SUBCOLECAO_GRUPOS : dadosDoRedeiro[SUBCOLECAO_GRUPOS]
    }).then((value) => onSuccess()).catchError((e){
      onFail();
    });
  }

  //#endregion Métodos

}