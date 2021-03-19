import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';

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

  //#endregion Atributos

  //#region Construtor(es)
  RecolhimentoDmo({this.id, this.dataDoRecolhimento, this.dataFinalizado, this.gruposDoRecolhimento});
  //#endregion Construtor(es)

  //#region Métodos
  @override
  String toString() {
    return 'id: $id, '
        'dataDoRecolhimento: $dataDoRecolhimento, '
        'dataFinalizado: $dataFinalizado, '
        'gruposDoRecolhimento: [${gruposDoRecolhimento.map((e) => "{ id: " + e.idGrupo + ", nomeGrupo: " + e.nomeGrupo + "} ")}].';
  }
//#endregion Métodos
}