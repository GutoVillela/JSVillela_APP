import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/materia_prima_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/solicitacao_do_redeiro_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/models/materia_prima_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model para solicitação do redeiro.
class SolicitacaoDoRedeiroModel extends Model{

  //#region Atributos

  /// Lista de solicitacões associadas ao model.
  List<SolicitacaoDoRedeiroDmo> solicitacoes = [];
  
  /// Indica que existe um processo em execução a partir desta classe.
  bool estaCarregando = false;

  //#endregion Atributos

  //#region Constantes

  /// Nome do identificador para a coleção "solicitacoes_dos_redeiros" utilizado no Firebase.
  static const String NOME_COLECAO = "solicitacoes_dos_redeiros";

  /// Nome do identificador para o campo "redeiro_solicitante" utilizado na collection do Firebase.
  static const String CAMPO_REDEIRO_SOLICITANTE = "redeiro_solicitante";

  /// Nome do identificador para o campo "data_solicitacao" utilizado na collection do Firebase.
  static const String CAMPO_DATA_SOLICITACAO = "data_solicitacao";

  /// Nome do identificador para o campo "data_finalizacao" utilizado na collection do Firebase.
  static const String CAMPO_DATA_FINALIZACAO = "data_finalizacao";

  /// Nome do identificador para o campo "materiais_solicitados" utilizado na collection do Firebase.
  static const String CAMPO_MATERIAIS_SOLICITADOS = "materiais_solicitados";

  //#endregion Constantes

  //#region Construtor(es)
  SolicitacaoDoRedeiroModel(){
    _carregarSolicitacoes(true);
  }
  //#endregion Construtor(es)

  //#region Métodos
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  /// Carrega as solicitações dos redeiros.
  void _carregarSolicitacoes(bool somenteNaoAtendidas) async{

    estaCarregando = true;
    notifyListeners();

    QuerySnapshot solicitacoes;

    if(somenteNaoAtendidas)
      solicitacoes = await FirebaseFirestore.instance.collection(NOME_COLECAO)
        //.where(CAMPO_DATA_FINALIZACAO, isNull: true)
        .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        .get();
    else
      solicitacoes = await FirebaseFirestore.instance.collection(NOME_COLECAO)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .get();

    this.solicitacoes = solicitacoes.docs.map((e) => SolicitacaoDoRedeiroDmo.converterSnapshotEmDmo(e)).toList();

    //Buscar informações dos redeiros solicitantes e das matérias primas solicitadas
    for(int i = 0; i < this.solicitacoes.length; i++){
      DocumentSnapshot redeiroCarregado = await RedeiroModel().carregarRedeiroPorId(this.solicitacoes[i].redeiroSolicitante.id);
      this.solicitacoes[i].redeiroSolicitante = RedeiroDmo.converterSnapshotEmRedeiro(redeiroCarregado);

      for(int j = 0; j < this.solicitacoes[i].materiasPrimasSolicitadas.length; j++){
        DocumentSnapshot materiaPrimaCarregada = await MateriaPrimaModel().carregarMateriaPrimaPorId(this.solicitacoes[i].materiasPrimasSolicitadas[j].id);
        this.solicitacoes[i].materiasPrimasSolicitadas[j] = MateriaPrimaDmo.converterSnapshotEmDmo(materiaPrimaCarregada);
      }
    }

    estaCarregando = false;
    notifyListeners();
  }

  /// Carrega as solicitações dos redeiros de forma paginada diretamente do Firebase.
  Future<QuerySnapshot> carregarSolicitacoesPaginadas(DocumentSnapshot ultimaSolicitacao, String filtroNomeRedeiro, bool incluirJaAtendidas) async{

    if(filtroNomeRedeiro != null && filtroNomeRedeiro.isNotEmpty){

      // Obter ids dos redeiros caso filtro por tenha sido fornecido.
      List<String> idsDosRedeiros = await RedeiroModel().obterIdsPorNome(filtroNomeRedeiro);

      if(ultimaSolicitacao == null){
        if(incluirJaAtendidas){
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_SOLICITACAO)
              .where(CAMPO_REDEIRO_SOLICITANTE, whereIn: idsDosRedeiros)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
        else{
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_SOLICITACAO)
              .where(CAMPO_REDEIRO_SOLICITANTE, whereIn: idsDosRedeiros)
              .where(CAMPO_DATA_FINALIZACAO, isNull: true)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
      }
      else{
        if(incluirJaAtendidas){
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_SOLICITACAO)
              .where(CAMPO_REDEIRO_SOLICITANTE, whereIn: idsDosRedeiros)
              .startAfterDocument(ultimaSolicitacao)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
        else{
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_SOLICITACAO)
              .where(CAMPO_REDEIRO_SOLICITANTE, whereIn: idsDosRedeiros)
              .where(CAMPO_DATA_FINALIZACAO, isNull: true)
              .startAfterDocument(ultimaSolicitacao)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }

      }
    }

    if(ultimaSolicitacao == null){
      if(incluirJaAtendidas){
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .orderBy(CAMPO_DATA_SOLICITACAO).get();
      }
      else{
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .where(CAMPO_DATA_FINALIZACAO, isNull: true)
            .orderBy(CAMPO_DATA_SOLICITACAO).get();
      }
    }


    if(incluirJaAtendidas){
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .orderBy(CAMPO_DATA_SOLICITACAO)
          .startAfterDocument(ultimaSolicitacao)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .get();
    }
    else{
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .orderBy(CAMPO_DATA_SOLICITACAO)
          .startAfterDocument(ultimaSolicitacao)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .get();
    }
  }

  /// Carrega as os detalhes de redeiro solicitante e matérias primas solicitadas da solicitação.
  Future<SolicitacaoDoRedeiroDmo> carregarDetalhesDaSolicitacao(SolicitacaoDoRedeiroDmo solicitacao) async{

    // Carregar detalhes do redeiro.
    if(solicitacao.redeiroSolicitante != null && solicitacao.redeiroSolicitante.id != null){
      DocumentSnapshot redeiroCarregado = await RedeiroModel().carregarRedeiroPorId(solicitacao.redeiroSolicitante.id);
      solicitacao.redeiroSolicitante = RedeiroDmo.converterSnapshotEmRedeiro(redeiroCarregado);
    }

    // Carregar detalhes da solicitação.
    if(solicitacao.materiasPrimasSolicitadas != null && solicitacao.materiasPrimasSolicitadas.isNotEmpty){
      for(int i = 0; i < solicitacao.materiasPrimasSolicitadas.length; i++){
        if(solicitacao.materiasPrimasSolicitadas[i].id != null){
          DocumentSnapshot materiaPrimaCarregada = await MateriaPrimaModel().carregarMateriaPrimaPorId(solicitacao.materiasPrimasSolicitadas[i].id);
          solicitacao.materiasPrimasSolicitadas[i] = MateriaPrimaDmo.converterSnapshotEmDmo(materiaPrimaCarregada);
        }
      }
    }

    return solicitacao;
  }
//#endregion Métodos

}