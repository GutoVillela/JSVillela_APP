import 'package:jsvillela_app/dml/rede_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/rede_parse.dart';
import 'package:mobx/mobx.dart';

part 'consultar_rede_store.g.dart';

class ConsultarRedeStore = _ConsultarRedeStore with _$ConsultarRedeStore;

abstract class _ConsultarRedeStore with Store{

  //#region Construtor(es)
  //#endregion Construtor(es)

  //#region Observables
  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  /// Atributo observável que define o termo de busca definido em tela.
  @observable
  String termoDeBusca = "";

  ///Atributo observável que define a lista de redeiros a ser exibida em tela.
  ObservableList<RedeDmo> listaDeRede = ObservableList<RedeDmo>();

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

  ///Action que define o valor do atributo observável "listaDeRede".
  @action
  void setListaDeRedeiros(List<RedeDmo> value) {
    listaDeRede.clear();
    listaDeRede.addAll(value);
  }

  /// Action responsável por obter a lista de Rede do Parse Server de forma paginada.
  @action
  Future<void> obterListaDeRedePaginada(bool limpaLista, String? filtroPorNome) async{

    // Indicar que classe iniciou o processamento.
    if(limpaLista){
      processando = true;
      listaDeRede.clear();
    }

    try{

      // Consultar lista no Parse Server
      List<RedeDmo> listaObtida = await RedeParse().obterListaDeRedePaginadas(listaDeRede.length, filtroPorNome);

      // Definir se existem mais registros a serem buscados futuramente.
      temMaisRegistros = listaObtida.length >= Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING;

      // Adicionar itens da consulta paginada na lista de itens da tela
      listaDeRede.addAll(listaObtida);

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

  /// Action responsável por obter a lista de Rede do Parse Server de forma paginada aplicando filtro de nome.
  @action
  Future<void> obterListaDeRedePaginadaComFiltro(String filtroNome) async{
    await obterListaDeRedePaginada(true, filtroNome);
  }

  @action
  Future<void> apagarRede(String idRede) async{
    try{

      // Apagar rede no Parse Server
      await RedeParse().apagarRede(idRede);

      // Remover rede apagada da lista
      listaDeRede.removeWhere((e) => e.id == idRede);
    }
    catch (e){
      erro = e.toString();
    }
  }
  //#endregion Actions
}