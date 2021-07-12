import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/recolhimento_parse.dart';
import 'package:mobx/mobx.dart';

part 'consultar_recolhimentos_store.g.dart';

class ConsultarRecolhimentosStore = _ConsultarRecolhimentosStore with _$ConsultarRecolhimentosStore;

abstract class _ConsultarRecolhimentosStore with Store{
  //#region Construtor(es)

  //#endregion Construtor(es)

  //#region Atributos
  /// Formatar para para dd/MM/yyyy
  final formatoData = new DateFormat('dd/MM/yyyy');
  //#endregion Atributos

  //#region Observables
  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  /// Atributo observável que define o filtro de Data Inicial definido em tela.
  @observable
  DateTime? filtroDataInicial;

  /// Atributo observável que define o filtro de Data Final definido em tela.
  @observable
  DateTime? filtroDataFinal;

  /// Atributo observável que define o filtro de Incluir Recolhimentos Finalizados definido em tela.
  @observable
  bool incluirRecolhimentosFinalizados = false;


  ///Atributo observável que define a lista de recohlimentos a ser exibida em tela.
  ObservableList<RecolhimentoDmo> listaDeRecolhimentos = ObservableList<RecolhimentoDmo>();

  ///Atributo observável que define se existem mais registros a serem buscados.
  @observable
  bool temMaisRegistros = true;

  /// Atributo observável que define se ocorreu algum erro durante processamento da classe.
  @observable
  String? erro;
  //#endregion Observables

  //#region Computed
  /// Computed que guarda o texto do filtro de Data Inicial a ser exibido na tela.
  @computed
  String get textoFiltroDataInicial => filtroDataInicial == null ? "De" : formatoData.format(filtroDataInicial!);

  /// Computed que guarda o texto do filtro de Data Final a ser exibido na tela.
  @computed
  String get textoFiltroDataFinal => filtroDataFinal == null ? "Até" : formatoData.format(filtroDataFinal!);

  //#endregion Computed

  //#region Actions

  ///Action que define o valor do atributo observável "filtroDataInicial".
  @action
  void setFiltroDataInicial(DateTime? value) {

    // Atualizar estado da tela somente se uma data diferente for selecionada
    if(value != filtroDataInicial){
      filtroDataInicial = value;
      obterListaPaginadaDeRecolhimentos(true);
    }
  }

  ///Action que define o valor do atributo observável "filtroDataFinal".
  @action
  void setFiltroDataFinal(DateTime? value) {

    // Atualizar estado da tela somente se uma data diferente for selecionada
    if(value != filtroDataFinal){
      filtroDataFinal = value;
      obterListaPaginadaDeRecolhimentos(true);
    }
  }

  ///Action que define o valor do atributo observável "incluirRecolhimentosFinalizados".
  @action
  void setIncluirRecolhimentosFinalizados(bool? value) {
    incluirRecolhimentosFinalizados = value ?? false;
    obterListaPaginadaDeRecolhimentos(true);
  }

  /// Action responsável por obter a lista de Recolhimentos do Parse Server de forma paginada.
  @action
  Future<void> obterListaPaginadaDeRecolhimentos(bool limpaLista) async{

    // Indicar que classe iniciou o processamento.
    if(limpaLista){
      processando = true;
      listaDeRecolhimentos.clear();
    }

    try{

      // Consultar lista no Parse Server
      List<RecolhimentoDmo> listaObtida = await RecolhimentoParse().obterListaPaginadaDeRecolhimentos(
        registrosAPular: listaDeRecolhimentos.length,
        filtroDataInicial: filtroDataInicial,
        filtroDataFinal: filtroDataFinal,
        incluirRecolhimentosFinalizados: incluirRecolhimentosFinalizados
      );

      // Definir se existem mais registros a serem buscados futuramente.
      temMaisRegistros = listaObtida.length >= Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING;

      // Adicionar itens da consulta paginada na lista de itens da tela
      listaDeRecolhimentos.addAll(listaObtida);

      // Indicar que classe finalizou o processamento.
      if(limpaLista)
        processando = false;
    }
    catch (e){
      erro = e.toString();
      // Indicar que classe finalizou o processamento.
      if(limpaLista)
        processando = false;
    }
  }

  /// Action responsável por apagar o recolhimento.
  @action
  Future<void> apagarRecolhimento(String idRecolhimento) async{

    try{

      // Apagar recolhimento no Parse Server
      await RecolhimentoParse().apagarRecolhimento(idRecolhimento);

      // Remover grupo apagado da lista
      listaDeRecolhimentos.removeWhere((e) => e.id == idRecolhimento);
    }
    catch (e){
      erro = e.toString();
    }

  }

  /// Action responsável por buscar os grupos do recolhimento.
  @action
  Future<List<GrupoDeRedeirosDmo>> buscarGruposDoRecolhimento(String idRecolhimento) async{
    return await RecolhimentoParse().obterGruposDoRecolhimento(idRecolhimento);
  }
  //#endregion Actions
}