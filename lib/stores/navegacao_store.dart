import 'package:mobx/mobx.dart';

part 'navegacao_store.g.dart';

class NavegacaoStore = _NavegacaoStore with _$NavegacaoStore;

abstract class _NavegacaoStore with Store{

  //#region Observables
  /// Atributo observável que define a página aberta atual do aplicativo.
  @observable
  int paginaAtual = 0;
  //#endregion Observables

  //#region Actions
  /// Action que define o valor do atributo observável "paginaAtual".
  @action
  void setPaginaAtual(int value) => paginaAtual = value;
  //#endregion Actions

}