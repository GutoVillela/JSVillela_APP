// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrousel_de_itens_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CarrouselDeItensStore on _CarrouselDeItensStore, Store {
  final _$cardAtualAtom = Atom(name: '_CarrouselDeItensStore.cardAtual');

  @override
  int get cardAtual {
    _$cardAtualAtom.reportRead();
    return super.cardAtual;
  }

  @override
  set cardAtual(int value) {
    _$cardAtualAtom.reportWrite(value, super.cardAtual, () {
      super.cardAtual = value;
    });
  }

  final _$finalizouRecolhimentoAtom =
      Atom(name: '_CarrouselDeItensStore.finalizouRecolhimento');

  @override
  bool get finalizouRecolhimento {
    _$finalizouRecolhimentoAtom.reportRead();
    return super.finalizouRecolhimento;
  }

  @override
  set finalizouRecolhimento(bool value) {
    _$finalizouRecolhimentoAtom.reportWrite(value, super.finalizouRecolhimento,
        () {
      super.finalizouRecolhimento = value;
    });
  }

  final _$_CarrouselDeItensStoreActionController =
      ActionController(name: '_CarrouselDeItensStore');

  @override
  void proximoCard() {
    final _$actionInfo = _$_CarrouselDeItensStoreActionController.startAction(
        name: '_CarrouselDeItensStore.proximoCard');
    try {
      return super.proximoCard();
    } finally {
      _$_CarrouselDeItensStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCardAtual(int value) {
    final _$actionInfo = _$_CarrouselDeItensStoreActionController.startAction(
        name: '_CarrouselDeItensStore.setCardAtual');
    try {
      return super.setCardAtual(value);
    } finally {
      _$_CarrouselDeItensStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFinalizouRecolhimento(bool value) {
    final _$actionInfo = _$_CarrouselDeItensStoreActionController.startAction(
        name: '_CarrouselDeItensStore.setFinalizouRecolhimento');
    try {
      return super.setFinalizouRecolhimento(value);
    } finally {
      _$_CarrouselDeItensStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cardAtual: ${cardAtual},
finalizouRecolhimento: ${finalizouRecolhimento}
    ''';
  }
}
