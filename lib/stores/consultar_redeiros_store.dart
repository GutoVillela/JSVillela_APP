import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/redeiro_parse.dart';
import 'package:mobx/mobx.dart';

part 'consultar_redeiros_store.g.dart';

class ConsultarRedeirosStore = _ConsultarRedeirosStore with _$ConsultarRedeirosStore;

abstract class _ConsultarRedeirosStore with Store{

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
  ObservableList<RedeiroDmo> listaDeRedeiros = ObservableList<RedeiroDmo>();

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

  ///Action que define o valor do atributo observável "listaDeRedeiros".
  @action
  void setListaDeRedeiros(List<RedeiroDmo> value) {
    listaDeRedeiros.clear();
    listaDeRedeiros.addAll(value);
  }

  /// Action responsável por obter a lista de Redeiros do Parse Server de forma paginada.
  @action
  Future<void> obterListaDeRedeirosPaginada(bool limpaLista, String? filtroPorNome) async{

    // Indicar que classe iniciou o processamento.
    if(limpaLista){
      processando = true;
      listaDeRedeiros.clear();
    }

    try{

      // Consultar lista no Parse Server
      List<RedeiroDmo> listaObtida = await RedeiroParse().obterListaRedeirosPaginadas(listaDeRedeiros.length, filtroPorNome);

      // Definir se existem mais registros a serem buscados futuramente.
      temMaisRegistros = listaObtida.length >= Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING;

      // Adicionar itens da consulta paginada na lista de itens da tela
      listaDeRedeiros.addAll(listaObtida);

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

  /// Action responsável por obter a lista de Redeiros do Parse Server de forma paginada aplicando filtro de nome.
  @action
  Future<void> obterListaDeRedeirosPaginadasComFiltro(String filtroNome) async{
    await obterListaDeRedeirosPaginada(true, filtroNome);
  }

  /// Action que realiza processo de ativar ou desativar redeiro.
  @action
  Future<RedeiroDmo?> ativarOuDesativarRedeiro(String idRedeiro, bool ativar) async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{

      // Realizar edição do grupo.
      RedeiroDmo redeiro = await RedeiroParse().ativarOuDesativarRedeiro(idRedeiro, ativar);

      // Indicar que classe finalizou o processamento.
      processando = false;

      // Retornar novo grupo
      return redeiro;
    }
    catch (e){
      //erro = e.toString();
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      processando = false;
      return null;
    }
  }

  /// Action responsável por obter a lista de Redeiros do Parse Server de forma paginada aplicando filtro de nome.
  @action
  Future<void> apagarRedeiro(String idRedeiro) async{

    try{

      // Apagar redeiro no Parse Server
      await RedeiroParse().apagarRedeiro(idRedeiro);

      // Remover redeiro apagado da lista
      listaDeRedeiros.removeWhere((e) => e.id == idRedeiro);
    }
    catch (e){
      erro = e.toString();
    }

  }

//#endregion Actions
}