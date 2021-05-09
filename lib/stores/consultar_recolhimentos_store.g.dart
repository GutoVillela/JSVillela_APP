// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultar_recolhimentos_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConsultarRecolhimentosStore on _ConsultarRecolhimentosStore, Store {
  Computed<String>? _$textoFiltroDataInicialComputed;

  @override
  String get textoFiltroDataInicial => (_$textoFiltroDataInicialComputed ??=
          Computed<String>(() => super.textoFiltroDataInicial,
              name: '_ConsultarRecolhimentosStore.textoFiltroDataInicial'))
      .value;
  Computed<String>? _$textoFiltroDataFinalComputed;

  @override
  String get textoFiltroDataFinal => (_$textoFiltroDataFinalComputed ??=
          Computed<String>(() => super.textoFiltroDataFinal,
              name: '_ConsultarRecolhimentosStore.textoFiltroDataFinal'))
      .value;

  final _$processandoAtom =
      Atom(name: '_ConsultarRecolhimentosStore.processando');

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

  final _$filtroDataInicialAtom =
      Atom(name: '_ConsultarRecolhimentosStore.filtroDataInicial');

  @override
  DateTime? get filtroDataInicial {
    _$filtroDataInicialAtom.reportRead();
    return super.filtroDataInicial;
  }

  @override
  set filtroDataInicial(DateTime? value) {
    _$filtroDataInicialAtom.reportWrite(value, super.filtroDataInicial, () {
      super.filtroDataInicial = value;
    });
  }

  final _$filtroDataFinalAtom =
      Atom(name: '_ConsultarRecolhimentosStore.filtroDataFinal');

  @override
  DateTime? get filtroDataFinal {
    _$filtroDataFinalAtom.reportRead();
    return super.filtroDataFinal;
  }

  @override
  set filtroDataFinal(DateTime? value) {
    _$filtroDataFinalAtom.reportWrite(value, super.filtroDataFinal, () {
      super.filtroDataFinal = value;
    });
  }

  final _$incluirRecolhimentosFinalizadosAtom = Atom(
      name: '_ConsultarRecolhimentosStore.incluirRecolhimentosFinalizados');

  @override
  bool get incluirRecolhimentosFinalizados {
    _$incluirRecolhimentosFinalizadosAtom.reportRead();
    return super.incluirRecolhimentosFinalizados;
  }

  @override
  set incluirRecolhimentosFinalizados(bool value) {
    _$incluirRecolhimentosFinalizadosAtom
        .reportWrite(value, super.incluirRecolhimentosFinalizados, () {
      super.incluirRecolhimentosFinalizados = value;
    });
  }

  final _$temMaisRegistrosAtom =
      Atom(name: '_ConsultarRecolhimentosStore.temMaisRegistros');

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

  final _$erroAtom = Atom(name: '_ConsultarRecolhimentosStore.erro');

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

  final _$obterListaPaginadaDeRecolhimentosAsyncAction = AsyncAction(
      '_ConsultarRecolhimentosStore.obterListaPaginadaDeRecolhimentos');

  @override
  Future<void> obterListaPaginadaDeRecolhimentos(bool limpaLista) {
    return _$obterListaPaginadaDeRecolhimentosAsyncAction
        .run(() => super.obterListaPaginadaDeRecolhimentos(limpaLista));
  }

  final _$apagarRecolhimentoAsyncAction =
      AsyncAction('_ConsultarRecolhimentosStore.apagarRecolhimento');

  @override
  Future<void> apagarRecolhimento(String idRecolhimento) {
    return _$apagarRecolhimentoAsyncAction
        .run(() => super.apagarRecolhimento(idRecolhimento));
  }

  final _$buscarGruposDoRecolhimentoAsyncAction =
      AsyncAction('_ConsultarRecolhimentosStore.buscarGruposDoRecolhimento');

  @override
  Future<List<GrupoDeRedeirosDmo>> buscarGruposDoRecolhimento(
      String idRecolhimento) {
    return _$buscarGruposDoRecolhimentoAsyncAction
        .run(() => super.buscarGruposDoRecolhimento(idRecolhimento));
  }

  final _$_ConsultarRecolhimentosStoreActionController =
      ActionController(name: '_ConsultarRecolhimentosStore');

  @override
  void setFiltroDataInicial(DateTime? value) {
    final _$actionInfo = _$_ConsultarRecolhimentosStoreActionController
        .startAction(name: '_ConsultarRecolhimentosStore.setFiltroDataInicial');
    try {
      return super.setFiltroDataInicial(value);
    } finally {
      _$_ConsultarRecolhimentosStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFiltroDataFinal(DateTime? value) {
    final _$actionInfo = _$_ConsultarRecolhimentosStoreActionController
        .startAction(name: '_ConsultarRecolhimentosStore.setFiltroDataFinal');
    try {
      return super.setFiltroDataFinal(value);
    } finally {
      _$_ConsultarRecolhimentosStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIncluirRecolhimentosFinalizados(bool? value) {
    final _$actionInfo =
        _$_ConsultarRecolhimentosStoreActionController.startAction(
            name:
                '_ConsultarRecolhimentosStore.setIncluirRecolhimentosFinalizados');
    try {
      return super.setIncluirRecolhimentosFinalizados(value);
    } finally {
      _$_ConsultarRecolhimentosStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processando: ${processando},
filtroDataInicial: ${filtroDataInicial},
filtroDataFinal: ${filtroDataFinal},
incluirRecolhimentosFinalizados: ${incluirRecolhimentosFinalizados},
temMaisRegistros: ${temMaisRegistros},
erro: ${erro},
textoFiltroDataInicial: ${textoFiltroDataInicial},
textoFiltroDataFinal: ${textoFiltroDataFinal}
    ''';
  }
}
