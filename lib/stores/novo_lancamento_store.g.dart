// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novo_lancamento_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NovoLancamentoStore on _NovoLancamentoStore, Store {
  Computed<bool>? _$habilitaBotaoDeCadastroComputed;

  @override
  bool get habilitaBotaoDeCadastro => (_$habilitaBotaoDeCadastroComputed ??=
          Computed<bool>(() => super.habilitaBotaoDeCadastro,
              name: '_NovoLancamentoStore.habilitaBotaoDeCadastro'))
      .value;

  final _$processandoAtom = Atom(name: '_NovoLancamentoStore.processando');

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

  final _$buscandoRedesAtom = Atom(name: '_NovoLancamentoStore.buscandoRedes');

  @override
  bool get buscandoRedes {
    _$buscandoRedesAtom.reportRead();
    return super.buscandoRedes;
  }

  @override
  set buscandoRedes(bool value) {
    _$buscandoRedesAtom.reportWrite(value, super.buscandoRedes, () {
      super.buscandoRedes = value;
    });
  }

  final _$redeAtom = Atom(name: '_NovoLancamentoStore.rede');

  @override
  RedeDmo? get rede {
    _$redeAtom.reportRead();
    return super.rede;
  }

  @override
  set rede(RedeDmo? value) {
    _$redeAtom.reportWrite(value, super.rede, () {
      super.rede = value;
    });
  }

  final _$quantidadeAtom = Atom(name: '_NovoLancamentoStore.quantidade');

  @override
  int get quantidade {
    _$quantidadeAtom.reportRead();
    return super.quantidade;
  }

  @override
  set quantidade(int value) {
    _$quantidadeAtom.reportWrite(value, super.quantidade, () {
      super.quantidade = value;
    });
  }

  final _$valorUnitarioRedeAtom =
      Atom(name: '_NovoLancamentoStore.valorUnitarioRede');

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

  final _$carregarRedesAsyncAction =
      AsyncAction('_NovoLancamentoStore.carregarRedes');

  @override
  Future<void> carregarRedes() {
    return _$carregarRedesAsyncAction.run(() => super.carregarRedes());
  }

  final _$cadastrarLancamentoAsyncAction =
      AsyncAction('_NovoLancamentoStore.cadastrarLancamento');

  @override
  Future<LancamentoDoCadernoDmo?> cadastrarLancamento() {
    return _$cadastrarLancamentoAsyncAction
        .run(() => super.cadastrarLancamento());
  }

  final _$_NovoLancamentoStoreActionController =
      ActionController(name: '_NovoLancamentoStore');

  @override
  void setRede(String? value) {
    final _$actionInfo = _$_NovoLancamentoStoreActionController.startAction(
        name: '_NovoLancamentoStore.setRede');
    try {
      return super.setRede(value);
    } finally {
      _$_NovoLancamentoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setValorUnitarioRede(String value) {
    final _$actionInfo = _$_NovoLancamentoStoreActionController.startAction(
        name: '_NovoLancamentoStore.setValorUnitarioRede');
    try {
      return super.setValorUnitarioRede(value);
    } finally {
      _$_NovoLancamentoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setQuantidade(String value) {
    final _$actionInfo = _$_NovoLancamentoStoreActionController.startAction(
        name: '_NovoLancamentoStore.setQuantidade');
    try {
      return super.setQuantidade(value);
    } finally {
      _$_NovoLancamentoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRedes(List<RedeDmo> value) {
    final _$actionInfo = _$_NovoLancamentoStoreActionController.startAction(
        name: '_NovoLancamentoStore.setRedes');
    try {
      return super.setRedes(value);
    } finally {
      _$_NovoLancamentoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processando: ${processando},
buscandoRedes: ${buscandoRedes},
rede: ${rede},
quantidade: ${quantidade},
valorUnitarioRede: ${valorUnitarioRede},
habilitaBotaoDeCadastro: ${habilitaBotaoDeCadastro}
    ''';
  }
}
