class MatPrimaDmo
{

  //Id da materia prima
  String id;

  /// Nome da Rede
  String nome_materia_prima;

  /// Valor da Rede
  String icone;

  MatPrimaDmo({this.id, this.nome_materia_prima, this.icone});

  @override
  String toString() {
    return
      'id: $id, '
          'nome_mat_prima: $nome_materia_prima, '
          'icone_mat_prima: $icone';
  }
}