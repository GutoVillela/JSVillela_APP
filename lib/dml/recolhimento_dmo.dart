import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';

/// Classe modelo para recolhimentos.
class RecolhimentoDmo{

  //#region Atributos

  /// Id do Recolhimento.
  String id;

  /// Data do recolhimento.
  DateTime dataDoRecolhimento;

  /// Data em que o recolhimento foi finalizado.
  DateTime dataFinalizado;

  /// Lista de grupos associados ao recolhimento.
  List<GrupoDeRedeirosDmo> gruposDoRecolhimento;

  /// Lista de redeiros associados ao recolhimento.
  List<RedeiroDoRecolhimentoDmo> redeirosDoRecolhimento;

  //#endregion Atributos

  //#region Construtor(es)
  RecolhimentoDmo({this.id, this.dataDoRecolhimento, this.dataFinalizado, this.gruposDoRecolhimento, this.redeirosDoRecolhimento});
  //#endregion Construtor(es)

  //#region Métodos

  /// Converte um snapshot em um objeto RecolhimentoDmo.
  static RecolhimentoDmo converterSnapshotEmRecolhimento(DocumentSnapshot recolhimento){

    return RecolhimentoDmo(
        id: recolhimento.id,
        dataDoRecolhimento: recolhimento[RecolhimentoModel.CAMPO_DATA_RECOLHIMENTO] != null ? new DateTime.fromMillisecondsSinceEpoch((recolhimento[RecolhimentoModel.CAMPO_DATA_RECOLHIMENTO] as Timestamp).millisecondsSinceEpoch).toLocal() : null,// Obter data e converter para o fuso horário local
        dataFinalizado:  recolhimento[RecolhimentoModel.CAMPO_DATA_FINALIZADO] != null ? new DateTime.fromMillisecondsSinceEpoch((recolhimento[RecolhimentoModel.CAMPO_DATA_FINALIZADO] as Timestamp).millisecondsSinceEpoch).toLocal() : null,// Obter data e converter para o fuso horário local
        gruposDoRecolhimento: (recolhimento[RecolhimentoModel.CAMPO_GRUPOS_DO_RECOLHIMENTO] as List)
            .map((e) => GrupoDeRedeirosDmo(
            idGrupo: e)).toList()
    );
  }

  @override
  String toString() {
    return 'id: $id, '
        'dataDoRecolhimento: $dataDoRecolhimento, '
        'dataFinalizado: $dataFinalizado, '
        'gruposDoRecolhimento: ${ gruposDoRecolhimento == null ? "null" : ( gruposDoRecolhimento.map((e) => "{ id: " + (e.idGrupo ?? "null") + ", nomeGrupo: " + (e.nomeGrupo ?? "null") + "} ").toString() ) }.'
    ;
  }

  //#endregion Métodos
}