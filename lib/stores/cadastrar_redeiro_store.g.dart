// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastrar_redeiro_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastrarRedeiroStore on _CadastrarRedeiroStore, Store {
  Computed<String>? _$textoGruposDoRecolhimentoComputed;

  @override
  String get textoGruposDoRecolhimento =>
      (_$textoGruposDoRecolhimentoComputed ??= Computed<String>(
              () => super.textoGruposDoRecolhimento,
              name: '_CadastrarRedeiroStore.textoGruposDoRecolhimento'))
          .value;
  Computed<bool>? _$habilitaBotaoDeCadastroComputed;

  @override
  bool get habilitaBotaoDeCadastro => (_$habilitaBotaoDeCadastroComputed ??=
          Computed<bool>(() => super.habilitaBotaoDeCadastro,
              name: '_CadastrarRedeiroStore.habilitaBotaoDeCadastro'))
      .value;

  final _$processandoAtom = Atom(name: '_CadastrarRedeiroStore.processando');

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

  final _$nomeRedeiroAtom = Atom(name: '_CadastrarRedeiroStore.nomeRedeiro');

  @override
  String get nomeRedeiro {
    _$nomeRedeiroAtom.reportRead();
    return super.nomeRedeiro;
  }

  @override
  set nomeRedeiro(String value) {
    _$nomeRedeiroAtom.reportWrite(value, super.nomeRedeiro, () {
      super.nomeRedeiro = value;
    });
  }

  final _$emailRedeiroAtom = Atom(name: '_CadastrarRedeiroStore.emailRedeiro');

  @override
  String get emailRedeiro {
    _$emailRedeiroAtom.reportRead();
    return super.emailRedeiro;
  }

  @override
  set emailRedeiro(String value) {
    _$emailRedeiroAtom.reportWrite(value, super.emailRedeiro, () {
      super.emailRedeiro = value;
    });
  }

  final _$celularRedeiroAtom =
      Atom(name: '_CadastrarRedeiroStore.celularRedeiro');

  @override
  String get celularRedeiro {
    _$celularRedeiroAtom.reportRead();
    return super.celularRedeiro;
  }

  @override
  set celularRedeiro(String value) {
    _$celularRedeiroAtom.reportWrite(value, super.celularRedeiro, () {
      super.celularRedeiro = value;
    });
  }

  final _$whatsappAtom = Atom(name: '_CadastrarRedeiroStore.whatsapp');

  @override
  bool get whatsapp {
    _$whatsappAtom.reportRead();
    return super.whatsapp;
  }

  @override
  set whatsapp(bool value) {
    _$whatsappAtom.reportWrite(value, super.whatsapp, () {
      super.whatsapp = value;
    });
  }

  final _$enderecoAtom = Atom(name: '_CadastrarRedeiroStore.endereco');

  @override
  EnderecoDmo get endereco {
    _$enderecoAtom.reportRead();
    return super.endereco;
  }

  @override
  set endereco(EnderecoDmo value) {
    _$enderecoAtom.reportWrite(value, super.endereco, () {
      super.endereco = value;
    });
  }

  final _$complementoAtom = Atom(name: '_CadastrarRedeiroStore.complemento');

  @override
  String get complemento {
    _$complementoAtom.reportRead();
    return super.complemento;
  }

  @override
  set complemento(String value) {
    _$complementoAtom.reportWrite(value, super.complemento, () {
      super.complemento = value;
    });
  }

  final _$carregandoEnderecoAtom =
      Atom(name: '_CadastrarRedeiroStore.carregandoEndereco');

  @override
  bool get carregandoEndereco {
    _$carregandoEnderecoAtom.reportRead();
    return super.carregandoEndereco;
  }

  @override
  set carregandoEndereco(bool value) {
    _$carregandoEnderecoAtom.reportWrite(value, super.carregandoEndereco, () {
      super.carregandoEndereco = value;
    });
  }

  final _$cadastrarOuEditarRedeiroAsyncAction =
      AsyncAction('_CadastrarRedeiroStore.cadastrarOuEditarRedeiro');

  @override
  Future<RedeiroDmo?> cadastrarOuEditarRedeiro() {
    return _$cadastrarOuEditarRedeiroAsyncAction
        .run(() => super.cadastrarOuEditarRedeiro());
  }

  final _$_CadastrarRedeiroStoreActionController =
      ActionController(name: '_CadastrarRedeiroStore');

  @override
  void setNomeRedeiro(String value) {
    final _$actionInfo = _$_CadastrarRedeiroStoreActionController.startAction(
        name: '_CadastrarRedeiroStore.setNomeRedeiro');
    try {
      return super.setNomeRedeiro(value);
    } finally {
      _$_CadastrarRedeiroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmailRedeiro(String value) {
    final _$actionInfo = _$_CadastrarRedeiroStoreActionController.startAction(
        name: '_CadastrarRedeiroStore.setEmailRedeiro');
    try {
      return super.setEmailRedeiro(value);
    } finally {
      _$_CadastrarRedeiroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCelularRedeiro(String value) {
    final _$actionInfo = _$_CadastrarRedeiroStoreActionController.startAction(
        name: '_CadastrarRedeiroStore.setCelularRedeiro');
    try {
      return super.setCelularRedeiro(value);
    } finally {
      _$_CadastrarRedeiroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWhatsapp(bool? value) {
    final _$actionInfo = _$_CadastrarRedeiroStoreActionController.startAction(
        name: '_CadastrarRedeiroStore.setWhatsapp');
    try {
      return super.setWhatsapp(value);
    } finally {
      _$_CadastrarRedeiroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEndereco(EnderecoDmo value) {
    final _$actionInfo = _$_CadastrarRedeiroStoreActionController.startAction(
        name: '_CadastrarRedeiroStore.setEndereco');
    try {
      return super.setEndereco(value);
    } finally {
      _$_CadastrarRedeiroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setComplemento(String value) {
    final _$actionInfo = _$_CadastrarRedeiroStoreActionController.startAction(
        name: '_CadastrarRedeiroStore.setComplemento');
    try {
      return super.setComplemento(value);
    } finally {
      _$_CadastrarRedeiroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCarregandoEndereco(bool value) {
    final _$actionInfo = _$_CadastrarRedeiroStoreActionController.startAction(
        name: '_CadastrarRedeiroStore.setCarregandoEndereco');
    try {
      return super.setCarregandoEndereco(value);
    } finally {
      _$_CadastrarRedeiroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setGruposDeRedeiros(List<GrupoDeRedeirosDmo> value) {
    final _$actionInfo = _$_CadastrarRedeiroStoreActionController.startAction(
        name: '_CadastrarRedeiroStore.setGruposDeRedeiros');
    try {
      return super.setGruposDeRedeiros(value);
    } finally {
      _$_CadastrarRedeiroStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processando: ${processando},
nomeRedeiro: ${nomeRedeiro},
emailRedeiro: ${emailRedeiro},
celularRedeiro: ${celularRedeiro},
whatsapp: ${whatsapp},
endereco: ${endereco},
complemento: ${complemento},
carregandoEndereco: ${carregandoEndereco},
textoGruposDoRecolhimento: ${textoGruposDoRecolhimento},
habilitaBotaoDeCadastro: ${habilitaBotaoDeCadastro}
    ''';
  }
}
