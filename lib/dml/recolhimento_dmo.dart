import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/parse_server/grupo_de_redeiros_parse.dart';
import 'package:jsvillela_app/parse_server/recolhimento_parse.dart';
import 'package:jsvillela_app/parse_server/redeiros_do_recolhimento_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

/// Classe modelo para recolhimentos.
class RecolhimentoDmo implements BaseDmo{

  //#region Construtor(es)
  RecolhimentoDmo({required this.dataDoRecolhimento, required this.gruposDoRecolhimento, this.id, this.dataIniciado, this.dataFinalizado});

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  RecolhimentoDmo.fromParse(ParseObject parseObject) :
        id =  parseObject.objectId ?? "",
        dataDoRecolhimento = parseObject.get(RecolhimentoParse.CAMPO_DATA_RECOLHIMENTO),
        dataIniciado = parseObject.get(RecolhimentoParse.CAMPO_DATA_INICIADO),
        dataFinalizado = parseObject.get(RecolhimentoParse.CAMPO_DATA_FINALIZADO);

  /// Construtor que inicializa objetos de acordo com um MAPA
  RecolhimentoDmo.fromMap(Map<String, dynamic> mapa) :
        id =  mapa['recolhimento'][RecolhimentoParse.CAMPO_ID_RECOLHIMENTO],
        dataDoRecolhimento = DateTime.parse(mapa['recolhimento'][RecolhimentoParse.CAMPO_DATA_RECOLHIMENTO]['iso']),
        dataIniciado = DateTime.tryParse(mapa['recolhimento'][RecolhimentoParse.CAMPO_DATA_INICIADO]?['iso'] ?? ""),
        dataFinalizado = DateTime.tryParse(mapa['recolhimento'][RecolhimentoParse.CAMPO_DATA_FINALIZADO]?['iso'] ?? ""),
        gruposDoRecolhimento = (mapa[RecolhimentoParse.RELACIONAMENTO_GRUPOS_DO_RECOLHIMENTO] as List).map((e) =>
            GrupoDeRedeirosDmo(
                idGrupo: e[GrupoDeRedeirosParse.CAMPO_ID_GRUPOS_DE_REDEIROS],
                nomeGrupo: e[GrupoDeRedeirosParse.CAMPO_NOME_GRUPO]
            )
        ).toList(),
        redeirosDoRecolhimento = (mapa['redeirosDoRecolhimento'] as List).map((e) =>
            RedeiroDoRecolhimentoDmo(
                id: e[RedeirosDoRecolhimentoParse.CAMPO_ID_RELACAO_REDEIRO_GRUPO],
                redeiro: RedeiroDmo.fromMap(e['redeiro']),
                dataFinalizacao: DateTime.tryParse(e[RedeirosDoRecolhimentoParse.CAMPO_DATA_FINALIZADO]?['iso'] ?? "")
            ),
        ).toList();

  //#endregion Construtor(es)

  //#region Atributos

  /// Id do Recolhimento.
  String? id;

  /// Data do recolhimento.
  DateTime dataDoRecolhimento;

  /// Data em que o recolhimento foi iniciado.
  DateTime? dataIniciado;

/// Data em que o recolhimento foi finalizado.
  DateTime? dataFinalizado;

  /// Lista de grupos associados ao recolhimento.
  List<GrupoDeRedeirosDmo> gruposDoRecolhimento = [];

  /// Lista de redeiros associados ao recolhimento.
  List<RedeiroDoRecolhimentoDmo> redeirosDoRecolhimento = [];

  //#endregion Atributos

  //#region Métodos

  @override
  String toString() {
    return 'id: $id, '
        'dataDoRecolhimento: $dataDoRecolhimento, '
        'dataFinalizado: $dataFinalizado, '
        'dataIniciado: $dataIniciado, '
        'gruposDoRecolhimento: ${ gruposDoRecolhimento.map((e) => "{ id: " + (e.idGrupo) + ", nomeGrupo: " + (e.nomeGrupo) + "} ").toString() }.'
    ;
  }

  //#endregion Métodos
}