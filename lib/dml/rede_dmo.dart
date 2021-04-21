import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/models/rede_model.dart';

class RedeDmo implements BaseDmo{

  //Id da rede
  String? id;

  /// Nome da Rede
  String? nome_rede;

  /// Valor da Rede
  double? valor_unitario_rede;

  RedeDmo({this.id, this.nome_rede, this.valor_unitario_rede});

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