import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';

/// Classe modelo para lançamentos do caderno.
class LancamentoDoCadernoDmo implements BaseDmo{

  //#region Atributos

  /// Id do Lançamento.
  String idLancamento;

  /// Data de confirmação do pagamento do lançamento.
  Timestamp dataConfirmacaoPagamento;

  /// Data do lançamento.
  Timestamp dataLancamento;

   /// Data em que foi efetuado o pagamento do lançamento.
  Timestamp dataPagamento;

  /// ID da rede associada ao lançamento.
  String idRede;

  /// Nome da rede associada ao lançamento.
  String nomeRede;

  /// Indica se registro consta como pago ou não.
  bool pago;

  /// Quantidade de redes associada ao lançamento.
  int quantidade;

  /// Valor unitário da rede associada ao lançamento.
  double valorUnitario;

  //#endregion Atributos

  //#region Construtor(es)
  LancamentoDoCadernoDmo({this.idLancamento, this.dataConfirmacaoPagamento, this.dataLancamento, this.dataPagamento, this.idRede, this.nomeRede, this.pago, this.quantidade, this.valorUnitario});
  //#endregion Construtor(es)

  //#region Métodos
  @override
  Map<String, dynamic> converterParaMapa() {
    // TODO: implement converterParaMapa
    throw UnimplementedError();
  }
  //#endregion Métodos

}