import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';

/// Classe modelo para grupo de redeiros.
class GrupoDeRedeirosDmo implements BaseDmo {

  //#region Atributos

  /// Id do grupo.
  String idGrupo;

  /// Nome do grupo.
  String nomeGrupo;

  //#endregion Atributos

  //#region Construtor(es)
  GrupoDeRedeirosDmo({required this.idGrupo, required this.nomeGrupo});
  //#endregion Construtor(es)

  //#region Métodos
  /// Converte um snapshot em um objeto GrupoDeRedeirosDmo.
  static GrupoDeRedeirosDmo converterSnapshotEmGrupoDeRedeiro(DocumentSnapshot grupo){

    return GrupoDeRedeirosDmo(
        idGrupo: grupo.id,
        nomeGrupo: grupo[GrupoDeRedeirosModel.CAMPO_NOME] ?? ""
    );
  }

  @override
  Map<String, dynamic> converterParaMapa() {
    return {
      GrupoDeRedeirosModel.CAMPO_NOME : nomeGrupo
    };
  }
  //#endregion Métodos

}