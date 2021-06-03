// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caderno_do_redeiro_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadernoDoRedeiroStore on _CadernoDoRedeiroStore, Store {
  Computed<bool>? _$habilitaBotaoDeCadastroComputed;

  @override
  bool get habilitaBotaoDeCadastro => (_$habilitaBotaoDeCadastroComputed ??=
          Computed<bool>(() => super.habilitaBotaoDeCadastro,
              name: '_CadernoDoRedeiroStore.habilitaBotaoDeCadastro'))
      .value;

  final _$processandoAtom = Atom(name: '_CadernoDoRedeiroStore.processando');

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

  final _$carregarCadernoDoRedeiroAsyncAction =
      AsyncAction('_CadernoDoRedeiroStore.carregarCadernoDoRedeiro');

  @override
  Future<void> carregarCadernoDoRedeiro() {
    return _$carregarCadernoDoRedeiroAsyncAction
        .run(() => super.carregarCadernoDoRedeiro());
  }

  final _$_CadernoDoRedeiroStoreActionController =
      ActionController(name: '_CadernoDoRedeiroStore');

  @override
  void setCaderno(List<List<LancamentoDoCadernoDmo>> value) {
    final _$actionInfo = _$_CadernoDoRedeiroStoreActionController.startAction(
        name: '_CadernoDoRedeiroStore.setCaderno');
    try {
      return super.setCaderno(value);
    } finally {
      _$_CadernoDoRedeiroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processando: ${processando},
habilitaBotaoDeCadastro: ${habilitaBotaoDeCadastro}
    ''';
  }
}
