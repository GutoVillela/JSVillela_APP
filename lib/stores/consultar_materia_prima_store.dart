import 'package:jsvillela_app/dml/materia_prima_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/materia_prima_parse.dart';
import 'package:mobx/mobx.dart';

part 'consultar_materia_prima_store.g.dart';

class ConsultarMateriaPrimaStore = _ConsultarMateriaPrimaStore with _$ConsultarMateriaPrimaStore;

abstract class _ConsultarMateriaPrimaStore with Store{

  //#region Construtor(es)
  //#endregion Construtor(es)

  //#region Observables
  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  /// Atributo observável que define o termo de busca definido em tela.
  @observable
  String termoDeBusca = "";

  ///Atributo observável que define a lista de MP a ser exibida em tela.
  ObservableList<MateriaPrimaDmo> listaDeMateriaPrima = ObservableList<MateriaPrimaDmo>();

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

  ///Action que define o valor do atributo observável "listaDeMateriaPrima".
  @action
  void setListaDeRedeiros(List<MateriaPrimaDmo> value) {
    listaDeMateriaPrima.clear();
    listaDeMateriaPrima.addAll(value);
  }

  /// Action responsável por obter a lista de MP do Parse Server de forma paginada.
  @action
  Future<void> obterListaDeMateriaPrimaPaginada(bool limpaLista, String? filtroPorNome) async{

    // Indicar que classe iniciou o processamento.
    if(limpaLista){
      processando = true;
      listaDeMateriaPrima.clear();
    }

    try{

      // Consultar lista no Parse Server
      List<MateriaPrimaDmo> listaObtida = await MateriaPrimaParse().obterListaDeMateriaPrimaPaginadas(listaDeMateriaPrima.length, filtroPorNome);

      // Definir se existem mais registros a serem buscados futuramente.
      temMaisRegistros = listaObtida.length >= Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING;

      // Adicionar itens da consulta paginada na lista de itens da tela
      listaDeMateriaPrima.addAll(listaObtida);

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

  /// Action responsável por obter a lista de MP do Parse Server de forma paginada aplicando filtro de nome.
  @action
  Future<void> obterListaDeRedePaginadaComFiltro(String filtroNome) async{
    await obterListaDeMateriaPrimaPaginada(true, filtroNome);
  }

  @action
  Future<void> apagarMateriaPrima(String idMatPrima) async{
    try{

      // Apagar MP no Parse Server
      await MateriaPrimaParse().apagarMateriaPrima(idMatPrima);

      // Remover MP apagada da lista
      listaDeMateriaPrima.removeWhere((e) => e.id == idMatPrima);
    }
    catch (e){
      erro = e.toString();
    }
  }

//#endregion Actions
}