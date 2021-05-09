// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultar_grupos_de_redeiros_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConsultarGruposDeRedeirosStore
    on _ConsultarGruposDeRedeirosStore, Store {
  final _$processandoAtom =
      Atom(name: '_ConsultarGruposDeRedeirosStore.processando');

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
      Atom(name: '_ConsultarGruposDeRedeirosStore.termoDeBusca');

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
      Atom(name: '_ConsultarGruposDeRedeirosStore.temMaisRegistros');

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

  final _$erroAtom = Atom(name: '_ConsultarGruposDeRedeirosStore.erro');

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

  final _$obterListaDeGruposPaginadasAsyncAction = AsyncAction(
      '_ConsultarGruposDeRedeirosStore.obterListaDeGruposPaginadas');

  @override
  Future<void> obterListaDeGruposPaginadas(
      bool limpaLista, String? filtroPorNome) {
    return _$obterListaDeGruposPaginadasAsyncAction.run(
        () => super.obterListaDeGruposPaginadas(limpaLista, filtroPorNome));
  }

  final _$obterListaDeGruposPaginadasComFiltroAsyncAction = AsyncAction(
      '_ConsultarGruposDeRedeirosStore.obterListaDeGruposPaginadasComFiltro');

  @override
  Future<void> obterListaDeGruposPaginadasComFiltro(String filtroNome) {
    return _$obterListaDeGruposPaginadasComFiltroAsyncAction
        .run(() => super.obterListaDeGruposPaginadasComFiltro(filtroNome));
  }

  final _$apagarGrupoDeRedeirosAsyncAction =
      AsyncAction('_ConsultarGruposDeRedeirosStore.apagarGrupoDeRedeiros');

  @override
  Future<void> apagarGrupoDeRedeiros(String idGrupo) {
    return _$apagarGrupoDeRedeirosAsyncAction
        .run(() => super.apagarGrupoDeRedeiros(idGrupo));
  }

  final _$_ConsultarGruposDeRedeirosStoreActionController =
      ActionController(name: '_ConsultarGruposDeRedeirosStore');

  @override
  void setTermoDeBusca(String value) {
    final _$actionInfo = _$_ConsultarGruposDeRedeirosStoreActionController
        .startAction(name: '_ConsultarGruposDeRedeirosStore.setTermoDeBusca');
    try {
      return super.setTermoDeBusca(value);
    } finally {
      _$_ConsultarGruposDeRedeirosStoreActionController.endAction(_$actionInfo);
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
