import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jsvillela_app/infra/preferencias.dart';

/// Model para matérias-primas.
class MateriaPrimaModel extends Model{

  //#region Atributos
  //#endregion Atributos

  //#region Constantes
  /// Nome do identificador para a coleção "materias_primas" utilizado no Firebase.
  static const String NOME_COLECAO = "materias_primas";

  /// Nome do identificador para o campo "nome_materia_prima" utilizado na collection.
  static const String CAMPO_NM_MAT_PRIMA = "nome_materia_prima";

  /// Nome do identificador para o campo "icone_materia_prima" utilizado na collection do Firebase.
  static const String CAMPO_ICONE_MAT_PRIMA = "icone_materia_prima";
  //#endregion Constantes

  //#region Métodos
  ///Cadastra um redeiro no Firebase.
  void cadastrarMateriaPrima({@required Map<String, dynamic> dadosDaMateriaPrima, @required VoidCallback onSuccess, @required VoidCallback onFail}){
    FirebaseFirestore.instance.collection(NOME_COLECAO).add({
      CAMPO_NM_MAT_PRIMA : dadosDaMateriaPrima[CAMPO_NM_MAT_PRIMA],
      CAMPO_ICONE_MAT_PRIMA : dadosDaMateriaPrima[CAMPO_ICONE_MAT_PRIMA]
    }).then((value) => onSuccess()).catchError((e){
      onFail();
    });
  }

  /// Carrega as mp de forma paginada
  Future<QuerySnapshot> carregarMpPaginadas(DocumentSnapshot ultimaMp, String filtroPorNome) {

    if(ultimaMp == null)
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .orderBy(CAMPO_NM_MAT_PRIMA).get();

    if(filtroPorNome != null && filtroPorNome.isNotEmpty){
      if(ultimaMp == null)
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_NM_MAT_PRIMA)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .where(CAMPO_NM_MAT_PRIMA, isEqualTo: filtroPorNome)
            .get();
      else
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_NM_MAT_PRIMA)
            .startAfterDocument(ultimaMp)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .where(CAMPO_NM_MAT_PRIMA, isEqualTo: filtroPorNome)
            .get();
    }

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .orderBy(CAMPO_NM_MAT_PRIMA)
        .startAfterDocument(ultimaMp)
        .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        .get();
  }

  /// Carrega o redeiro por ID diretamente do Firebase.
  Future<DocumentSnapshot> carregarMateriaPrimaPorId(String idDaMateriaPrima) async {

    return await FirebaseFirestore.instance.collection(NOME_COLECAO)
        .doc(idDaMateriaPrima)
        .get();
  }
//#endregion Métodos

}