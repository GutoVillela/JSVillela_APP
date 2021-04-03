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
  //#endregion Métodos

}