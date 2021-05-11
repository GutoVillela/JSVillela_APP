import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/models/materia_prima_model.dart';
import 'package:jsvillela_app/parse_server/materia_prima_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

/// Classe modelo para matéria-prima.
class MateriaPrimaDmo implements BaseDmo{

  //#region Atributos

  /// Id da matéria-prima.
  String? id;

  /// Nome da matéria-prima.
  String? nomeMateriaPrima;

  /// Ícone da matéria-prima.
  String? iconeMateriaPrima;

  //#endregion Atributos

  //#region Construtor(es)
  MateriaPrimaDmo({this.id, this.nomeMateriaPrima, this.iconeMateriaPrima});
  //#endregion Construtor(es)

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  MateriaPrimaDmo.fromParse(ParseObject parseObject) :
        id = parseObject.objectId ?? "",
        nomeMateriaPrima = parseObject.get(MateriaPrimaParse.CAMPO_NOME_MATERIA_PRIMA) ?? "Falha ao obter o nome da matéria prima",
        iconeMateriaPrima = parseObject.get(MateriaPrimaParse.CAMPO_ICONE_MATERIA_PRIMA);

  /// Converte um snapshot em um objeto MateriaPrimaDmo.
  static MateriaPrimaDmo converterSnapshotEmDmo(DocumentSnapshot materiaPrima){

    return MateriaPrimaDmo(
        id: materiaPrima.id,
        nomeMateriaPrima: materiaPrima[MateriaPrimaModel.CAMPO_NM_MAT_PRIMA],
        iconeMateriaPrima: materiaPrima[MateriaPrimaModel.CAMPO_ICONE_MAT_PRIMA]
    );
  }

  @override
  String toString() {
    return 'MateriaPrimaDmo(id : ${id ?? "null"}, nomeMateriaPrima : ${nomeMateriaPrima ?? "null"}, iconeMateriaPrima : ${iconeMateriaPrima ?? "null"})';
  }
  //#endregion Métodos

  //#region Métodos
  @override
  Map<String, dynamic> converterParaMapa() {
    return {
      MateriaPrimaModel.CAMPO_NM_MAT_PRIMA : nomeMateriaPrima,
      MateriaPrimaModel.CAMPO_ICONE_MAT_PRIMA : iconeMateriaPrima
    };
  }

}