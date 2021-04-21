import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/dml/materia_prima_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/models/solicitacao_do_redeiro_model.dart';

/// Classe modelo para solicitação do redeiro.
class SolicitacaoDoRedeiroDmo implements BaseDmo{

  //#region Atributos

  /// Id da solicitação do redeiro.
  String? id;

  /// Redeiro solicitante.
  RedeiroDmo? redeiroSolicitante;

  /// Data da solicitação.
  DateTime? dataDaSolicitacao;

  /// Data da finalização da solicitação do redeiro.
  DateTime? dataFinalizacao;

  /// Matérias-primas solicitadas.
  List<MateriaPrimaDmo>? materiasPrimasSolicitadas = [];

  //#endregion Atributos

  //#region Construtor(es)
  SolicitacaoDoRedeiroDmo({this.id, this.redeiroSolicitante, this.dataDaSolicitacao, this.dataFinalizacao, this.materiasPrimasSolicitadas});
  //#endregion Construtor(es)

  //#region Métodos
  @override
  Map<String, dynamic> converterParaMapa() {
    return {
      SolicitacaoDoRedeiroModel.CAMPO_REDEIRO_SOLICITANTE : redeiroSolicitante == null ? null : redeiroSolicitante!.id,
      SolicitacaoDoRedeiroModel.CAMPO_DATA_SOLICITACAO : dataDaSolicitacao,
      SolicitacaoDoRedeiroModel.CAMPO_DATA_FINALIZACAO : dataFinalizacao,
      SolicitacaoDoRedeiroModel.CAMPO_MATERIAIS_SOLICITADOS : materiasPrimasSolicitadas == null ? null : materiasPrimasSolicitadas!.map((e) => e.id).toList()
    };
  }

  /// Converte um snapshot em um objeto SolicitacaoDoRedeiroDmo.
  static SolicitacaoDoRedeiroDmo converterSnapshotEmDmo(DocumentSnapshot snapshot){

    return SolicitacaoDoRedeiroDmo(
        id: snapshot.id,
        redeiroSolicitante: RedeiroDmo(id: snapshot[SolicitacaoDoRedeiroModel.CAMPO_REDEIRO_SOLICITANTE]),
        dataDaSolicitacao: snapshot[SolicitacaoDoRedeiroModel.CAMPO_DATA_SOLICITACAO] != null ?
          new DateTime.fromMillisecondsSinceEpoch((snapshot[SolicitacaoDoRedeiroModel.CAMPO_DATA_SOLICITACAO] as Timestamp).millisecondsSinceEpoch).toLocal() :
          null,// Obter data e converter para o fuso horário local
        dataFinalizacao: snapshot[SolicitacaoDoRedeiroModel.CAMPO_DATA_FINALIZACAO] != null ?
        new DateTime.fromMillisecondsSinceEpoch((snapshot[SolicitacaoDoRedeiroModel.CAMPO_DATA_FINALIZACAO] as Timestamp).millisecondsSinceEpoch).toLocal() :
        null,// Obter data e converter para o fuso horário local
        materiasPrimasSolicitadas: (snapshot[SolicitacaoDoRedeiroModel.CAMPO_MATERIAIS_SOLICITADOS] as List)
          .map((e) => MateriaPrimaDmo(id: e)).toList()
    );
  }
  //#endregion Métodos
}