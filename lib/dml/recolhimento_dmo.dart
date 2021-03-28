import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';

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
  @override
  String toString() {
    return 'id: $id, '
        'dataDoRecolhimento: $dataDoRecolhimento, '
        'dataFinalizado: $dataFinalizado, '
        'gruposDoRecolhimento: [${gruposDoRecolhimento.map((e) => "{ id: " + e.idGrupo + ", nomeGrupo: " + e.nomeGrupo + "} ")}].';
  }
//#endregion Métodos
}