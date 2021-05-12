// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastrar_rede_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastrarRedeStore on _CadastrarRedeStore, Store {
  Computed<bool>? _$habilitaBotaoDeCadastroComputed;

  @override
  bool get habilitaBotaoDeCadastro => (_$habilitaBotaoDeCadastroComputed ??=
          Computed<bool>(() => super.habilitaBotaoDeCadastro,
              name: '_CadastrarRedeStore.habilitaBotaoDeCadastro'))
      .value;

  final _$processandoAtom = Atom(name: '_CadastrarRedeStore.processando');

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

  final _$nomeRedeAtom = Atom(name: '_CadastrarRedeStore.nomeRede');

  @override
  String get nomeRede {
    _$nomeRedeAtom.reportRead();
    return super.nomeRede;
  }

  @override
  set nomeRede(String value) {
    _$nomeRedeAtom.reportWrite(value, super.nomeRede, () {
      super.nomeRede = value;
    });
  }

  final _$valorUnitarioRedeAtom =
      Atom(name: '_CadastrarRedeStore.valorUnitarioRede');

  @override
  double get valorUnitarioRede {
    _$valorUnitarioRedeAtom.reportRead();
    return super.valorUnitarioRede;
  }

  @override
  set valorUnitarioRede(double value) {
    _$valorUnitarioRedeAtom.reportWrite(value, super.valorUnitarioRede, () {
      super.valorUnitarioRede = value;
    });
  }

  final _$cadastrarOuEditarRedeAsyncAction =
      AsyncAction('_CadastrarRedeStore.cadastrarOuEditarRede');

  @override
  Future<RedeDmo?> cadastrarOuEditarRede() {
    return _$cadastrarOuEditarRedeAsyncAction
        .run(() => super.cadastrarOuEditarRede());
  }

  final _$_CadastrarRedeStoreActionController =
      ActionController(name: '_CadastrarRedeStore');

  @override
  void setNomeRede(String value) {
    final _$actionInfo = _$_CadastrarRedeStoreActionController.startAction(
        name: '_CadastrarRedeStore.setNomeRede');
    try {
      return super.setNomeRede(value);
    } finally {
      _$_CadastrarRedeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setValorUnitarioRede(double value) {
    final _$actionInfo = _$_CadastrarRedeStoreActionController.startAction(
        name: '_CadastrarRedeStore.setValorUnitarioRede');
    try {
      return super.setValorUnitarioRede(value);
    } finally {
      _$_CadastrarRedeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processando: ${processando},
nomeRede: ${nomeRede},
valorUnitarioRede: ${valorUnitarioRede},
habilitaBotaoDeCadastro: ${habilitaBotaoDeCadastro}
    ''';
  }
}
