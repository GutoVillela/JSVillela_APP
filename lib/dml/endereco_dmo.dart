import 'package:geolocator/geolocator.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/parse_server/redeiro_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

/// Classe modelo para endereços.
class EnderecoDmo implements BaseDmo{

  //#region Atributos

  /// Logradouro (normalmente nome da rua).
  String? logradouro;

  /// Número.
  String? numero;

  /// Bairro.
  String? bairro;

  /// Cidade.
  String? cidade;

  /// CEP.
  String? cep;

  /// Complemento para endereço do redeiro.
  String? complemento;

  /// Posição exata do endereço no mapa.
  Position? posicao;

  //#endregion Atributos

  //#region Construtor(es)
  EnderecoDmo({this.logradouro, this.numero, this.bairro, this.cidade, this.cep, this.complemento, this.posicao});

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  EnderecoDmo.fromParse(ParseObject parseObject) :
    logradouro = parseObject.get(RedeiroParse.CAMPO_ENDERECO_LOGRADOURO) ?? "",
    numero = parseObject.get(RedeiroParse.CAMPO_ENDERECO_NUMERO) ?? "",
    bairro = parseObject.get(RedeiroParse.CAMPO_ENDERECO_BAIRRO) ?? "",
    cidade = parseObject.get(RedeiroParse.CAMPO_ENDERECO_CIDADE) ?? "",
    cep = parseObject.get(RedeiroParse.CAMPO_ENDERECO_CEP) ?? "",
    complemento = parseObject.get(RedeiroParse.CAMPO_ENDERECO_COMPLEMENTO) ?? "",
    posicao = parseObject.get<ParseGeoPoint>(RedeiroParse.CAMPO_ENDERECO_POSICAO) == null ? null : Position(longitude: parseObject.get<ParseGeoPoint>(RedeiroParse.CAMPO_ENDERECO_POSICAO)!.longitude, latitude: parseObject.get<ParseGeoPoint>(RedeiroParse.CAMPO_ENDERECO_POSICAO)!.latitude, timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0)
  ;

  EnderecoDmo.fromMap(Map<String, dynamic> mapa) :
        logradouro = mapa[RedeiroParse.CAMPO_ENDERECO_LOGRADOURO] ?? "",
        numero = mapa[RedeiroParse.CAMPO_ENDERECO_NUMERO] ?? "",
        bairro = mapa[RedeiroParse.CAMPO_ENDERECO_BAIRRO] ?? "",
        cidade = mapa[RedeiroParse.CAMPO_ENDERECO_CIDADE] ?? "",
        cep = mapa[RedeiroParse.CAMPO_ENDERECO_CEP] ?? "",
        complemento = mapa[RedeiroParse.CAMPO_ENDERECO_COMPLEMENTO] ?? "",
        posicao = Position(longitude: mapa[RedeiroParse.CAMPO_ENDERECO_POSICAO]['longitude'], latitude: mapa[RedeiroParse.CAMPO_ENDERECO_POSICAO]['latitude'], timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0)
  ;
  //#endregion Construtor(es)

  //#region Métodos
  @override
  String toString() {
    return '${logradouro ?? ""}, ${numero ?? "S/N"}, ${bairro != null ? "$bairro," : ""} ${cidade ?? ""}${cep != null ? " - $cep" : ""}';
  }
  //#endregion Métodos
}