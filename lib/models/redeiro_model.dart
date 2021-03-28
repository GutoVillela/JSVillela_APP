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

    FirebaseFirestore.instance.collection(NOME_COLECAO).add(
      dadosDoRedeiro.converterParaMapa()
    ).then((value) => onSuccess()).catchError((e){
      print(e.toString());
      onFail();
    });
  }

  /// Carrega os redeiros de forma paginada diretamente do Firebase.
  Future<QuerySnapshot> carregarRedeirosPaginados(DocumentSnapshot ultimoRedeiro, String filtroPorNome) {
    
    if(filtroPorNome != null && filtroPorNome.isNotEmpty){
      if(ultimoRedeiro == null){
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_NOME)
            .startAt([filtroPorNome])
            .endAt([filtroPorNome + "\uf8ff"])
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
      else{
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .orderBy(CAMPO_NOME)
            .startAt([filtroPorNome])
            .endAt([filtroPorNome + "\uf8ff"])
            .startAfterDocument(ultimoRedeiro)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
    }

    if(ultimoRedeiro == null)
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .orderBy(CAMPO_NOME).get();

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .orderBy(CAMPO_NOME)
        .startAfterDocument(ultimoRedeiro)
        .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        .get();
  }

  /// Carrega o caderno do redeiro diretamente do Firebase.
  Future<QuerySnapshot> carregarCadernoDoRedeiro(String idDoRedeiro) {

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .doc(idDoRedeiro)
        .collection(SUBCOLECAO_CADERNO)
        .orderBy(LancamentoNoCadernoModel.CAMPO_DATA_LANCAMENTO, descending: true)
        .get();
  }

  /// Carrega os endereços de todos os redeiros dentro do grupo.
  Future<QuerySnapshot> carregarRedeirosPorGrupos(List<String> idsDosGrupos){

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .where(SUBCOLECAO_GRUPOS, arrayContainsAny: idsDosGrupos)
        //.orderBy(CAMPO_NOME)
        .get();
  }

  /// Converte uma lista de redeiros em uma lista de cidades (sem repetição).
  List<String> obterCidadesDosRedeiros(List<DocumentSnapshot> redeiros){
    // Obter lista de cidades
    List<String> listaDeCidades = [];
    redeiros.forEach((element) {
      var redeiro = RedeiroDmo.converterSnapshotEmRedeiro(element);
      if(redeiro.endereco != null &&
          redeiro.endereco.cidade != null &&
          !listaDeCidades.any((cidade) => cidade == redeiro.endereco.cidade))
        listaDeCidades.add(redeiro.endereco.cidade);
    });

    return listaDeCidades;
  }

  /// Carrega o redeiro por ID diretamente do Firebase.
  Future<DocumentSnapshot> carregarRedeiroPorId(String idDoRedeiro) {

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .doc(idDoRedeiro)
        .get();
  }

  //#endregion Métodos

}