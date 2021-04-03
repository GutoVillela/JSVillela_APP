import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/models/redeiro_do_recolhimento_model.dart';

// TODO: Finalizar implementação da Classe RedeiroDoRecolhimentoDmo
/// Classe modelo para redeiros do recolhimento.
class RedeiroDoRecolhimentoDmo implements BaseDmo{

  //#region Atributos

  /// Id do redeiro do recolhimento.
  String id;

  /// Redeiro associado ao recolhimento.
  RedeiroDmo redeiro;

  /// Data e hora de finalização desde recolhimento.
  DateTime dataFinalizacao;

  //#endregion Atributos

  //#region Construtor(es)
  RedeiroDoRecolhimentoDmo({this.id, this.redeiro, this.dataFinalizacao});

  @override
  Map<String, dynamic> converterParaMapa() {
    return {
      RedeiroDoRecolhimentoModel.CAMPO_DATA_FINALIZACAO : dataFinalizacao,
      RedeiroDoRecolhimentoModel.CAMPO_REDEIRO : redeiro.id
    };
  }
  //#endregion Construtor(es)

  //#region Métodos
  /// Converte um snapshot em um objeto RedeiroDoRecolhimentoDmo.
  static RedeiroDoRecolhimentoDmo converterSnapshotEmRedeiroDoRecolhimento(DocumentSnapshot redeiroDoRecolhimento){
    return RedeiroDoRecolhimentoDmo(
        id: redeiroDoRecolhimento.id,
        dataFinalizacao:  redeiroDoRecolhimento[RedeiroDoRecolhimentoModel.CAMPO_DATA_FINALIZACAO] != null ?
          new DateTime.fromMillisecondsSinceEpoch((redeiroDoRecolhimento[RedeiroDoRecolhimentoModel.CAMPO_DATA_FINALIZACAO] as Timestamp).millisecondsSinceEpoch).toLocal() :
          null,// Obter data e converter para o fuso horário local
        redeiro: RedeiroDmo(id: redeiroDoRecolhimento[RedeiroDoRecolhimentoModel.CAMPO_REDEIRO])
    );
  }

  // @override
  // String toString() {
  //   return 'id: $id, '
  //       'nome: $nome, '
  //       'celular: $celular, '
  //       'email: $email, '
  //       'endereco: ${endereco.toString()}, '
  //       'gruposDoRedeiro: [${gruposDoRedeiro.map((e) => "{ id: " + e.idGrupo + ", nomeGrupo: " + e.nomeGrupo + "} ")}].';
  // }
//#endregion Métodos
}