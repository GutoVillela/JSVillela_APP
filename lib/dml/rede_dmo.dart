import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/parse_server/rede_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RedeDmo implements BaseDmo{

  //Id da rede
  String? id;

  /// Nome da Rede
  String nomeRede;

  /// Valor da Rede
  double valorUnitarioRede;

  RedeDmo({required this.id, required this.nomeRede, required this.valorUnitarioRede});

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  RedeDmo.fromParse(ParseObject parseObject) :
        id = parseObject.objectId ?? "",
        nomeRede = parseObject.get(RedeParse.CAMPO_NOME_REDE) ?? "Falha ao obter o nome da rede",
        valorUnitarioRede = double.parse(parseObject.get(RedeParse.CAMPO_VLR_UNITARIO).toString());

  @override
  String toString() {
    return
        'id: $id, '
        'nome_rede: $nomeRede, '
        'valor_unitário_rede: $valorUnitarioRede';
  }
}