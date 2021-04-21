import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jsvillela_app/infra/preferencias.dart';

/// Model para grupo de redeiros.
class GrupoDeRedeirosModel extends Model {
  //#region Atributos

  /// Indica que existe um processo em execução a partir desta classe.
  bool estaCarregando = false;

  //#endregion Atributos

  //#region Constantes

  /// Nome do identificador para a coleção "grupos_de_redeiros" utilizado no Firebase.
  static const String NOME_COLECAO = "grupos_de_redeiros";

  /// Nome do identificador para o campo "nome_grupo" utilizado na collection.
  static const String CAMPO_NOME = "nome_grupo";

  /// Nome do identificador para o id do documento quando gravado em outras collections do Firebase.
  static const String ID_COLECAO = "id";
  //#endregion Constantes

  //#region Métodos
  static GrupoDeRedeirosModel of(BuildContext context) =>
      ScopedModel.of<GrupoDeRedeirosModel>(context);

  ///Cadastra um grupo de redeiros no Firebase.
  void cadastrarGrupoDeRedeiros(
      {required GrupoDeRedeirosDmo dadosDoGrupo,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    FirebaseFirestore.instance
        .collection(NOME_COLECAO)
        .add(dadosDoGrupo.converterParaMapa())
        .then((value) => onSuccess())
        .catchError((e) {
      onFail();
    });
  }

  ///Atualiza um grupo de redeiros no Firebase.
  void atualizarGrupo(
      {required GrupoDeRedeirosDmo dadosDoGrupo,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    FirebaseFirestore.instance
        .collection(NOME_COLECAO)
        .doc(dadosDoGrupo.idGrupo)
        .update(dadosDoGrupo.converterParaMapa())
        .then((value) => onSuccess())
        .catchError((e) {
      print(e.toString());
      onFail();
    });
  }

  /// Busca um grupo de redeiros por ID.
  Future<DocumentSnapshot> carregarGrupoPorId(String idDoGrupo) async {
    return await FirebaseFirestore.instance
        .collection(NOME_COLECAO)
        .doc(idDoGrupo)
        .get();
  }

  /// Carrega uma lista de grupos por ID.
  Future<List<GrupoDeRedeirosDmo>> carregarGruposPorId(
      List<String> idsDosGrupos) async {
    estaCarregando = true;
    notifyListeners();

    List<GrupoDeRedeirosDmo> listaDeGrupos = [];

    for (int i = 0; i < idsDosGrupos.length; i++) {
      try {
        DocumentSnapshot grupo = await carregarGrupoPorId(idsDosGrupos[i]);
        listaDeGrupos
            .add(GrupoDeRedeirosDmo.converterSnapshotEmGrupoDeRedeiro(grupo));
      } catch (erro) {
        listaDeGrupos.add(GrupoDeRedeirosDmo(idGrupo: "", nomeGrupo: "Grupo apagado"));
      }
    }

    estaCarregando = false;
    notifyListeners();

    return listaDeGrupos;
  }

  Future<QuerySnapshot> carregarGruposDeRedeirosPaginados(
      DocumentSnapshot? ultimoGrupo, String? filtroPorNome) {
    if (filtroPorNome != null && filtroPorNome.isNotEmpty) {
      if (ultimoGrupo == null)
        return FirebaseFirestore.instance
            .collection(NOME_COLECAO)
            .orderBy(CAMPO_NOME)
            .startAt([filtroPorNome])
            .endAt([filtroPorNome + "\uf8ff"])
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
      else
        return FirebaseFirestore.instance
            .collection(NOME_COLECAO)
            .orderBy(CAMPO_NOME)
            .startAt([filtroPorNome])
            .endAt([filtroPorNome + "\uf8ff"])
            .startAfterDocument(ultimoGrupo)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .get();
    }

    if (ultimoGrupo == null)
      return FirebaseFirestore.instance
          .collection(NOME_COLECAO)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .orderBy(CAMPO_NOME)
          .get();

    return FirebaseFirestore.instance
        .collection(NOME_COLECAO)
        .orderBy(CAMPO_NOME)
        .startAfterDocument(ultimoGrupo)
        .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        .get();
  }

  GrupoDeRedeirosDmo converterSnapshotEmGrupoDeRedeiros(
      DocumentSnapshot grupoDeRedeiros) {
    return GrupoDeRedeirosDmo(
        idGrupo: grupoDeRedeiros.id, nomeGrupo: grupoDeRedeiros[CAMPO_NOME]);
  }

  /// Apaga o grupo de redeiros do Firebase.
  Future<void> apagarGrupoDeRedeiros(
      {required String idGrupo,
      required BuildContext context,
      required Function onSuccess,
      required VoidCallback onFail}) async {
    estaCarregando = true; // Indicar início do processamento
    notifyListeners();

    FirebaseFirestore.instance
        .collection(NOME_COLECAO)
        .doc(idGrupo)
        .delete()
        .then((value) {
      RecolhimentoModel.of(context).carregarRecolhimentoDoDia();
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

//#endregion Métodos

}
