import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/dml/materia_prima_dmo.dart';

/// Model para matérias-primas.
class MateriaPrimaModel extends Model {
  //#region Atributos
  /// Indica que existe um processo em execução a partir desta classe.
  bool estaCarregando = false;
  //#endregion Atributos

  //#region Constantes
  /// Nome do identificador para a coleção "materias_primas" utilizado no Firebase.
  static const String NOME_COLECAO = "materias_primas";

  /// Nome do identificador para o campo "nome_materia_prima" utilizado na collection.
  static const String CAMPO_NM_MAT_PRIMA = "nome_materia_prima";

  /// Nome do identificador para o campo "icone_materia_prima" utilizado na collection do Firebase.
  static const String CAMPO_ICONE_MAT_PRIMA = "icone_materia_prima";
  //#endregion Constantes

  //#region Métodos
  ///Cadastra um redeiro no Firebase.
  void cadastrarMateriaPrima(
      {required MateriaPrimaDmo dadosDaMateriaPrima,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    FirebaseFirestore.instance
        .collection(NOME_COLECAO)
        .add(dadosDaMateriaPrima.converterParaMapa())
        .then((value) => onSuccess())
        .catchError((e) {
      onFail();
    });
  }

  ///Atualiza um grupo de redeiros no Firebase.
  void atualizarMateriaPrima(
      {required MateriaPrimaDmo dadosDaMateriaPrima,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    FirebaseFirestore.instance
        .collection(NOME_COLECAO)
        .doc(dadosDaMateriaPrima.id)
        .update(dadosDaMateriaPrima.converterParaMapa())
        .then((value) => onSuccess())
        .catchError((e) {
      print(e.toString());
      onFail();
    });
  }

  /// Apaga a matéria-prima do Firebase.
  Future<void> apagarMateriaPrima(
      {required String idMateriaPrima,
      required BuildContext context,
      required Function onSuccess,
      required VoidCallback onFail}) async {
    estaCarregando = true; // Indicar início do processamento
    notifyListeners();

    FirebaseFirestore.instance
        .collection(NOME_COLECAO)
        .doc(idMateriaPrima)
        .delete()
        .then((value) {
      estaCarregando = false; // Indicar FIM do processamento
      notifyListeners();
      onSuccess();
    }).catchError((e) {
      estaCarregando = false; // Indicar FIM do processamento
      notifyListeners();
      print(e.toString());
      onFail();
    });
  }

  /// Carrega as mp de forma paginada
  Future<QuerySnapshot> carregarMpPaginadas(
      DocumentSnapshot? ultimaMp, String? filtroPorNome) {
    if (filtroPorNome != null && filtroPorNome.isNotEmpty) {
      if (ultimaMp == null) {
        return FirebaseFirestore.instance
            .collection(NOME_COLECAO)
            .orderBy(CAMPO_NM_MAT_PRIMA)
            .startAt([filtroPorNome])
            .endAt([filtroPorNome + "\uf8ff"])
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      } else {
        return FirebaseFirestore.instance
            .collection(NOME_COLECAO)
            .orderBy(CAMPO_NM_MAT_PRIMA)
            .startAt([filtroPorNome])
            .endAt([filtroPorNome + "\uf8ff"])
            .startAfterDocument(ultimaMp)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      }
    }

    if (ultimaMp == null) {
      return FirebaseFirestore.instance
          .collection(NOME_COLECAO)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .orderBy(CAMPO_NM_MAT_PRIMA)
          .get();
    }

    return FirebaseFirestore.instance
        .collection(NOME_COLECAO)
        .orderBy(CAMPO_NM_MAT_PRIMA)
        .startAfterDocument(ultimaMp)
        .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        .get();
  }

  /// Carrega o redeiro por ID diretamente do Firebase.
  Future<DocumentSnapshot> carregarMateriaPrimaPorId(
      String idDaMateriaPrima) async {
    return await FirebaseFirestore.instance
        .collection(NOME_COLECAO)
        .doc(idDaMateriaPrima)
        .get();
  }
//#endregion Métodos

}
