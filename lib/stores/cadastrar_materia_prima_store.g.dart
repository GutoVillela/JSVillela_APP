// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastrar_materia_prima_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastrarMateriaPrimaStore on _CadastrarMateriaPrimaStore, Store {
  Computed<bool>? _$habilitaBotaoDeCadastroComputed;

  @override
  bool get habilitaBotaoDeCadastro => (_$habilitaBotaoDeCadastroComputed ??=
          Computed<bool>(() => super.habilitaBotaoDeCadastro,
              name: '_CadastrarMateriaPrimaStore.habilitaBotaoDeCadastro'))
      .value;

  final _$processandoAtom =
      Atom(name: '_CadastrarMateriaPrimaStore.processando');

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

  final _$nomeMateriaPrimaAtom =
      Atom(name: '_CadastrarMateriaPrimaStore.nomeMateriaPrima');

  @override
  String get nomeMateriaPrima {
    _$nomeMateriaPrimaAtom.reportRead();
    return super.nomeMateriaPrima;
  }

  @override
  set nomeMateriaPrima(String value) {
    _$nomeMateriaPrimaAtom.reportWrite(value, super.nomeMateriaPrima, () {
      super.nomeMateriaPrima = value;
    });
  }

  final _$iconeMateriaPrimaAtom =
      Atom(name: '_CadastrarMateriaPrimaStore.iconeMateriaPrima');

  @override
  String get iconeMateriaPrima {
    _$iconeMateriaPrimaAtom.reportRead();
    return super.iconeMateriaPrima;
  }

  @override
  set iconeMateriaPrima(String value) {
    _$iconeMateriaPrimaAtom.reportWrite(value, super.iconeMateriaPrima, () {
      super.iconeMateriaPrima = value;
    });
  }

  final _$cadastrarOuEditarMateriaPrimaAsyncAction =
      AsyncAction('_CadastrarMateriaPrimaStore.cadastrarOuEditarMateriaPrima');

  @override
  Future<MateriaPrimaDmo?> cadastrarOuEditarMateriaPrima() {
    return _$cadastrarOuEditarMateriaPrimaAsyncAction
        .run(() => super.cadastrarOuEditarMateriaPrima());
  }

  final _$_CadastrarMateriaPrimaStoreActionController =
      ActionController(name: '_CadastrarMateriaPrimaStore');

  @override
  void setNomeMateriaPrima(String value) {
    final _$actionInfo = _$_CadastrarMateriaPrimaStoreActionController
        .startAction(name: '_CadastrarMateriaPrimaStore.setNomeMateriaPrima');
    try {
      return super.setNomeMateriaPrima(value);
    } finally {
      _$_CadastrarMateriaPrimaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIconeMateriaPrima(String value) {
    final _$actionInfo = _$_CadastrarMateriaPrimaStoreActionController
        .startAction(name: '_CadastrarMateriaPrimaStore.setIconeMateriaPrima');
    try {
      return super.setIconeMateriaPrima(value);
    } finally {
      _$_CadastrarMateriaPrimaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processando: ${processando},
nomeMateriaPrima: ${nomeMateriaPrima},
iconeMateriaPrima: ${iconeMateriaPrima},
habilitaBotaoDeCadastro: ${habilitaBotaoDeCadastro}
    ''';
  }
}
