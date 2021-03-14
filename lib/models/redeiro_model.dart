import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jsvillela_app/dml/endereco_dmo.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/models/lancamento_no_caderno.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';

/// Model para redeiros.
class RedeiroModel extends Model{

  //#region Atributos
  //#endregion Atributos

  //#region Constantes
  /// Nome do identificador para a coleção "redeiros" utilizado no Firebase.
  static const String NOME_COLECAO = "redeiros";

  /// Nome do identificador para o campo "nome" utilizado na collection do Firebase.
  static const String CAMPO_NOME = "nome";

  /// Nome do identificador para o campo "celular" utilizado na collection do Firebase.
  static const String CAMPO_CELULAR = "celular";

  /// Nome do identificador para o campo "email" utilizado na collection do Firebase.
  static const String CAMPO_EMAIL = "email";

  /// Nome do identificador para o campo "whatsapp" utilizado na collection do Firebase.
  static const String CAMPO_WHATSAPP = "whatsapp";

  /// Nome do identificador para o campo "endereco" utilizado na collection do Firebase.
  static const String CAMPO_ENDERECO = "endereco";

  /// Nome do identificador para o campo "logradouro" do objeto "endereco" utilizado na collection do Firebase.
  static const String CAMPO_ENDERECO_LOGRADOURO = "logradouro";

  /// Nome do identificador para o campo "numero" do objeto "endereco" utilizado na collection do Firebase.
  static const String CAMPO_ENDERECO_NUMERO = "numero";

  /// Nome do identificador para o campo "bairro" do objeto "bairro" utilizado na collection do Firebase.
  static const String CAMPO_ENDERECO_BAIRRO = "bairro";

  /// Nome do identificador para o campo "cidade" do objeto "endereco" utilizado na collection do Firebase.
  static const String CAMPO_ENDERECO_CIDADE = "cidade";

  /// Nome do identificador para o campo "cep" do objeto "endereco" utilizado na collection do Firebase.
  static const String CAMPO_ENDERECO_CEP = "cep";

  /// Nome do identificador para o campo "posicao" do objeto "endereco" utilizado na collection do Firebase.
  static const String CAMPO_ENDERECO_POSICAO = "posicao";

  /// Nome do identificador para o campo "complemento" do objeto "endereco" utilizado na collection do Firebase.
  static const String CAMPO_ENDERECO_COMPLEMENTO = "complemento";

  /// Nome do identificador para o campo "ativo" utilizado na collection do Firebase.
  static const String CAMPO_ATIVO = "ativo";

  /// Nome do identificador para a subcoleção "grupos" utilizado na collection do Firebase.
  static const String SUBCOLECAO_GRUPOS = "grupos_do_redeiro";

  /// Nome do identificador para a subcoleção "caderno" utilizado na collection do Firebase.
  static const String SUBCOLECAO_CADERNO = "caderno";
  //#endregion Constantes

  //#region Métodos
  ///Cadastra um redeiro no Firebase.
  void cadastrarRedeiro({@required RedeiroDmo dadosDoRedeiro, @required VoidCallback onSuccess, @required VoidCallback onFail}){

    // Converter lista de grupos do redeiro em mapa antes de gravar no Firebase.
    Set<Map<String, dynamic>> mapaDeGrupos;

    if(dadosDoRedeiro.gruposDoRedeiro != null && dadosDoRedeiro.gruposDoRedeiro.isNotEmpty)
      // Converter lista de grupos em um mapa
      mapaDeGrupos = { for (var v in dadosDoRedeiro.gruposDoRedeiro) { GrupoDeRedeirosModel.ID_COLECAO : v.idGrupo, GrupoDeRedeirosModel.CAMPO_NOME : v.nomeGrupo } };

    FirebaseFirestore.instance.collection(NOME_COLECAO).add({
      CAMPO_NOME : dadosDoRedeiro.nome,
      CAMPO_CELULAR : dadosDoRedeiro.celular,
      CAMPO_EMAIL : dadosDoRedeiro.email,
      CAMPO_WHATSAPP : dadosDoRedeiro.whatsApp,
      CAMPO_ENDERECO : dadosDoRedeiro.endereco.converterParaMapa(),
      CAMPO_ATIVO : dadosDoRedeiro.ativo,
      SUBCOLECAO_GRUPOS : mapaDeGrupos.toList()
    }).then((value) => onSuccess()).catchError((e){
      print(e.toString());
      onFail();
    });
  }

  /// Carrega os redeiros de forma paginada diretamente do Firebase.
  Future<QuerySnapshot> carregarRedeirosPaginados(DocumentSnapshot ultimoRedeiro, String filtroPorNome) {

    if(ultimoRedeiro == null)
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .orderBy(CAMPO_NOME).get();

    if(filtroPorNome != null && filtroPorNome.isNotEmpty){
      if(ultimoRedeiro == null)
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_NOME)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .where(CAMPO_NOME, isEqualTo: filtroPorNome)
            .get();
      else
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_NOME)
            .startAfterDocument(ultimoRedeiro)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .where(CAMPO_NOME, isEqualTo: filtroPorNome)
            .get();
    }

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .orderBy(CAMPO_NOME)
        .startAfterDocument(ultimoRedeiro)
        .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        .get();
  }

  /// Converte um snapshot em um objeto RedeiroDmo.
  RedeiroDmo converterSnapshotEmRedeiro(DocumentSnapshot redeiro){
    return RedeiroDmo(
        id: redeiro.id,
        nome: redeiro[CAMPO_NOME],
        celular: redeiro[CAMPO_CELULAR],
        email: redeiro[CAMPO_EMAIL],
        whatsApp: redeiro[CAMPO_WHATSAPP],
        endereco: EnderecoDmo(
            logradouro: redeiro[CAMPO_ENDERECO][CAMPO_ENDERECO_LOGRADOURO],
            numero: redeiro[CAMPO_ENDERECO][CAMPO_ENDERECO_NUMERO],
            bairro: redeiro[CAMPO_ENDERECO][CAMPO_ENDERECO_BAIRRO],
            cidade: redeiro[CAMPO_ENDERECO][CAMPO_ENDERECO_CIDADE],
            cep: redeiro[CAMPO_ENDERECO][CAMPO_ENDERECO_CEP],
            complemento: redeiro[CAMPO_ENDERECO][CAMPO_ENDERECO_COMPLEMENTO],
            posicao: Position(
                longitude: (redeiro[CAMPO_ENDERECO][CAMPO_ENDERECO_POSICAO] as GeoPoint).longitude,
                latitude: (redeiro[CAMPO_ENDERECO][CAMPO_ENDERECO_POSICAO] as GeoPoint).latitude
            )
        ),
        ativo: redeiro[CAMPO_ATIVO],
        gruposDoRedeiro: (redeiro[SUBCOLECAO_GRUPOS] as List)
            .map((e) => GrupoDeRedeirosDmo(
            idGrupo: e[GrupoDeRedeirosModel.ID_COLECAO],
            nomeGrupo: e[GrupoDeRedeirosModel.CAMPO_NOME])).toList()
    );
  }

  /// Carrega o caderno do redeiro diretamente do Firebase.
  Future<QuerySnapshot> carregarCadernoDoRedeiro(String idDoRedeiro) {

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .doc(idDoRedeiro)
        .collection(SUBCOLECAO_CADERNO)
        .orderBy(LancamentoNoCadernoModel.CAMPO_DATA_LANCAMENTO, descending: true)
        .get();
  }
  //#endregion Métodos

}