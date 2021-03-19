import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model para recolhimentos.
class RecolhimentoModel extends Model{

  //#region Constantes
  
  /// Nome do identificador para a coleção "recolhimentos" utilizado no Firebase.
  static const String NOME_COLECAO = "recolhimentos";

  /// Nome do identificador para o campo "data_recolhimento" utilizado na collection do Firebase.
  static const String CAMPO_DATA_RECOLHIMENTO = "data_recolhimento";

  /// Nome do identificador para o campo "data_finalizado" utilizado na collection do Firebase.
  static const String CAMPO_DATA_FINALIZADO = "data_finalizado";

  /// Nome do identificador para o campo "grupos_do_recolhimento" utilizado na collection do Firebase.
  static const String CAMPO_GRUPOS_DO_RECOLHIMENTO = "grupos_do_recolhimento";

  //#endregion Constantes

  //#region Métodos
  ///Cadastra um recolhimento no Firebase.
  void cadastrarRecolhimento({@required RecolhimentoDmo dadosDoRecolhimento, @required Function onSuccess, @required Function onFail}){

    FirebaseFirestore.instance.collection(NOME_COLECAO).add({
      CAMPO_DATA_RECOLHIMENTO : dadosDoRecolhimento.dataDoRecolhimento,
      CAMPO_DATA_FINALIZADO : null,
      CAMPO_GRUPOS_DO_RECOLHIMENTO : dadosDoRecolhimento.gruposDoRecolhimento.map((e) => e.idGrupo).toList()
    }).then((value) => onSuccess()).catchError((e){
      print(e.toString());
      onFail();
    });
  }

  /// Carrega os recolhimentos de forma paginada diretamente do Firebase.
  Future<QuerySnapshot> carregarRecolhimentosPaginados(DocumentSnapshot ultimoRecolhimento, DateTime filtroDataInicial, DateTime filtroDataFinal) {

    //#region Filtro com data inicial e final
    if(filtroDataInicial != null && filtroDataFinal != null){
      
      if(ultimoRecolhimento == null){
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_DATA_RECOLHIMENTO)
            .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
            .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
      else{
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_DATA_RECOLHIMENTO)
            .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
            .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
            .startAfterDocument(ultimoRecolhimento)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
    }
    //#endregion Filtro com data inicial e final

    //#region Filtro com data inicial
    if(filtroDataInicial != null){
      if(ultimoRecolhimento == null){
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_DATA_RECOLHIMENTO)
            .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
      else{
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_DATA_RECOLHIMENTO)
            .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
            .startAfterDocument(ultimoRecolhimento)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
    }
    //#endregion Filtro com data inicial

    // #region Filtro com data final
    if(filtroDataFinal != null){
      if(ultimoRecolhimento == null){
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_DATA_RECOLHIMENTO)
            .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
      else{
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_DATA_RECOLHIMENTO)
            .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
            .startAfterDocument(ultimoRecolhimento)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
    }
    //#endregion Filtro com data final

    if(ultimoRecolhimento == null)
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .orderBy(CAMPO_DATA_RECOLHIMENTO)
          .get();

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .orderBy(ultimoRecolhimento)
        .startAfterDocument(ultimoRecolhimento)
        .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        .get();
  }

  /// Converte um snapshot em um objeto RecolhimentoDmo.
  RecolhimentoDmo converterSnapshotEmRecolhimento(DocumentSnapshot recolhimento){

    return RecolhimentoDmo(
        id: recolhimento.id,
        dataDoRecolhimento: new DateTime.fromMillisecondsSinceEpoch((recolhimento[CAMPO_DATA_RECOLHIMENTO] as Timestamp).millisecondsSinceEpoch).toLocal(),// Obter data e converter para o fuso horário local
        dataFinalizado: new DateTime.fromMillisecondsSinceEpoch((recolhimento[CAMPO_DATA_FINALIZADO] as Timestamp).millisecondsSinceEpoch).toLocal(),// Obter data e converter para o fuso horário local
        gruposDoRecolhimento: (recolhimento[CAMPO_GRUPOS_DO_RECOLHIMENTO] as List)
            .map((e) => GrupoDeRedeirosDmo(
            idGrupo: e)).toList()
    );
  }

  /// Carrega os recolhimentos por grupos.
  Future<QuerySnapshot> carregarRecolhimentosPorGrupos(List<String> idsDosGrupos){

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .where(CAMPO_GRUPOS_DO_RECOLHIMENTO, arrayContainsAny: idsDosGrupos)
        .get();
  }
//#endregion Métodos

}