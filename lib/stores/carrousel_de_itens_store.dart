import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'carrousel_de_itens_store.g.dart';

class CarrouselDeItensStore = _CarrouselDeItensStore with _$CarrouselDeItensStore;

abstract class _CarrouselDeItensStore with Store{

  //#region Atributos
  /// Pagecontroller da tela de carrousel.
  PageController controller = PageController(viewportFraction: 0.8, keepPage: true);
  //#endregion Atributos

  //#region Observables
  ///Atributo observável que define card atual do carrousel.
  @observable
  int cardAtual = 0;

  ///Atributo observável que define se o recolhimento foi finalizado..
  @observable
  bool finalizouRecolhimento = false;
  //#endregion Observables

  //#region Actions
  ///Action que incrementa o valor do atributo observável "cardAtual".
  @action
  void proximoCard() {
    cardAtual++;
    controller.animateToPage(cardAtual, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  ///Action que define o valor do atributo observável "cardAtual".
  @action
  void setCardAtual(int value) {
    cardAtual = value;
    controller.animateToPage(cardAtual, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  ///Action que define o valor do atributo observável "finalizouRecolhimento".
  @action
  void setFinalizouRecolhimento(bool value) => finalizouRecolhimento = value;
  //#endregion Actions

}