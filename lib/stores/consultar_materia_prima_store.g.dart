// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultar_materia_prima_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConsultarMateriaPrimaStore on _ConsultarMateriaPrimaStore, Store {
  final _$processandoAtom =
      Atom(name: '_ConsultarMateriaPrimaStore.processando');

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

  final _$termoDeBuscaAtom =
      Atom(name: '_ConsultarMateriaPrimaStore.termoDeBusca');

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
      Atom(name: '_ConsultarMateriaPrimaStore.temMaisRegistros');

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

  final _$erroAtom = Atom(name: '_ConsultarMateriaPrimaStore.erro');

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

  final _$obterListaDeMateriaPrimaPaginadaAsyncAction = AsyncAction(
      '_ConsultarMateriaPrimaStore.obterListaDeMateriaPrimaPaginada');

  @override
  Future<void> obterListaDeMateriaPrimaPaginada(
      bool limpaLista, String? filtroPorNome) {
    return _$obterListaDeMateriaPrimaPaginadaAsyncAction.run(() =>
        super.obterListaDeMateriaPrimaPaginada(limpaLista, filtroPorNome));
  }

  final _$obterListaDeRedePaginadaComFiltroAsyncAction = AsyncAction(
      '_ConsultarMateriaPrimaStore.obterListaDeRedePaginadaComFiltro');

  @override
  Future<void> obterListaDeRedePaginadaComFiltro(String filtroNome) {
    return _$obterListaDeRedePaginadaComFiltroAsyncAction
        .run(() => super.obterListaDeRedePaginadaComFiltro(filtroNome));
  }

  final _$_ConsultarMateriaPrimaStoreActionController =
      ActionController(name: '_ConsultarMateriaPrimaStore');

  @override
  void setTermoDeBusca(String value) {
    final _$actionInfo = _$_ConsultarMateriaPrimaStoreActionController
        .startAction(name: '_ConsultarMateriaPrimaStore.setTermoDeBusca');
    try {
      return super.setTermoDeBusca(value);
    } finally {
      _$_ConsultarMateriaPrimaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setListaDeRedeiros(List<MateriaPrimaDmo> value) {
    final _$actionInfo = _$_ConsultarMateriaPrimaStoreActionController
        .startAction(name: '_ConsultarMateriaPrimaStore.setListaDeRedeiros');
    try {
      return super.setListaDeRedeiros(value);
    } finally {
      _$_ConsultarMateriaPrimaStoreActionController.endAction(_$actionInfo);
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
