import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/dml/endereco_dmo.dart';
import 'package:jsvillela_app/dml/materia_prima_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/models/solicitacao_do_redeiro_model.dart';
import 'package:jsvillela_app/parse_server/solicitacoes_dos_redeiros_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

/// Classe modelo para solicitação do redeiro.
class SolicitacaoDoRedeiroDmo implements BaseDmo{

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
  SolicitacaoDoRedeiroDmo({required this.id, required this.redeiroSolicitante, required this.dataDaSolicitacao, this.dataFinalizacao, required this.materiasPrimasSolicitadas});

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  SolicitacaoDoRedeiroDmo.fromParse(ParseObject parseObject) :
        id =  parseObject.objectId ?? "",
        redeiroSolicitante = RedeiroDmo.fromParse(parseObject.get<ParseObject>(SolicitacoesDosRedeirosParse.RELACAO_REDEIRO_SOLICITANTE)!),
        dataDaSolicitacao = parseObject.get(SolicitacoesDosRedeirosParse.CAMPO_DATA_SOLICITACAO),
        dataFinalizacao = parseObject.get(SolicitacoesDosRedeirosParse.CAMPO_DATA_FINALIZACAO),
        materiasPrimasSolicitadas = [];
  //#endregion Construtor(es)

  //#region Métodos
  @override
  Map<String, dynamic> converterParaMapa() {
    return {
      SolicitacaoDoRedeiroModel.CAMPO_REDEIRO_SOLICITANTE : redeiroSolicitante.id,
      SolicitacaoDoRedeiroModel.CAMPO_DATA_SOLICITACAO : dataDaSolicitacao,
      SolicitacaoDoRedeiroModel.CAMPO_DATA_FINALIZACAO : dataFinalizacao,
      SolicitacaoDoRedeiroModel.CAMPO_MATERIAIS_SOLICITADOS : materiasPrimasSolicitadas.map((e) => e.id).toList()
    };
  }

  /// Converte um snapshot em um objeto SolicitacaoDoRedeiroDmo.
  static SolicitacaoDoRedeiroDmo converterSnapshotEmDmo(DocumentSnapshot snapshot){

    return SolicitacaoDoRedeiroDmo(
        id: snapshot.id,
        redeiroSolicitante: RedeiroDmo(id: snapshot[SolicitacaoDoRedeiroModel.CAMPO_REDEIRO_SOLICITANTE], nome: "", endereco: EnderecoDmo(), gruposDoRedeiro: []),
        dataDaSolicitacao: new DateTime.fromMillisecondsSinceEpoch((snapshot[SolicitacaoDoRedeiroModel.CAMPO_DATA_SOLICITACAO] as Timestamp).millisecondsSinceEpoch).toLocal(),// Obter data e converter para o fuso horário local
        dataFinalizacao: new DateTime.fromMillisecondsSinceEpoch((snapshot[SolicitacaoDoRedeiroModel.CAMPO_DATA_FINALIZACAO] as Timestamp).millisecondsSinceEpoch).toLocal(),// Obter data e converter para o fuso horário local
        materiasPrimasSolicitadas: (snapshot[SolicitacaoDoRedeiroModel.CAMPO_MATERIAIS_SOLICITADOS] as List)
          .map((e) => MateriaPrimaDmo(id: e)).toList()
    );
  }
  //#endregion Métodos
}