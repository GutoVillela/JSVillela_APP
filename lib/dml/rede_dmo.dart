class RedeDmo
{

  //Id da rede
  String id;

  /// Nome da Rede
  String nome_rede;

  /// Valor da Rede
  String valor_unitario_rede;

  RedeDmo({this.id, this.nome_rede, this.valor_unitario_rede});

  @override
  String toString() {
    return
        'id: $id, '
        'nome_rede: $nome_rede, '
        'valor_unitário_rede: $valor_unitario_rede';
  }
}