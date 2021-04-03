import 'package:cloud_firestore/cloud_firestore.dart';

/// Classe abstrata base para objetos Dmo.
abstract class BaseDmo{

  /// Método que converte a instância atual da classe Dmo para um mapa.
  Map<String, dynamic> converterParaMapa();

}