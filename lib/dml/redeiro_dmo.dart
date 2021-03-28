import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/dml/endereco_dmo.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';

/// Classe modelo para redeiros.
class RedeiroDmo implements BaseDmo{

  //#region Atributos

  /// Id do Redeiro.
  String id;

  /// Nome do redeiro.
  String nome;

  /// Celular do redeiro.
  String celular;

  /// Email do redeiro.
  String email;

  /// Indica se o celular do redeiro recebe mensagens via WhatsApp.
  bool whatsApp;

  /// Endereço do Cliente.
  EnderecoDmo endereco;

  /// Indica se o redeiro está ativo ou não.
  bool ativo;

  /// Lista de grupos associados ao redeiro.
  List<GrupoDeRedeirosDmo> gruposDoRedeiro;

  //#endregion Atributos

  //#region Construtor(es)
  RedeiroDmo({this.id, this.nome, this.celular, this.email, this.whatsApp, this.endereco, this.ativo, this.gruposDoRedeiro});
  //#endregion Construtor(es)

  //#region Métodos

  /// Converte um snapshot em um objeto RedeiroDmo.
  static RedeiroDmo converterSnapshotEmRedeiro(DocumentSnapshot redeiro){

    return RedeiroDmo(
        id: redeiro.id,
        nome: redeiro[RedeiroModel.CAMPO_NOME],
        celular: redeiro[RedeiroModel.CAMPO_CELULAR],
        email: redeiro[RedeiroModel.CAMPO_EMAIL],
        whatsApp: redeiro[RedeiroModel.CAMPO_WHATSAPP],
        endereco: EnderecoDmo(
            logradouro: redeiro[RedeiroModel.CAMPO_ENDERECO][RedeiroModel.CAMPO_ENDERECO_LOGRADOURO],
            numero: redeiro[RedeiroModel.CAMPO_ENDERECO][RedeiroModel.CAMPO_ENDERECO_NUMERO],
            bairro: redeiro[RedeiroModel.CAMPO_ENDERECO][RedeiroModel.CAMPO_ENDERECO_BAIRRO],
            cidade: redeiro[RedeiroModel.CAMPO_ENDERECO][RedeiroModel.CAMPO_ENDERECO_CIDADE],
            cep: redeiro[RedeiroModel.CAMPO_ENDERECO][RedeiroModel.CAMPO_ENDERECO_CEP],
            complemento: redeiro[RedeiroModel.CAMPO_ENDERECO][RedeiroModel.CAMPO_ENDERECO_COMPLEMENTO],
            posicao: Position(
                longitude: (redeiro[RedeiroModel.CAMPO_ENDERECO][RedeiroModel.CAMPO_ENDERECO_POSICAO] as GeoPoint).longitude,
                latitude: (redeiro[RedeiroModel.CAMPO_ENDERECO][RedeiroModel.CAMPO_ENDERECO_POSICAO] as GeoPoint).latitude
            )
        ),
        ativo: redeiro[RedeiroModel.CAMPO_ATIVO],
        gruposDoRedeiro: (redeiro[RedeiroModel.SUBCOLECAO_GRUPOS] as List)
            .map((e) => GrupoDeRedeirosDmo(
            idGrupo: e)).toList()
    );
  }

  @override
  String toString() {
    return 'id: $id, '
        'nome: $nome, '
        'celular: $celular, '
        'email: $email, '
        'endereco: ${endereco.toString()}, '
        'gruposDoRedeiro: [${gruposDoRedeiro.map((e) => "{ id: " + e.idGrupo + ", nomeGrupo: " + e.nomeGrupo + "} ")}].';
  }

  @override
  Map<String, dynamic> converterParaMapa() {
    return {
      RedeiroModel.CAMPO_NOME : nome,
      RedeiroModel.CAMPO_CELULAR : celular,
      RedeiroModel.CAMPO_EMAIL : email,
      RedeiroModel.CAMPO_WHATSAPP : whatsApp,
      RedeiroModel.CAMPO_ENDERECO : endereco.converterParaMapa(),
      RedeiroModel.CAMPO_ATIVO : ativo,
      RedeiroModel.SUBCOLECAO_GRUPOS : gruposDoRedeiro.map((e) => e.idGrupo).toList()
    };
  }
  //#endregion Métodos
}