import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jsvillela_app/infra/preferencias.dart';

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

    if(ultimaRede == null)
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .orderBy(CAMPO_REDE).get();

    if(filtroPorNome != null && filtroPorNome.isNotEmpty){
      if(ultimaRede == null)
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_REDE)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .where(CAMPO_REDE, isEqualTo: filtroPorNome)
            .get();
      else
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_REDE)
            .startAfterDocument(ultimaRede)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .where(CAMPO_REDE, isEqualTo: filtroPorNome)
            .get();
    }

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .orderBy(CAMPO_REDE)
        .startAfterDocument(ultimaRede)
        .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        .get();
  }


//#endregion Métodos


}