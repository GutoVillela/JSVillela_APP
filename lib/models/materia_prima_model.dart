import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/dml/materia_prima_dmo.dart';

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

    if(filtroPorNome != null && filtroPorNome.isNotEmpty){
      print("******************1");
      if(ultimaMp == null) {
        print("******************2");
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_NM_MAT_PRIMA)
            .startAt([filtroPorNome])
            .endAt([filtroPorNome + "\uf8ff"])
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
      else {
        print("******************3");
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_NM_MAT_PRIMA)
            .startAt([filtroPorNome])
            .endAt([filtroPorNome + "\uf8ff"])
            .startAfterDocument(ultimaMp)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
    }

    if(ultimaMp == null) {
      print("******************4");
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .orderBy(CAMPO_NM_MAT_PRIMA).get();
    }

    print("******************5");
    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .orderBy(CAMPO_NM_MAT_PRIMA)
        .startAfterDocument(ultimaMp)
        .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        .get();
  }

  MatPrimaDmo converterSnapshotEmMateriaPrima(DocumentSnapshot materiaPrima){

    return MatPrimaDmo(
        id: materiaPrima.id,
        nome_materia_prima: materiaPrima[CAMPO_NM_MAT_PRIMA],
        icone: materiaPrima[CAMPO_ICONE_MAT_PRIMA]
    );
  }
//#endregion Métodos

}