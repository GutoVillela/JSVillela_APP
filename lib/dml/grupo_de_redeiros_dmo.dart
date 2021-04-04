import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';

/// Classe modelo para grupo de redeiros.
class GrupoDeRedeirosDmo {

  //#region Atributos

  /// Id do grupo.
  String idGrupo;

  /// Nome do grupo.
  String nomeGrupo;

  //#endregion Atributos

  //#region Construtor(es)
  GrupoDeRedeirosDmo({this.idGrupo, this.nomeGrupo});
  //#endregion Construtor(es)

  //#region Métodos
  /// Converte um snapshot em um objeto GrupoDeRedeirosDmo.
  static GrupoDeRedeirosDmo converterSnapshotEmGrupoDeRedeiro(DocumentSnapshot grupo){

    return GrupoDeRedeirosDmo(
        idGrupo: grupo.id,
        nomeGrupo: grupo[GrupoDeRedeirosModel.CAMPO_NOME]
    );
  }
  //#endregion Métodos

}