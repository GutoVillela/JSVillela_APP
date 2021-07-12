import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/dml/materia_prima_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/parse_server/solicitacao_de_materia_prima_parse.dart';

/// Classe modelo para solicitação do redeiro.
class SolicitacaoDeMateriaPrimaDmo implements BaseDmo{

  //#region Atributos

  /// Id da solicitação do redeiro.
  String id;

  /// Redeiro solicitante.
  RedeiroDmo redeiroSolicitante;

  /// Data da solicitação.
  DateTime dataDaSolicitacao;

  /// Data da finalização da solicitação do redeiro.
  DateTime? dataFinalizacao;

  /// Matérias-primas solicitadas.
  List<MateriaPrimaDmo> materiasPrimasSolicitadas = [];

  //#endregion Atributos

  //#region Construtor(es)
  SolicitacaoDeMateriaPrimaDmo({required this.id, required this.redeiroSolicitante, required this.dataDaSolicitacao, this.dataFinalizacao, required this.materiasPrimasSolicitadas});

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  SolicitacaoDeMateriaPrimaDmo.fromMap(Map<String, dynamic> mapa) :
        id =  mapa['solicitacao'][SolicitacaoDeMateriaPrimaParse.CAMPO_ID_SOLICITACOES],
        redeiroSolicitante = RedeiroDmo.fromMap(mapa['solicitacao'][SolicitacaoDeMateriaPrimaParse.RELACAO_REDEIRO]),
        dataDaSolicitacao = DateTime.parse(mapa['solicitacao'][SolicitacaoDeMateriaPrimaParse.CAMPO_DTHR_SOLICITACAO]),
        dataFinalizacao = DateTime.tryParse(mapa['solicitacao'][SolicitacaoDeMateriaPrimaParse.CAMPO_DTHR_ATENDIDO] ?? ""),
        materiasPrimasSolicitadas = (mapa[SolicitacaoDeMateriaPrimaParse.RELACAO_MATERIAS_PRIMAS] as List).map((e) => MateriaPrimaDmo.fromMap(e)).toList();
//#endregion Construtor(es)
}