import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/models/rede_model.dart';
import 'package:jsvillela_app/parse_server/rede_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RedeDmo implements BaseDmo{

  //Id da rede
  String? id;

  /// Nome da Rede
  String? nome_rede;

  /// Valor da Rede
  double? valor_unitario_rede;

  RedeDmo({required this.id, required this.nome_rede, required this.valor_unitario_rede});

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  RedeDmo.fromParse(ParseObject parseObject) :
        id = parseObject.objectId ?? "",
        nome_rede = parseObject.get(RedeParse.CAMPO_NOME_REDE) ?? "Falha ao obter o nome da rede",
        valor_unitario_rede = parseObject.get(RedeParse.CAMPO_VLR_UNITARIO);

  /// Converte um snapshot em um objeto RedeDmo.
  static RedeDmo converterSnapshotEmRede(DocumentSnapshot rede){

    return RedeDmo(
        id: rede.id,
        nome_rede: rede[RedeModel.CAMPO_REDE],
        valor_unitario_rede: rede[RedeModel.CAMPO_VALOR_UNITARIO]
    );
  }

  @override
  String toString() {
    return
        'id: $id, '
        'nome_rede: $nome_rede, '
        'valor_unitário_rede: $valor_unitario_rede';
  }

  @override
  Map<String, dynamic> converterParaMapa() {
    return {
      RedeModel.CAMPO_REDE : nome_rede,
      RedeModel.CAMPO_VALOR_UNITARIO : valor_unitario_rede
    };
  }
}