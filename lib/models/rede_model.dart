import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/dml/rede_dmo.dart';

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
  /// Carrega as redes de forma paginada
  Future<QuerySnapshot> carregarRedesPaginadas(DocumentSnapshot ultimaRede, String filtroPorNome) {

    if(filtroPorNome != null && filtroPorNome.isNotEmpty){
      if(ultimaRede == null)
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_REDE)
            .startAt([filtroPorNome])
            .endAt([filtroPorNome + "\uf8ff"])
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      else
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_REDE)
            .startAt([filtroPorNome])
            .endAt([filtroPorNome + "\uf8ff"])
            .startAfterDocument(ultimaRede)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
    }

    if(ultimaRede == null)
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .orderBy(CAMPO_REDE).get();

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .orderBy(CAMPO_REDE)
        .startAfterDocument(ultimaRede)
        .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        .get();
  }

  RedeDmo converterSnapshotEmRede(DocumentSnapshot rede){

    return RedeDmo(
        id: rede.id,
        nome_rede: rede[CAMPO_REDE],
        valor_unitario_rede: rede[CAMPO_VALOR_UNITARIO]
    );
  }
//#endregion Métodos
}