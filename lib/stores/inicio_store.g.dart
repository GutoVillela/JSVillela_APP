// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inicio_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$InicioStore on _InicioStore, Store {
  Computed<bool>? _$existeRecolhimentoDoDiaComputed;

  @override
  bool get existeRecolhimentoDoDia => (_$existeRecolhimentoDoDiaComputed ??=
          Computed<bool>(() => super.existeRecolhimentoDoDia,
              name: '_InicioStore.existeRecolhimentoDoDia'))
      .value;
  Computed<bool>? _$recolhimentoEmAndamentoComputed;

  @override
  bool get recolhimentoEmAndamento => (_$recolhimentoEmAndamentoComputed ??=
          Computed<bool>(() => super.recolhimentoEmAndamento,
              name: '_InicioStore.recolhimentoEmAndamento'))
      .value;
  Computed<bool>? _$recolhimentoDoDiaFinalizadoComputed;

  @override
  bool get recolhimentoDoDiaFinalizado =>
      (_$recolhimentoDoDiaFinalizadoComputed ??= Computed<bool>(
              () => super.recolhimentoDoDiaFinalizado,
              name: '_InicioStore.recolhimentoDoDiaFinalizado'))
          .value;
  Computed<bool>? _$habilitaBotaoIniciaRecolhimentoComputed;

  @override
  bool get habilitaBotaoIniciaRecolhimento =>
      (_$habilitaBotaoIniciaRecolhimentoComputed ??= Computed<bool>(
              () => super.habilitaBotaoIniciaRecolhimento,
              name: '_InicioStore.habilitaBotaoIniciaRecolhimento'))
          .value;

  final _$carregandoRecolhimentoDoDiaAtom =
      Atom(name: '_InicioStore.carregandoRecolhimentoDoDia');

  @override
  bool get carregandoRecolhimentoDoDia {
    _$carregandoRecolhimentoDoDiaAtom.reportRead();
    return super.carregandoRecolhimentoDoDia;
  }

  @override
  set carregandoRecolhimentoDoDia(bool value) {
    _$carregandoRecolhimentoDoDiaAtom
        .reportWrite(value, super.carregandoRecolhimentoDoDia, () {
      super.carregandoRecolhimentoDoDia = value;
    });
  }

  final _$carregandoSolicitacoesAtom =
      Atom(name: '_InicioStore.carregandoSolicitacoes');

  @override
  bool get carregandoSolicitacoes {
    _$carregandoSolicitacoesAtom.reportRead();
    return super.carregandoSolicitacoes;
  }

  @override
  set carregandoSolicitacoes(bool value) {
    _$carregandoSolicitacoesAtom
        .reportWrite(value, super.carregandoSolicitacoes, () {
      super.carregandoSolicitacoes = value;
    });
  }

  final _$iniciandoRecolhimentoAtom =
      Atom(name: '_InicioStore.iniciandoRecolhimento');

  @override
  bool get iniciandoRecolhimento {
    _$iniciandoRecolhimentoAtom.reportRead();
    return super.iniciandoRecolhimento;
  }

  @override
  set iniciandoRecolhimento(bool value) {
    _$iniciandoRecolhimentoAtom.reportWrite(value, super.iniciandoRecolhimento,
        () {
      super.iniciandoRecolhimento = value;
    });
  }

  final _$recolhimentoDoDiaAtom = Atom(name: '_InicioStore.recolhimentoDoDia');

  @override
  RecolhimentoDmo? get recolhimentoDoDia {
    _$recolhimentoDoDiaAtom.reportRead();
    return super.recolhimentoDoDia;
  }

  @override
  set recolhimentoDoDia(RecolhimentoDmo? value) {
    _$recolhimentoDoDiaAtom.reportWrite(value, super.recolhimentoDoDia, () {
      super.recolhimentoDoDia = value;
    });
  }

  final _$carregarRecolhimentoDoDiaAsyncAction =
      AsyncAction('_InicioStore.carregarRecolhimentoDoDia');

  @override
  Future<void> carregarRecolhimentoDoDia() {
    return _$carregarRecolhimentoDoDiaAsyncAction
        .run(() => super.carregarRecolhimentoDoDia());
  }

  final _$carregarSolicitacoesAsyncAction =
      AsyncAction('_InicioStore.carregarSolicitacoes');

  @override
  Future<void> carregarSolicitacoes() {
    return _$carregarSolicitacoesAsyncAction
        .run(() => super.carregarSolicitacoes());
  }

  final _$iniciarRecolhimentoDoDiaAsyncAction =
      AsyncAction('_InicioStore.iniciarRecolhimentoDoDia');

  @override
  Future<void> iniciarRecolhimentoDoDia() {
    return _$iniciarRecolhimentoDoDiaAsyncAction
        .run(() => super.iniciarRecolhimentoDoDia());
  }

  final _$terminarRecolhimentoDoDiaAsyncAction =
      AsyncAction('_InicioStore.terminarRecolhimentoDoDia');

  @override
  Future<void> terminarRecolhimentoDoDia() {
    return _$terminarRecolhimentoDoDiaAsyncAction
        .run(() => super.terminarRecolhimentoDoDia());
  }

  final _$_InicioStoreActionController = ActionController(name: '_InicioStore');

  @override
  void setCidadesDoRecolhimento(List<String> value) {
    final _$actionInfo = _$_InicioStoreActionController.startAction(
        name: '_InicioStore.setCidadesDoRecolhimento');
    try {
      return super.setCidadesDoRecolhimento(value);
    } finally {
      _$_InicioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void verificarSeRecolhimentoFoiFinalizado() {
    final _$actionInfo = _$_InicioStoreActionController.startAction(
        name: '_InicioStore.verificarSeRecolhimentoFoiFinalizado');
    try {
      return super.verificarSeRecolhimentoFoiFinalizado();
    } finally {
      _$_InicioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
carregandoRecolhimentoDoDia: ${carregandoRecolhimentoDoDia},
carregandoSolicitacoes: ${carregandoSolicitacoes},
iniciandoRecolhimento: ${iniciandoRecolhimento},
recolhimentoDoDia: ${recolhimentoDoDia},
existeRecolhimentoDoDia: ${existeRecolhimentoDoDia},
recolhimentoEmAndamento: ${recolhimentoEmAndamento},
recolhimentoDoDiaFinalizado: ${recolhimentoDoDiaFinalizado},
habilitaBotaoIniciaRecolhimento: ${habilitaBotaoIniciaRecolhimento}
    ''';
  }
}
