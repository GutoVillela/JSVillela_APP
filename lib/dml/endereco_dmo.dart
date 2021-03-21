import 'package:geolocator/geolocator.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';

/// Classe modelo para endereços.
class EnderecoDmo implements BaseDmo{

  //#region Atributos

  /// Logradouro (normalmente nome da rua).
  String logradouro;

  /// Número.
  String numero;

  /// Bairro.
  String bairro;

  /// Cidade.
  String cidade;

  /// CEP.
  String cep;

  /// Complemento para endereço do redeiro.
  String complemento;

  /// Posição exata do endereço no mapa.
  Position posicao;

  //#endregion Atributos

  //#region Construtor(es)
  EnderecoDmo({this.logradouro, this.numero, this.bairro, this.cidade, this.cep, this.complemento, this.posicao});
  //#endregion Construtor(es)

  //#region Métodos
  @override
  String toString() {
    return '${logradouro ?? ""}, ${numero ?? "S/N"}, ${bairro != null ? "$bairro," : ""} ${cidade ?? ""}${cep != null && cep.isNotEmpty ? " - " + cep : ""}';
  }

  @override
  Map<String, dynamic> converterParaMapa() {
    return {
      RedeiroModel.CAMPO_ENDERECO_LOGRADOURO : this.logradouro,
      RedeiroModel.CAMPO_ENDERECO_NUMERO : this.numero,
      RedeiroModel.CAMPO_ENDERECO_BAIRRO : this.bairro,
      RedeiroModel.CAMPO_ENDERECO_CIDADE : this.cidade,
      RedeiroModel.CAMPO_ENDERECO_CEP : this.cep,
      RedeiroModel.CAMPO_ENDERECO_COMPLEMENTO : this.complemento,
      RedeiroModel.CAMPO_ENDERECO_POSICAO : GeoPoint(this.posicao.latitude, this.posicao.longitude)
    };
  }


  //#endregion Métodos
}