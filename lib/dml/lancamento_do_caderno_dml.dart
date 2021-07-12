import 'package:jsvillela_app/dml/rede_dmo.dart';
import 'package:jsvillela_app/parse_server/lancamento_do_caderno_parse.dart';
import 'package:jsvillela_app/parse_server/rede_parse.dart';

/// Classe modelo para lançamentos do caderno.
class LancamentoDoCadernoDmo{

  //#region Atributos

  /// Id do Lançamento.
  String idLancamento;

  /// Data de confirmação do pagamento do lançamento.
  DateTime? dataConfirmacaoPagamento;

  /// Data do lançamento.
  DateTime dataLancamento;

   /// Data em que foi efetuado o pagamento do lançamento.
  DateTime? dataPagamento;

  /// Rede associada ao lançamento.
  RedeDmo rede;

  /// Quantidade de redes associada ao lançamento.
  int quantidade;

  /// Valor unitário da rede associada ao lançamento.
  double valorUnitario;

  //#endregion Atributos

  //#region Construtor(es)
  LancamentoDoCadernoDmo({required this.idLancamento, this.dataConfirmacaoPagamento, required this.dataLancamento, this.dataPagamento, required this.rede,required this.quantidade, required this.valorUnitario});

  /// Cosntrutor que define os campos do Lançamento com base em um mapa retornado pela Cloud Function do Parse Server.
  LancamentoDoCadernoDmo.fromMap(Map<String, dynamic> mapa) :
    idLancamento = mapa[LancamentoDoCadernoParse.CAMPO_ID_LANCAMENTO],
    dataLancamento = DateTime.parse(mapa[LancamentoDoCadernoParse.CAMPO_DATA_LANCAMENTO]),
    dataPagamento = DateTime.tryParse(mapa[LancamentoDoCadernoParse.CAMPO_DATA_PAGAMENTO]?['iso'] ?? ""),
    dataConfirmacaoPagamento = DateTime.tryParse(mapa[LancamentoDoCadernoParse.CAMPO_DATA_CONFIRMACAO_PAGAMENTO]?['iso'] ?? ""),
    quantidade = int.parse(mapa[LancamentoDoCadernoParse.CAMPO_QUANTIDADE].toString()),
    valorUnitario = double.parse(mapa[LancamentoDoCadernoParse.CAMPO_VALOR_UNITARIO].toString()),
    rede = RedeDmo(
      id: mapa[LancamentoDoCadernoParse.CAMPO_REDE][RedeParse.CAMPO_ID_REDE],
      nomeRede: mapa[LancamentoDoCadernoParse.CAMPO_REDE][RedeParse.CAMPO_NOME_REDE],
      valorUnitarioRede: double.parse(mapa[LancamentoDoCadernoParse.CAMPO_REDE][RedeParse.CAMPO_VLR_UNITARIO].toString())
    );
  //#endregion Construtor(es)

  //#region Métodos

  //#endregion Métodos

}