// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultar_redeiros_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConsultarRedeirosStore on _ConsultarRedeirosStore, Store {
  final _$processandoAtom = Atom(name: '_ConsultarRedeirosStore.processando');

  @override
  bool get processando {
    _$processandoAtom.reportRead();
    return super.processando;
  }

  @override
  set processando(bool value) {
    _$processandoAtom.reportWrite(value, super.processando, () {
      super.processando = value;
    });
  }

  final _$termoDeBuscaAtom = Atom(name: '_ConsultarRedeirosStore.termoDeBusca');

  @override
  String get termoDeBusca {
    _$termoDeBuscaAtom.reportRead();
    return super.termoDeBusca;
  }

  @override
  set termoDeBusca(String value) {
    _$termoDeBuscaAtom.reportWrite(value, super.termoDeBusca, () {
      super.termoDeBusca = value;
    });
  }

  final _$temMaisRegistrosAtom =
      Atom(name: '_ConsultarRedeirosStore.temMaisRegistros');

  @override
  bool get temMaisRegistros {
    _$temMaisRegistrosAtom.reportRead();
    return super.temMaisRegistros;
  }

  @override
  set temMaisRegistros(bool value) {
    _$temMaisRegistrosAtom.reportWrite(value, super.temMaisRegistros, () {
      super.temMaisRegistros = value;
    });
  }

  final _$erroAtom = Atom(name: '_ConsultarRedeirosStore.erro');

  @override
  String? get erro {
    _$erroAtom.reportRead();
    return super.erro;
  }

  @override
  set erro(String? value) {
    _$erroAtom.reportWrite(value, super.erro, () {
      super.erro = value;
    });
  }

  final _$obterListaDeRedeirosPaginadaAsyncAction =
      AsyncAction('_ConsultarRedeirosStore.obterListaDeRedeirosPaginada');

  @override
  Future<void> obterListaDeRedeirosPaginada(
      bool limpaLista, String? filtroPorNome) {
    return _$obterListaDeRedeirosPaginadaAsyncAction.run(
        () => super.obterListaDeRedeirosPaginada(limpaLista, filtroPorNome));
  }

  final _$obterListaDeRedeirosPaginadasComFiltroAsyncAction = AsyncAction(
      '_ConsultarRedeirosStore.obterListaDeRedeirosPaginadasComFiltro');

  @override
  Future<void> obterListaDeRedeirosPaginadasComFiltro(String filtroNome) {
    return _$obterListaDeRedeirosPaginadasComFiltroAsyncAction
        .run(() => super.obterListaDeRedeirosPaginadasComFiltro(filtroNome));
  }

  final _$ativarOuDesativarRedeiroAsyncAction =
      AsyncAction('_ConsultarRedeirosStore.ativarOuDesativarRedeiro');

  @override
  Future<RedeiroDmo?> ativarOuDesativarRedeiro(String idRedeiro, bool ativar) {
    return _$ativarOuDesativarRedeiroAsyncAction
        .run(() => super.ativarOuDesativarRedeiro(idRedeiro, ativar));
  }

  final _$apagarRedeiroAsyncAction =
      AsyncAction('_ConsultarRedeirosStore.apagarRedeiro');

  @override
  Future<void> apagarRedeiro(String idRedeiro) {
    return _$apagarRedeiroAsyncAction.run(() => super.apagarRedeiro(idRedeiro));
  }

  final _$_ConsultarRedeirosStoreActionController =
      ActionController(name: '_ConsultarRedeirosStore');

  @override
  void setTermoDeBusca(String value) {
    final _$actionInfo = _$_ConsultarRedeirosStoreActionController.startAction(
        name: '_ConsultarRedeirosStore.setTermoDeBusca');
    try {
      return super.setTermoDeBusca(value);
    } finally {
      _$_ConsultarRedeirosStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setListaDeRedeiros(List<RedeiroDmo> value) {
    final _$actionInfo = _$_ConsultarRedeirosStoreActionController.startAction(
        name: '_ConsultarRedeirosStore.setListaDeRedeiros');
    try {
      return super.setListaDeRedeiros(value);
    } finally {
      _$_ConsultarRedeirosStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processando: ${processando},
termoDeBusca: ${termoDeBusca},
temMaisRegistros: ${temMaisRegistros},
erro: ${erro}
    ''';
  }
}
