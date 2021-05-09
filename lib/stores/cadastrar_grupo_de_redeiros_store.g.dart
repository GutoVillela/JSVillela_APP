// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastrar_grupo_de_redeiros_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastrarGrupoDeRedeirosStore on _CadastrarGrupoDeRedeirosStore, Store {
  Computed<bool>? _$habilitaBotaoDeCadastroComputed;

  @override
  bool get habilitaBotaoDeCadastro => (_$habilitaBotaoDeCadastroComputed ??=
          Computed<bool>(() => super.habilitaBotaoDeCadastro,
              name: '_CadastrarGrupoDeRedeirosStore.habilitaBotaoDeCadastro'))
      .value;

  final _$processandoAtom =
      Atom(name: '_CadastrarGrupoDeRedeirosStore.processando');

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

  final _$tipoDeManutencaoAtom =
      Atom(name: '_CadastrarGrupoDeRedeirosStore.tipoDeManutencao');

  @override
  TipoDeManutencao get tipoDeManutencao {
    _$tipoDeManutencaoAtom.reportRead();
    return super.tipoDeManutencao;
  }

  @override
  set tipoDeManutencao(TipoDeManutencao value) {
    _$tipoDeManutencaoAtom.reportWrite(value, super.tipoDeManutencao, () {
      super.tipoDeManutencao = value;
    });
  }

  final _$nomeGrupoAtom =
      Atom(name: '_CadastrarGrupoDeRedeirosStore.nomeGrupo');

  @override
  String get nomeGrupo {
    _$nomeGrupoAtom.reportRead();
    return super.nomeGrupo;
  }

  @override
  set nomeGrupo(String value) {
    _$nomeGrupoAtom.reportWrite(value, super.nomeGrupo, () {
      super.nomeGrupo = value;
    });
  }

  final _$erroAtom = Atom(name: '_CadastrarGrupoDeRedeirosStore.erro');

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

  final _$cadastrarGrupoDeRedeirosAsyncAction =
      AsyncAction('_CadastrarGrupoDeRedeirosStore.cadastrarGrupoDeRedeiros');

  @override
  Future<GrupoDeRedeirosDmo?> cadastrarGrupoDeRedeiros() {
    return _$cadastrarGrupoDeRedeirosAsyncAction
        .run(() => super.cadastrarGrupoDeRedeiros());
  }

  final _$editarGrupoDeRedeirosAsyncAction =
      AsyncAction('_CadastrarGrupoDeRedeirosStore.editarGrupoDeRedeiros');

  @override
  Future<GrupoDeRedeirosDmo?> editarGrupoDeRedeiros(GrupoDeRedeirosDmo grupo) {
    return _$editarGrupoDeRedeirosAsyncAction
        .run(() => super.editarGrupoDeRedeiros(grupo));
  }

  final _$_CadastrarGrupoDeRedeirosStoreActionController =
      ActionController(name: '_CadastrarGrupoDeRedeirosStore');

  @override
  void setNomeGrupo(String value) {
    final _$actionInfo = _$_CadastrarGrupoDeRedeirosStoreActionController
        .startAction(name: '_CadastrarGrupoDeRedeirosStore.setNomeGrupo');
    try {
      return super.setNomeGrupo(value);
    } finally {
      _$_CadastrarGrupoDeRedeirosStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
processando: ${processando},
tipoDeManutencao: ${tipoDeManutencao},
nomeGrupo: ${nomeGrupo},
erro: ${erro},
habilitaBotaoDeCadastro: ${habilitaBotaoDeCadastro}
    ''';
  }
}
