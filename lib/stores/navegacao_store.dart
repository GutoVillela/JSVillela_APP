import 'package:mobx/mobx.dart';

part 'navegacao_store.g.dart';

class NavegacaoStore = _NavegacaoStore with _$NavegacaoStore;

/// Classe que contém a Store usada na navegação entre telas.
abstract class _NavegacaoStore with Store{

  //#region Observables
  /// Atributo observável que define a página aberta atual do aplicativo.
  @observable
  int paginaAtual = 0;

  /// Atributo observável que define a quantidade de notificações não lidas.
  @observable
  int notificacoes = 0;
  //#endregion Observables

  //#region Actions
  /// Action que define o valor do atributo observável "paginaAtual".
  @action
  void setPaginaAtual(int value) => paginaAtual = value;

  /// Action que define o valor do atributo observável "notificacoes".
  @action
  void setNotificacoes(int value) => notificacoes = value;

  /// Action que incrementa a notificação.
  @action
  void incrementarNotificacao() => notificacoes++;
  //#endregion Actions

}