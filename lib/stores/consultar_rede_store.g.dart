// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultar_rede_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConsultarRedeStore on _ConsultarRedeStore, Store {
  final _$processandoAtom = Atom(name: '_ConsultarRedeStore.processando');

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

  final _$termoDeBuscaAtom = Atom(name: '_ConsultarRedeStore.termoDeBusca');

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
      Atom(name: '_ConsultarRedeStore.temMaisRegistros');

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

  final _$erroAtom = Atom(name: '_ConsultarRedeStore.erro');

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

  final _$obterListaDeRedePaginadaAsyncAction =
      AsyncAction('_ConsultarRedeStore.obterListaDeRedePaginada');

  @override
  Future<void> obterListaDeRedePaginada(
      bool limpaLista, String? filtroPorNome) {
    return _$obterListaDeRedePaginadaAsyncAction
        .run(() => super.obterListaDeRedePaginada(limpaLista, filtroPorNome));
  }

  final _$obterListaDeRedePaginadaComFiltroAsyncAction =
      AsyncAction('_ConsultarRedeStore.obterListaDeRedePaginadaComFiltro');

  @override
  Future<void> obterListaDeRedePaginadaComFiltro(String filtroNome) {
    return _$obterListaDeRedePaginadaComFiltroAsyncAction
        .run(() => super.obterListaDeRedePaginadaComFiltro(filtroNome));
  }

  final _$apagarRedeAsyncAction = AsyncAction('_ConsultarRedeStore.apagarRede');

  @override
  Future<void> apagarRede(String idRede) {
    return _$apagarRedeAsyncAction.run(() => super.apagarRede(idRede));
  }

  final _$_ConsultarRedeStoreActionController =
      ActionController(name: '_ConsultarRedeStore');

  @override
  void setTermoDeBusca(String value) {
    final _$actionInfo = _$_ConsultarRedeStoreActionController.startAction(
        name: '_ConsultarRedeStore.setTermoDeBusca');
    try {
      return super.setTermoDeBusca(value);
    } finally {
      _$_ConsultarRedeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setListaDeRedeiros(List<RedeDmo> value) {
    final _$actionInfo = _$_ConsultarRedeStoreActionController.startAction(
        name: '_ConsultarRedeStore.setListaDeRedeiros');
    try {
      return super.setListaDeRedeiros(value);
    } finally {
      _$_ConsultarRedeStoreActionController.endAction(_$actionInfo);
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
