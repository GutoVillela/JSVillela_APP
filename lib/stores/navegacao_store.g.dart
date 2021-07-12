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

  final _$notificacoesAtom = Atom(name: '_NavegacaoStore.notificacoes');

  @override
  int get notificacoes {
    _$notificacoesAtom.reportRead();
    return super.notificacoes;
  }

  @override
  set notificacoes(int value) {
    _$notificacoesAtom.reportWrite(value, super.notificacoes, () {
      super.notificacoes = value;
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
  void setNotificacoes(int value) {
    final _$actionInfo = _$_NavegacaoStoreActionController.startAction(
        name: '_NavegacaoStore.setNotificacoes');
    try {
      return super.setNotificacoes(value);
    } finally {
      _$_NavegacaoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void incrementarNotificacao() {
    final _$actionInfo = _$_NavegacaoStoreActionController.startAction(
        name: '_NavegacaoStore.incrementarNotificacao');
    try {
      return super.incrementarNotificacao();
    } finally {
      _$_NavegacaoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
paginaAtual: ${paginaAtual},
notificacoes: ${notificacoes}
    ''';
  }
}
