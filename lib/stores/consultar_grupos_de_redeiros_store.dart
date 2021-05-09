import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/grupo_de_redeiros_parse.dart';
import 'package:mobx/mobx.dart';

part 'consultar_grupos_de_redeiros_store.g.dart';

class ConsultarGruposDeRedeirosStore = _ConsultarGruposDeRedeirosStore with _$ConsultarGruposDeRedeirosStore;

abstract class _ConsultarGruposDeRedeirosStore with Store{

  //#region Observables
  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  /// Atributo observável que define o nome do grupo definido em tela.
  @observable
  String termoDeBusca = "";

  ///Atributo observável que define a lista de grupos a ser exibida em tela.
  ObservableList<GrupoDeRedeirosDmo> listaDeGruposDeRedeiros = ObservableList<GrupoDeRedeirosDmo>();

  ///Atributo observável que define se existem mais registros a serem buscados.
  @observable
  bool temMaisRegistros = true;

  /// Atributo observável que define se ocorreu algum erro durante processo de login.
  @observable
  String? erro;
  //#endregion Observables

  //#region Computed

  //#endregion Computed

  //#region Actions

  ///Action que define o valor do atributo observável "senha".
  @action
  void setTermoDeBusca(String value) => termoDeBusca = value;

  /// Action responsável por obter a lista de Grupos de Redeiros do Parse Server de forma paginada.
  @action
  Future<void> obterListaDeGruposPaginadas(bool limpaLista, String? filtroPorNome) async{

    // Indicar que classe iniciou o processamento.
    if(limpaLista){
      processando = true;
      listaDeGruposDeRedeiros.clear();
    }


    try{

      // Consultar lista no Parse Server
      List<GrupoDeRedeirosDmo> listaObtida = await GrupoDeRedeirosParse().obterListaDeGruposPaginadas(listaDeGruposDeRedeiros.length, filtroPorNome);

      // Definir se existem mais registros a serem buscados futuramente.
      temMaisRegistros = listaObtida.length >= Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING;

      // Adicionar itens da consulta paginada na lista de itens da tela
      listaDeGruposDeRedeiros.addAll(listaObtida);

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

  /// Action responsável por obter a lista de Grupos de Redeiros do Parse Server de forma paginada aplicando filtro de nome.
  @action
  Future<void> obterListaDeGruposPaginadasComFiltro(String filtroNome) async{
    await obterListaDeGruposPaginadas(true, filtroNome);
  }

  /// Action responsável por obter a lista de Grupos de Redeiros do Parse Server de forma paginada aplicando filtro de nome.
  @action
  Future<void> apagarGrupoDeRedeiros(String idGrupo) async{

    try{

      // Apagar grupo de redeiros no Parse Server
      await GrupoDeRedeirosParse().apagarGrupoDeRedeiros(idGrupo);

      // Remover grupo apagado da lista
      listaDeGruposDeRedeiros.removeWhere((e) => e.idGrupo == idGrupo);
    }
    catch (e){
      erro = e.toString();
    }

  }

  //#endregion Actions
}