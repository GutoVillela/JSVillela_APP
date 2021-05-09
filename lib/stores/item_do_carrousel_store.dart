import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/parse_server/redeiros_do_recolhimento_parse.dart';
import 'package:mobx/mobx.dart';

part 'item_do_carrousel_store.g.dart';

class ItemDoCarrouselStore = _ItemDoCarrouselStore with _$ItemDoCarrouselStore;

abstract class _ItemDoCarrouselStore with Store{

  //#region Construtor(es)
  _ItemDoCarrouselStore(this.redeiroDoRecolhimento);
  //#endregion Construtor(es)

  //#region Atributos
  /// Redeiro do recolhimento associado ao Card.
  final RedeiroDoRecolhimentoDmo redeiroDoRecolhimento;
  //#endregion Atributos

  //#region Observables
  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  ///Atributo observável que define se classe está carregando aplicativo de mapa.
  @observable
  bool carregandoMapa = false;


  //#endregion Observables

  //#region Computed

  //#endregion Computed

  //#region Actions
  /// Action que realiza processo de conclusão de recolhimento para o redeiro.
  @action
  Future<RedeiroDoRecolhimentoDmo?> finalizarRecolhimentoDoRedeiro() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{

      // Definir data de finalização do recolhimento
      redeiroDoRecolhimento.dataFinalizacao = DateTime.now();

      // Salvar recolhimento
      await RedeirosDoRecolhimentoParse().finalizarRecolhimentoDoRedeiro(
          idRedeiroDoRecolhimento: redeiroDoRecolhimento.id!,
          dataFinalizacao: redeiroDoRecolhimento.dataFinalizacao!
      );

      // Indicar que classe finalizou o processamento.
      processando = false;

      // Retornar novo redeiro
      return redeiroDoRecolhimento;
    }
    catch (e){
      //erro = e.toString();
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      processando = false;
      return null;
    }
  }

  /// Action que abre aplicativo de mapa com posição exata do redeiro.
  @action
  Future<void> abrirMapa() async {

    // Indicar que classe iniciou o processamento.
    carregandoMapa = true;

    try{

      //Abrir aplicativo de mapa
      await Infraestrutura.abrirMapa(redeiroDoRecolhimento.redeiro!.endereco.posicao!);

      // Indicar que classe finalizou o processamento.
      carregandoMapa = false;
    }
    catch (e){
      //erro = e.toString();
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      carregandoMapa = false;
      return null;
    }
  }
  //#endregion Actions

}