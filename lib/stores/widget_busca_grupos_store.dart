import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/models/checklist_item_model.dart';
import 'package:jsvillela_app/parse_server/grupo_de_redeiros_parse.dart';
import 'package:mobx/mobx.dart';

part 'widget_busca_grupos_store.g.dart';

class WidgetBuscaGruposStore = _WidgetBuscaGruposStore with _$WidgetBuscaGruposStore;

abstract class _WidgetBuscaGruposStore with Store{

  //#region Construtor(es)
  _WidgetBuscaGruposStore({required this.gruposJaSelecionados});
  //#endregion Construtor(es)

  //#region Atributos
  ///Define a lista de grupos que serão selecionados por padrão.
  final List<GrupoDeRedeirosDmo> gruposJaSelecionados;
  //#endregion Atributos

  //#region Observables

  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  /// Lista obsersável de CheckListItem usado para demarcar os grupos de redeiros selecionados.
  ObservableList<CheckListItemModel> listaDeGruposDeRedeiros = ObservableList<CheckListItemModel>();

  ///Atributo observável que define se existem mais registros a serem buscados.
  @observable
  bool temMaisRegistros = true;

  /// Atributo observável que define se ocorreu algum erro durante processo de login.
  @observable
  String? erro;

  //#endregion Observables

  //#region Actions
  /// Action responsável por obter a lista de Grupos de Redeiros do Parse Server de forma paginada.
  @action
  Future<void> obterListaDeGruposPaginados(bool limpaLista) async{

    // Indicar que classe iniciou o processamento.
    if(limpaLista){
      processando = true;
      listaDeGruposDeRedeiros.clear();
    }

    try{

      // Consultar lista no Parse Server
      List<GrupoDeRedeirosDmo> listaObtida = await GrupoDeRedeirosParse().obterListaDeGruposPaginadas(listaDeGruposDeRedeiros.length, null);

      // Definir se existem mais registros a serem buscados futuramente.
      temMaisRegistros = listaObtida.length >= Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING;

      // Adicionar itens da consulta paginada na lista de itens da tela
      listaDeGruposDeRedeiros.addAll(listaObtida.map((e) => CheckListItemModel(id: e.idGrupo, texto: e.nomeGrupo, checado: gruposJaSelecionados.any((grupo) => grupo.idGrupo == e.idGrupo))));

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
  //#endregion Actions

}