import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
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

  /// Nome do identificador para o id do documento quando gravado em outras collections do Firebase.
  static const String ID_COLECAO = "id";
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

  /// Busca um grupo de redeiros por ID.
  Future<DocumentSnapshot> carregarGrupoPorId(String idsDoGrupo){

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .doc(idsDoGrupo)
        .get();
  }

  /// Converte um snapshot em um objeto GrupoDeRedeirosDmo.
  GrupoDeRedeirosDmo converterSnapshotEmGrupoDeRedeiro(DocumentSnapshot grupo){

    return GrupoDeRedeirosDmo(
        idGrupo: grupo.id,
        nomeGrupo: grupo[CAMPO_NOME]
    );
  }
  //#endregion Métodos

}