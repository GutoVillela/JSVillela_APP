// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on _LoginStore, Store {
  Computed<double>? _$loginDeslocamentoYComputed;

  @override
  double get loginDeslocamentoY => (_$loginDeslocamentoYComputed ??=
          Computed<double>(() => super.loginDeslocamentoY,
              name: '_LoginStore.loginDeslocamentoY'))
      .value;
  Computed<double>? _$loginDeslocamentoXComputed;

  @override
  double get loginDeslocamentoX => (_$loginDeslocamentoXComputed ??=
          Computed<double>(() => super.loginDeslocamentoX,
              name: '_LoginStore.loginDeslocamentoX'))
      .value;
  Computed<double>? _$loginLarguraComputed;

  @override
  double get loginLargura =>
      (_$loginLarguraComputed ??= Computed<double>(() => super.loginLargura,
              name: '_LoginStore.loginLargura'))
          .value;
  Computed<double>? _$loginOpacidadeComputed;

  @override
  double get loginOpacidade =>
      (_$loginOpacidadeComputed ??= Computed<double>(() => super.loginOpacidade,
              name: '_LoginStore.loginOpacidade'))
          .value;
  Computed<double>? _$esqueciASenhaDeslocamentoYComputed;

  @override
  double get esqueciASenhaDeslocamentoY =>
      (_$esqueciASenhaDeslocamentoYComputed ??= Computed<double>(
              () => super.esqueciASenhaDeslocamentoY,
              name: '_LoginStore.esqueciASenhaDeslocamentoY'))
          .value;
  Computed<double>? _$deslocamentoFormsPrimeiroPlanoComputed;

  @override
  double get deslocamentoFormsPrimeiroPlano =>
      (_$deslocamentoFormsPrimeiroPlanoComputed ??= Computed<double>(
              () => super.deslocamentoFormsPrimeiroPlano,
              name: '_LoginStore.deslocamentoFormsPrimeiroPlano'))
          .value;
  Computed<double>? _$deslocamentoFormsSegundoPlanoComputed;

  @override
  double get deslocamentoFormsSegundoPlano =>
      (_$deslocamentoFormsSegundoPlanoComputed ??= Computed<double>(
              () => super.deslocamentoFormsSegundoPlano,
              name: '_LoginStore.deslocamentoFormsSegundoPlano'))
          .value;

  final _$usuarioAtom = Atom(name: '_LoginStore.usuario');

  @override
  String get usuario {
    _$usuarioAtom.reportRead();
    return super.usuario;
  }

  @override
  set usuario(String value) {
    _$usuarioAtom.reportWrite(value, super.usuario, () {
      super.usuario = value;
    });
  }

  final _$senhaAtom = Atom(name: '_LoginStore.senha');

  @override
  String get senha {
    _$senhaAtom.reportRead();
    return super.senha;
  }

  @override
  set senha(String value) {
    _$senhaAtom.reportWrite(value, super.senha, () {
      super.senha = value;
    });
  }

  final _$lembrarUsuarioAtom = Atom(name: '_LoginStore.lembrarUsuario');

  @override
  bool get lembrarUsuario {
    _$lembrarUsuarioAtom.reportRead();
    return super.lembrarUsuario;
  }

  @override
  set lembrarUsuario(bool value) {
    _$lembrarUsuarioAtom.reportWrite(value, super.lembrarUsuario, () {
      super.lembrarUsuario = value;
    });
  }

  final _$processandoAtom = Atom(name: '_LoginStore.processando');

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

  final _$senhaVisivelAtom = Atom(name: '_LoginStore.senhaVisivel');

  @override
  bool get senhaVisivel {
    _$senhaVisivelAtom.reportRead();
    return super.senhaVisivel;
  }

  @override
  set senhaVisivel(bool value) {
    _$senhaVisivelAtom.reportWrite(value, super.senhaVisivel, () {
      super.senhaVisivel = value;
    });
  }

  final _$estadoDaPaginaAtom = Atom(name: '_LoginStore.estadoDaPagina');

  @override
  EstadoDaPaginaDeLogin get estadoDaPagina {
    _$estadoDaPaginaAtom.reportRead();
    return super.estadoDaPagina;
  }

  @override
  set estadoDaPagina(EstadoDaPaginaDeLogin value) {
    _$estadoDaPaginaAtom.reportWrite(value, super.estadoDaPagina, () {
      super.estadoDaPagina = value;
    });
  }

  final _$larguraDaTelaAtom = Atom(name: '_LoginStore.larguraDaTela');

  @override
  double get larguraDaTela {
    _$larguraDaTelaAtom.reportRead();
    return super.larguraDaTela;
  }

  @override
  set larguraDaTela(double value) {
    _$larguraDaTelaAtom.reportWrite(value, super.larguraDaTela, () {
      super.larguraDaTela = value;
    });
  }

  final _$alturaDaTelaAtom = Atom(name: '_LoginStore.alturaDaTela');

  @override
  double get alturaDaTela {
    _$alturaDaTelaAtom.reportRead();
    return super.alturaDaTela;
  }

  @override
  set alturaDaTela(double value) {
    _$alturaDaTelaAtom.reportWrite(value, super.alturaDaTela, () {
      super.alturaDaTela = value;
    });
  }

  final _$tecladoVisivelAtom = Atom(name: '_LoginStore.tecladoVisivel');

  @override
  bool get tecladoVisivel {
    _$tecladoVisivelAtom.reportRead();
    return super.tecladoVisivel;
  }

  @override
  set tecladoVisivel(bool value) {
    _$tecladoVisivelAtom.reportWrite(value, super.tecladoVisivel, () {
      super.tecladoVisivel = value;
    });
  }

  final _$erroAtom = Atom(name: '_LoginStore.erro');

  @override
  String? get erro {
    _$erroAtom.reportRead();
    return super.erro;
  }

  @override
  set erro(String? value) {
    _$erroAtom.reportWrite(value, super.erro, () {
      super.erro = value;
    });
  }

  final _$logarUsuarioAsyncAction = AsyncAction('_LoginStore.logarUsuario');

  @override
  Future<UsuarioDmo?> logarUsuario() {
    return _$logarUsuarioAsyncAction.run(() => super.logarUsuario());
  }

  final _$_LoginStoreActionController = ActionController(name: '_LoginStore');

  @override
  void setUsuario(String value) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.setUsuario');
    try {
      return super.setUsuario(value);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSenha(String value) {
    final _$actionInfo =
        _$_LoginStoreActionController.startAction(name: '_LoginStore.setSenha');
    try {
      return super.setSenha(value);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLembrarUsuario(bool value) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.setLembrarUsuario');
    try {
      return super.setLembrarUsuario(value);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarVisibilidadeDaSenha() {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.alterarVisibilidadeDaSenha');
    try {
      return super.alterarVisibilidadeDaSenha();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTecladoVisivel(bool value) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.setTecladoVisivel');
    try {
      return super.setTecladoVisivel(value);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEstadoDaPagina(EstadoDaPaginaDeLogin value) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.setEstadoDaPagina');
    try {
      return super.setEstadoDaPagina(value);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLarguraDaTela(double value) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.setLarguraDaTela');
    try {
      return super.setLarguraDaTela(value);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAlturaDaTela(double value) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
        name: '_LoginStore.setAlturaDaTela');
    try {
      return super.setAlturaDaTela(value);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
usuario: ${usuario},
senha: ${senha},
lembrarUsuario: ${lembrarUsuario},
processando: ${processando},
senhaVisivel: ${senhaVisivel},
estadoDaPagina: ${estadoDaPagina},
larguraDaTela: ${larguraDaTela},
alturaDaTela: ${alturaDaTela},
tecladoVisivel: ${tecladoVisivel},
erro: ${erro},
loginDeslocamentoY: ${loginDeslocamentoY},
loginDeslocamentoX: ${loginDeslocamentoX},
loginLargura: ${loginLargura},
loginOpacidade: ${loginOpacidade},
esqueciASenhaDeslocamentoY: ${esqueciASenhaDeslocamentoY},
deslocamentoFormsPrimeiroPlano: ${deslocamentoFormsPrimeiroPlano},
deslocamentoFormsSegundoPlano: ${deslocamentoFormsSegundoPlano}
    ''';
  }
}
