// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_do_carrousel_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ItemDoCarrouselStore on _ItemDoCarrouselStore, Store {
  final _$processandoAtom = Atom(name: '_ItemDoCarrouselStore.processando');

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

  final _$carregandoMapaAtom =
      Atom(name: '_ItemDoCarrouselStore.carregandoMapa');

  @override
  bool get carregandoMapa {
    _$carregandoMapaAtom.reportRead();
    return super.carregandoMapa;
  }

  @override
  set carregandoMapa(bool value) {
    _$carregandoMapaAtom.reportWrite(value, super.carregandoMapa, () {
      super.carregandoMapa = value;
    });
  }

  final _$finalizarRecolhimentoDoRedeiroAsyncAction =
      AsyncAction('_ItemDoCarrouselStore.finalizarRecolhimentoDoRedeiro');

  @override
  Future<RedeiroDoRecolhimentoDmo?> finalizarRecolhimentoDoRedeiro() {
    return _$finalizarRecolhimentoDoRedeiroAsyncAction
        .run(() => super.finalizarRecolhimentoDoRedeiro());
  }

  final _$abrirMapaAsyncAction = AsyncAction('_ItemDoCarrouselStore.abrirMapa');

  @override
  Future<void> abrirMapa() {
    return _$abrirMapaAsyncAction.run(() => super.abrirMapa());
  }

  @override
  String toString() {
    return '''
processando: ${processando},
carregandoMapa: ${carregandoMapa}
    ''';
  }
}
