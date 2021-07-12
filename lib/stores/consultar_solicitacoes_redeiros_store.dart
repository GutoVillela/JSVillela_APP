import 'package:jsvillela_app/dml/solicitacao_de_materia_prima_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/solicitacao_de_materia_prima_parse.dart';
import 'package:mobx/mobx.dart';

part 'consultar_solicitacoes_redeiros_store.g.dart';

class ConsultarSolicitacoesRedeirosStore = _ConsultarSolicitacoesRedeirosStore with _$ConsultarSolicitacoesRedeirosStore;

abstract class _ConsultarSolicitacoesRedeirosStore with Store{

  //#region Construtor(es)

  //#endregion Construtor(es)

  //#region Observables
  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  /// Atributo observável que define o termo de busca definido em tela.
  @observable
  String termoDeBusca = "";

  /// Atributo observável que define o filtro de Incluir Solicitações Atendidas definido em tela.
  @observable
  bool incluirSolicitacoesAtendidas = false;

  ///Atributo observável que define a lista de solicitações a serem exibidas em tela.
  ObservableList<SolicitacaoDeMateriaPrimaDmo> solicitacoes = ObservableList<SolicitacaoDeMateriaPrimaDmo>();

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

  ///Action que define o valor do atributo observável "termoDeBusca".
  @action
  void setTermoDeBusca(String value) => termoDeBusca = value;

  ///Action que define o valor do atributo observável "incluirSolicitacoesAtendidas".
  @action
  void setIncluirSolicitacoesAtendidas(bool? value) => incluirSolicitacoesAtendidas = value ?? false;

  ///Action que define o valor do atributo observável "solicitacoes".
  @action
  void setSolicitacoes(List<SolicitacaoDeMateriaPrimaDmo> value) {
    solicitacoes.clear();
    solicitacoes.addAll(value);
  }

  /// Action responsável por obter a lista de Redeiros do Parse Server de forma paginada.
  @action
  Future<void> obterListaDeSolicitacoesPaginada(bool limpaLista, String? filtroPorNome) async{

    // Indicar que classe iniciou o processamento.
    if(limpaLista){
      processando = true;
      solicitacoes.clear();
    }

    try{

      // Consultar lista no Parse Server
      List<SolicitacaoDeMateriaPrimaDmo> listaObtida = await SolicitacaoDeMateriaPrimaParse().obterListaPaginadaDeSolicitacoes(
        registrosAPular: solicitacoes.length,
        filtroNomeRedeiro: filtroPorNome,
        incluirSolicitacoesAtendidas: incluirSolicitacoesAtendidas
      );

      // Definir se existem mais registros a serem buscados futuramente.
      temMaisRegistros = listaObtida.length >= Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING;

      // Adicionar itens da consulta paginada na lista de itens da tela
      solicitacoes.addAll(listaObtida);

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

  /// Action responsável por obter a lista de Solicitações do Parse Server de forma paginada aplicando filtro de nome.
  @action
  Future<void> obterListaDeRedeirosPaginadasComFiltro(String filtroNome) async{
    await obterListaDeSolicitacoesPaginada(true, filtroNome);
  }

  // /// Action responsável por obter a lista de Redeiros do Parse Server de forma paginada aplicando filtro de nome.
  // @action
  // Future<void> apagarRedeiro(String idRedeiro) async{
  //
  //   try{
  //
  //     // Apagar redeiro no Parse Server
  //     await RedeiroParse().apagarRedeiro(idRedeiro);
  //
  //     // Remover redeiro apagado da lista
  //     listaDeRedeiros.removeWhere((e) => e.id == idRedeiro);
  //   }
  //   catch (e){
  //     erro = e.toString();
  //   }
  //
  // }

//#endregion Actions

}