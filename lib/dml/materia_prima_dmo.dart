import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/parse_server/materia_prima_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

/// Classe modelo para matéria-prima.
class MateriaPrimaDmo implements BaseDmo{

  //#region Atributos

  /// Id da matéria-prima.
  String? id;

  /// Nome da matéria-prima.
  String nomeMateriaPrima;

  /// Ícone da matéria-prima.
  String iconeMateriaPrima;

  //#endregion Atributos

  //#region Construtor(es)
  MateriaPrimaDmo({this.id, required this.nomeMateriaPrima, required this.iconeMateriaPrima});
  //#endregion Construtor(es)

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  MateriaPrimaDmo.fromParse(ParseObject parseObject) :
        id = parseObject.objectId ?? "",
        nomeMateriaPrima = parseObject.get(MateriaPrimaParse.CAMPO_NOME_MATERIA_PRIMA) ?? "Falha ao obter o nome da matéria prima",
        iconeMateriaPrima = parseObject.get(MateriaPrimaParse.CAMPO_ICONE_MATERIA_PRIMA);

  /// Construtor que inicializa objetos de acordo com um mapa do Parse Server.
  MateriaPrimaDmo.fromMap(Map<String, dynamic> mapa) :
        id = mapa[MateriaPrimaParse.CAMPO_ID_MP],
        nomeMateriaPrima = mapa[MateriaPrimaParse.CAMPO_NOME_MATERIA_PRIMA],
        iconeMateriaPrima = mapa[MateriaPrimaParse.CAMPO_ICONE_MATERIA_PRIMA];

  @override
  String toString() {
    return  'id : $id,'
            'nomeMateriaPrima : $nomeMateriaPrima,'
            'iconeMateriaPrima : $iconeMateriaPrima';
  }
  //#endregion Métodos

  //#region Métodos
}