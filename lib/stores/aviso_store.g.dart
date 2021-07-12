// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aviso_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AvisoStore on _AvisoStore, Store {
  final _$processandoAtom = Atom(name: '_AvisoStore.processando');

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

  final _$carregarAvisosAsyncAction = AsyncAction('_AvisoStore.carregarAvisos');

  @override
  Future<void> carregarAvisos() {
    return _$carregarAvisosAsyncAction.run(() => super.carregarAvisos());
  }

  final _$descartarAvisoDoUsuarioAsyncAction =
      AsyncAction('_AvisoStore.descartarAvisoDoUsuario');

  @override
  Future<void> descartarAvisoDoUsuario(String idAvisoDoUsuario) {
    return _$descartarAvisoDoUsuarioAsyncAction
        .run(() => super.descartarAvisoDoUsuario(idAvisoDoUsuario));
  }

  final _$_AvisoStoreActionController = ActionController(name: '_AvisoStore');

  @override
  void setAvisos(List<AvisoDoUsuarioDmo> value) {
    final _$actionInfo = _$_AvisoStoreActionController.startAction(
        name: '_AvisoStore.setAvisos');
    try {
      return super.setAvisos(value);
    } finally {
      _$_AvisoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processando: ${processando}
    ''';
  }
}
