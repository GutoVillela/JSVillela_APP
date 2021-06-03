// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabela_de_lancamentos_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TabelaDeLancamentosStore on _TabelaDeLancamentosStore, Store {
  Computed<bool>? _$pagoComputed;

  @override
  bool get pago => (_$pagoComputed ??= Computed<bool>(() => super.pago,
          name: '_TabelaDeLancamentosStore.pago'))
      .value;
  Computed<bool>? _$confirmadoComputed;

  @override
  bool get confirmado =>
      (_$confirmadoComputed ??= Computed<bool>(() => super.confirmado,
              name: '_TabelaDeLancamentosStore.confirmado'))
          .value;
  Computed<double>? _$totalComputed;

  @override
  double get total => (_$totalComputed ??= Computed<double>(() => super.total,
          name: '_TabelaDeLancamentosStore.total'))
      .value;
  Computed<bool>? _$habilitaBotaoDeCadastroComputed;

  @override
  bool get habilitaBotaoDeCadastro => (_$habilitaBotaoDeCadastroComputed ??=
          Computed<bool>(() => super.habilitaBotaoDeCadastro,
              name: '_TabelaDeLancamentosStore.habilitaBotaoDeCadastro'))
      .value;

  final _$processandoAtom = Atom(name: '_TabelaDeLancamentosStore.processando');

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

  final _$processarPagamentoAsyncAction =
      AsyncAction('_TabelaDeLancamentosStore.processarPagamento');

  @override
  Future<void> processarPagamento() {
    return _$processarPagamentoAsyncAction
        .run(() => super.processarPagamento());
  }

  final _$_TabelaDeLancamentosStoreActionController =
      ActionController(name: '_TabelaDeLancamentosStore');

  @override
  void setListaDeLancamentos(List<LancamentoDoCadernoDmo> value) {
    final _$actionInfo = _$_TabelaDeLancamentosStoreActionController
        .startAction(name: '_TabelaDeLancamentosStore.setListaDeLancamentos');
    try {
      return super.setListaDeLancamentos(value);
    } finally {
      _$_TabelaDeLancamentosStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processando: ${processando},
pago: ${pago},
confirmado: ${confirmado},
total: ${total},
habilitaBotaoDeCadastro: ${habilitaBotaoDeCadastro}
    ''';
  }
}
