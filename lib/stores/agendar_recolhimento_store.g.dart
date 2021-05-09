// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agendar_recolhimento_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AgendarRecolhimentoStore on _AgendarRecolhimentoStore, Store {
  Computed<String>? _$textoDataRecolhimentoComputed;

  @override
  String get textoDataRecolhimento => (_$textoDataRecolhimentoComputed ??=
          Computed<String>(() => super.textoDataRecolhimento,
              name: '_AgendarRecolhimentoStore.textoDataRecolhimento'))
      .value;
  Computed<String>? _$textoGruposDoRecolhimentoComputed;

  @override
  String get textoGruposDoRecolhimento =>
      (_$textoGruposDoRecolhimentoComputed ??= Computed<String>(
              () => super.textoGruposDoRecolhimento,
              name: '_AgendarRecolhimentoStore.textoGruposDoRecolhimento'))
          .value;
  Computed<bool>? _$habilitaBotaoDeCadastroComputed;

  @override
  bool get habilitaBotaoDeCadastro => (_$habilitaBotaoDeCadastroComputed ??=
          Computed<bool>(() => super.habilitaBotaoDeCadastro,
              name: '_AgendarRecolhimentoStore.habilitaBotaoDeCadastro'))
      .value;

  final _$processandoAtom = Atom(name: '_AgendarRecolhimentoStore.processando');

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

  final _$dataDoRecolhimentoAtom =
      Atom(name: '_AgendarRecolhimentoStore.dataDoRecolhimento');

  @override
  DateTime? get dataDoRecolhimento {
    _$dataDoRecolhimentoAtom.reportRead();
    return super.dataDoRecolhimento;
  }

  @override
  set dataDoRecolhimento(DateTime? value) {
    _$dataDoRecolhimentoAtom.reportWrite(value, super.dataDoRecolhimento, () {
      super.dataDoRecolhimento = value;
    });
  }

  final _$validandoDataAtom =
      Atom(name: '_AgendarRecolhimentoStore.validandoData');

  @override
  bool get validandoData {
    _$validandoDataAtom.reportRead();
    return super.validandoData;
  }

  @override
  set validandoData(bool value) {
    _$validandoDataAtom.reportWrite(value, super.validandoData, () {
      super.validandoData = value;
    });
  }

  final _$validandoGruposAtom =
      Atom(name: '_AgendarRecolhimentoStore.validandoGrupos');

  @override
  bool get validandoGrupos {
    _$validandoGruposAtom.reportRead();
    return super.validandoGrupos;
  }

  @override
  set validandoGrupos(bool value) {
    _$validandoGruposAtom.reportWrite(value, super.validandoGrupos, () {
      super.validandoGrupos = value;
    });
  }

  final _$setDataDoRecolhimentoAsyncAction =
      AsyncAction('_AgendarRecolhimentoStore.setDataDoRecolhimento');

  @override
  Future<void> setDataDoRecolhimento(DateTime? value) {
    return _$setDataDoRecolhimentoAsyncAction
        .run(() => super.setDataDoRecolhimento(value));
  }

  final _$setGruposDeRedeirosAsyncAction =
      AsyncAction('_AgendarRecolhimentoStore.setGruposDeRedeiros');

  @override
  Future<void> setGruposDeRedeiros(List<GrupoDeRedeirosDmo> value) {
    return _$setGruposDeRedeirosAsyncAction
        .run(() => super.setGruposDeRedeiros(value));
  }

  final _$validarDataAsyncAction =
      AsyncAction('_AgendarRecolhimentoStore.validarData');

  @override
  Future<bool> validarData(DateTime? value) {
    return _$validarDataAsyncAction.run(() => super.validarData(value));
  }

  final _$validarGruposAsyncAction =
      AsyncAction('_AgendarRecolhimentoStore.validarGrupos');

  @override
  Future<bool> validarGrupos(List<GrupoDeRedeirosDmo> grupos) {
    return _$validarGruposAsyncAction.run(() => super.validarGrupos(grupos));
  }

  final _$cadastrarOuEditarRecolhimentoAsyncAction =
      AsyncAction('_AgendarRecolhimentoStore.cadastrarOuEditarRecolhimento');

  @override
  Future<RecolhimentoDmo?> cadastrarOuEditarRecolhimento() {
    return _$cadastrarOuEditarRecolhimentoAsyncAction
        .run(() => super.cadastrarOuEditarRecolhimento());
  }

  @override
  String toString() {
    return '''
processando: ${processando},
dataDoRecolhimento: ${dataDoRecolhimento},
validandoData: ${validandoData},
validandoGrupos: ${validandoGrupos},
textoDataRecolhimento: ${textoDataRecolhimento},
textoGruposDoRecolhimento: ${textoGruposDoRecolhimento},
habilitaBotaoDeCadastro: ${habilitaBotaoDeCadastro}
    ''';
  }
}
