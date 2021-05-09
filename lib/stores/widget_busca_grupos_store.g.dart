// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_busca_grupos_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WidgetBuscaGruposStore on _WidgetBuscaGruposStore, Store {
  final _$processandoAtom = Atom(name: '_WidgetBuscaGruposStore.processando');

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

  final _$temMaisRegistrosAtom =
      Atom(name: '_WidgetBuscaGruposStore.temMaisRegistros');

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

  final _$erroAtom = Atom(name: '_WidgetBuscaGruposStore.erro');

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

  final _$obterListaDeGruposPaginadosAsyncAction =
      AsyncAction('_WidgetBuscaGruposStore.obterListaDeGruposPaginados');

  @override
  Future<void> obterListaDeGruposPaginados(bool limpaLista) {
    return _$obterListaDeGruposPaginadosAsyncAction
        .run(() => super.obterListaDeGruposPaginados(limpaLista));
  }

  @override
  String toString() {
    return '''
processando: ${processando},
temMaisRegistros: ${temMaisRegistros},
erro: ${erro}
    ''';
  }
}
