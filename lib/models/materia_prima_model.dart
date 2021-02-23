import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model para materias primas.
class MateriaPrimaModel extends Model{

  //#region Atributos
  //#endregion Atributos

  //#region Constantes
  /// Nome do identificador para a coleção "materia_prima" utilizado no Firebase.
  static const String NOME_COLECAO = "materia_prima";

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
//#endregion Métodos

}