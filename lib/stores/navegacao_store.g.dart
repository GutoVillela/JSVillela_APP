// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navegacao_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NavegacaoStore on _NavegacaoStore, Store {
  final _$paginaAtualAtom = Atom(name: '_NavegacaoStore.paginaAtual');

  @override
  int get paginaAtual {
    _$paginaAtualAtom.reportRead();
    return super.paginaAtual;
  }

  @override
  set paginaAtual(int value) {
    _$paginaAtualAtom.reportWrite(value, super.paginaAtual, () {
      super.paginaAtual = value;
    });
  }

  final _$_NavegacaoStoreActionController =
      ActionController(name: '_NavegacaoStore');

  @override
  void setPaginaAtual(int value) {
    final _$actionInfo = _$_NavegacaoStoreActionController.startAction(
        name: '_NavegacaoStore.setPaginaAtual');
    try {
      return super.setPaginaAtual(value);
    } finally {
      _$_NavegacaoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
paginaAtual: ${paginaAtual}
    ''';
  }
}
