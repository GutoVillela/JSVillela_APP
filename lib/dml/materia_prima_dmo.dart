import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/models/materia_prima_model.dart';

/// Classe modelo para matéria-prima.
class MateriaPrimaDmo implements BaseDmo{

  //#region Atributos

  /// Id da matéria-prima.
  String id;

  /// Nome da matéria-prima.
  String nomeMateriaPrima;

  /// Ícone da matéria-prima.
  String iconeMateriaPrima;

  //#endregion Atributos

  //#region Construtor(es)
  MateriaPrimaDmo({this.id, this.nomeMateriaPrima, this.iconeMateriaPrima});
  //#endregion Construtor(es)

  //#region Métodos
  @override
  Map<String, dynamic> converterParaMapa() {
    return {
      MateriaPrimaModel.CAMPO_NM_MAT_PRIMA : nomeMateriaPrima,
      MateriaPrimaModel.CAMPO_ICONE_MAT_PRIMA : iconeMateriaPrima
    };
  }

  @override
  String toString() {
    return 'MateriaPrimaDmo(id : ${id ?? "null"}, nomeMateriaPrima : ${nomeMateriaPrima ?? "null"}, iconeMateriaPrima : ${iconeMateriaPrima ?? "null"})';
  }

  /// Converte um snapshot em um objeto MateriaPrimaDmo.
  static MateriaPrimaDmo converterSnapshotEmDmo(DocumentSnapshot materiaPrima){

    return MateriaPrimaDmo(
        id: materiaPrima.id,
        nomeMateriaPrima: materiaPrima[MateriaPrimaModel.CAMPO_NM_MAT_PRIMA],
        iconeMateriaPrima: materiaPrima[MateriaPrimaModel.CAMPO_ICONE_MAT_PRIMA]
    );
  }
  //#endregion Métodos
}