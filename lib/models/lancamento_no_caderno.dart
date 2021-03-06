import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model para grupo de redeiros.
class LancamentoNoCadernoModel extends Model{

  //#region Atributos
  //#endregion Atributos

  //#region Constantes
  /// Nome do identificador para a subcoleção "caderno" utilizado no Firebase.
  static const String NOME_COLECAO = RedeiroModel.SUBCOLECAO_CADERNO;

  /// Nome do identificador para o campo "id_rede" utilizado na collection.
  static const String CAMPO_ID_REDE = "id_rede";

  /// Nome do identificador para o campo "nome_rede" utilizado na collection.
  static const String CAMPO_NOME_REDE = "nome_rede";

  /// Nome do identificador para o campo "quantidade" utilizado na collection.
  static const String CAMPO_QUANTIDADE = "quantidade";

  /// Nome do identificador para o campo "valor_unitario" utilizado na collection.
  static const String CAMPO_VALOR_UNITARIO = "valor_unitario";

  /// Nome do identificador para o campo "data_lancamento" utilizado na collection.
  static const String CAMPO_DATA_LANCAMENTO = "data_lancamento";

  /// Nome do identificador para o campo "pago" utilizado na collection.
  static const String CAMPO_PAGO = "pago";

  /// Nome do identificador para o campo "data_pagamento" utilizado na collection.
  static const String CAMPO_DATA_PAGAMENTO = "data_pagamento";

  /// Nome do identificador para o campo "data_confirmacao_pagamento" utilizado na collection.
  static const String CAMPO_DATA_CONFIRMACAO_PAGAMENTO = "data_confirmacao_pagamento";
  //#endregion Constantes

  //#region Métodos
  ///Cadastra um novo lançamento no caderno do Redeiro no Firebase.
  void cadastrarNovoLancamento({@required Map<String, dynamic> dadosDoLancamento, @required String idDoRedeiro, @required VoidCallback onSuccess, @required VoidCallback onFail}){
    FirebaseFirestore.instance.collection(RedeiroModel.NOME_COLECAO).doc(idDoRedeiro).collection(NOME_COLECAO).add({
      CAMPO_ID_REDE : dadosDoLancamento[CAMPO_ID_REDE],
      CAMPO_NOME_REDE : dadosDoLancamento[CAMPO_NOME_REDE],
      CAMPO_QUANTIDADE : dadosDoLancamento[CAMPO_QUANTIDADE],
      CAMPO_VALOR_UNITARIO : dadosDoLancamento[CAMPO_VALOR_UNITARIO],
      CAMPO_DATA_LANCAMENTO : dadosDoLancamento[CAMPO_DATA_LANCAMENTO],
      CAMPO_PAGO : dadosDoLancamento[CAMPO_PAGO],
      CAMPO_DATA_PAGAMENTO : dadosDoLancamento[CAMPO_DATA_PAGAMENTO],
      CAMPO_DATA_CONFIRMACAO_PAGAMENTO: dadosDoLancamento[CAMPO_DATA_CONFIRMACAO_PAGAMENTO]
    }).then((value) => onSuccess()).catchError((e){
      onFail();
    });
  }

  /// Informa o pagamento do Lançamento informado para o redeiro informado.
  void informarPagamento({@required String idDoLancamento, @required String idDoRedeiro, @required Timestamp dataDoPagamento, @required VoidCallback onSuccess, @required VoidCallback onFail}) async{
    FirebaseFirestore.instance.collection(RedeiroModel.NOME_COLECAO).doc(idDoRedeiro).collection(NOME_COLECAO).doc(idDoLancamento).update({
      CAMPO_PAGO : true,
      CAMPO_DATA_PAGAMENTO : dataDoPagamento
    }).then((value) => onSuccess()).catchError((e){
      onFail();
    });
  }
  //#endregion Métodos

}