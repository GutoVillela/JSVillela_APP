import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/parse_server/redeiros_do_recolhimento_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

// TODO: Finalizar implementação da Classe RedeiroDoRecolhimentoDmo
/// Classe modelo para redeiros do recolhimento.
class RedeiroDoRecolhimentoDmo implements BaseDmo{

  //#region Atributos

  /// Id do redeiro do recolhimento.
  String? id;

  /// Redeiro associado ao recolhimento.
  RedeiroDmo? redeiro;

  /// Data e hora de finalização desde recolhimento.
  DateTime? dataFinalizacao;

  //#endregion Atributos

  //#region Construtor(es)
  RedeiroDoRecolhimentoDmo({this.id, this.redeiro, this.dataFinalizacao});

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  RedeiroDoRecolhimentoDmo.fromParse(ParseObject parseObject) :
    id = parseObject.objectId ?? "",
    dataFinalizacao = parseObject.get(RedeirosDoRecolhimentoParse.CAMPO_DATA_FINALIZADO);

  //#endregion Construtor(es)

  //#region Métodos
  @override
  String toString() {
    return 'id: $id, '
        'redeiro: {${redeiro.toString()}, '
        'dataFinalizacao: ${dataFinalizacao}';
  }
//#endregion Métodos
}