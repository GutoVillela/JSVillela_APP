import 'package:get_it/get_it.dart';
import 'package:jsvillela_app/parse_server/recolhimento_parse.dart';
import 'package:mobx/mobx.dart';

import 'inicio_store.dart';

part 'card_recolhimento_em_andamento_store.g.dart';

class CardRecolhimentoEmAndamentoStore = _CardRecolhimentoEmAndamentoStore with _$CardRecolhimentoEmAndamentoStore;

abstract class _CardRecolhimentoEmAndamentoStore with Store{
  //#region Atributos

  /// Store que controla tela inicial.
  final InicioStore inicioStore = GetIt.I<InicioStore>();
  //#endregion Atributos

  //#region Observables
  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool terminandoRecolhimento = false;

  //#endregion Observables

  //#region Computed

  /// Define se recolhimento do redeiro foi finalizado ou não
  @computed
  bool get habilitaBotaoTerminarRecolhimento => !terminandoRecolhimento;

  //#endregion Computed

  //#region Actions
  /// Action que realiza processo de terminar recolhimento.
  @action
  Future<void> terminarRecolhimento() async {

    // Indicar que classe iniciou o processamento.
    terminandoRecolhimento = true;

    try{

      DateTime dataFinalizado = DateTime.now();

      // Terminar recolhimento
      await RecolhimentoParse().terminarRecolhimento(inicioStore.recolhimentoDoDia!.id!, dataFinalizado);

      // Indicar que classe finalizou o processamento.
      terminandoRecolhimento = false;

      // Indicar interface principal que recolhimento foi finalizado
      inicioStore.recolhimentoDoDia!.dataFinalizado = dataFinalizado;
      inicioStore.recolhimentoDoDia = inicioStore.recolhimentoDoDia;
    }
    catch (e){
      //erro = e.toString();
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      terminandoRecolhimento = false;
      return null;
    }
  }
//#endregion Actions
}