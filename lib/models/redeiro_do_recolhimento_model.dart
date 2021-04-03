import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model para redeiros do recolhimento.
class RedeiroDoRecolhimentoModel extends Model{

  //#region Atributos
  /// Indica que existe um processo em execução a partir desta classe.
  bool estaCarregando = false;
  //#endregion Atributos

  //#region Constantes
  /// Nome do identificador para a coleção "redeiros_do_recolhimento" utilizado no Firebase.
  static const String NOME_COLECAO = "redeiros_do_recolhimento";

  /// Nome do identificador para o campo "redeiro" utilizado na collection do Firebase.
  static const String CAMPO_REDEIRO = "redeiro";

  /// Nome do identificador para o campo "data_finalizacao" utilizado na collection do Firebase.
  static const String CAMPO_DATA_FINALIZACAO = "data_finalizacao";
  //#endregion Constantes

  //#region Métodos

  static RedeiroDoRecolhimentoModel of (BuildContext context) => ScopedModel.of<RedeiroDoRecolhimentoModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  ///Cadastra uma lista de redeiro do recolhimento na collection de Recolhimentos no Firebase.
  void cadastrarRedeirosDoRecolhimento({@required String idRecolhimento, @required List<RedeiroDoRecolhimentoDmo> redeirosDoRecolhimento, @required Function onSuccess, @required VoidCallback onFail}){

    estaCarregando = true;// Indicar início do processamento
    notifyListeners();

    var batch = FirebaseFirestore.instance.batch();// Batch para criação de uma transação

    redeirosDoRecolhimento.forEach((redeiro) {
      var idUnico = FirebaseFirestore.instance.collection(RecolhimentoModel.NOME_COLECAO).doc(idRecolhimento).collection(NOME_COLECAO).doc();
      redeiro.id = idUnico.id;// Após gerar ID único, atribuir ID na lista de redeiros que será devolvida no CallBack
      batch.set(idUnico, redeiro.converterParaMapa());
    });

    // Comitar batch em caso de sucesso
    batch.commit()
    .then((value) {
      estaCarregando = false;// Indicar FIM do processamento
      notifyListeners();
      onSuccess(redeirosDoRecolhimento);
    }).catchError((e){
      estaCarregando = false;// Indicar FIM do processamento
      notifyListeners();
      print(e.toString());
      onFail();
    });
  }

  /// Atualiza a data de Finalização para um Redeiro do Recolhimento.
  Future<void> finalizarRecolhimentoDoRedeiro({@required String idRecolhimento, @required String idRedeiroDoRecolhimento, @required DateTime dataFinalizacao}) {

    estaCarregando = true;// Indicar início do processamento
    notifyListeners();

    print("ID que será gravado: $idRedeiroDoRecolhimento");
    return FirebaseFirestore.instance.collection(RecolhimentoModel.NOME_COLECAO)
        .doc(idRecolhimento).collection(NOME_COLECAO).doc(idRedeiroDoRecolhimento)
        .update({ CAMPO_DATA_FINALIZACAO: dataFinalizacao })
        .then((value){
          estaCarregando = false;
          notifyListeners();
        })
        .catchError((erro) {
          estaCarregando = false;
          notifyListeners();
        });
  }

  /// Busca os redeiros de um recolhimento específico.
  Future<QuerySnapshot> carregarRedeirosDeUmRecolhimento(String idDoRecolhimento) async{
    return await FirebaseFirestore.instance.collection(RecolhimentoModel.NOME_COLECAO)
        .doc(idDoRecolhimento).collection(NOME_COLECAO)
        .get();
  }

  /// Busca os redeiros de um recolhimento específico.
  Future<List<RedeiroDoRecolhimentoDmo>> carregarRedeirosDeUmRecolhimentoComDetalhes(String idDoRecolhimento) async{
    estaCarregando = true;
    notifyListeners();

    // Consultar redeiros do recolhimento diretamente no Firebase
    QuerySnapshot snapshotRedeiros = await carregarRedeirosDeUmRecolhimento(idDoRecolhimento);

    // Inicializar lista de redeiros
    List<RedeiroDoRecolhimentoDmo> redeirosDoRecolhimento = [];

    // Converter lista de redeiros para uma lista de objetos RedeiroDoRecolhimentoDmo.
    snapshotRedeiros.docs.forEach((element) {
      redeirosDoRecolhimento.add(RedeiroDoRecolhimentoDmo.converterSnapshotEmRedeiroDoRecolhimento(element));
    });

    // Obter detalhes de todos os redeiros obtidos
    for(int i = 0; i < redeirosDoRecolhimento.length; i++){
      redeirosDoRecolhimento[i].redeiro =  RedeiroDmo.converterSnapshotEmRedeiro(await RedeiroModel().carregarRedeiroPorId(redeirosDoRecolhimento[i].redeiro.id));
    }

    estaCarregando = false;
    notifyListeners();

    return redeirosDoRecolhimento;
  }

  /// Carrega as informações do redeiro por ID.
  Future<RedeiroDmo> carregarInformacoesDoRedeiro(String idDoRedeiro){

    estaCarregando = true;
    notifyListeners();

    RedeiroModel().carregarRedeiroPorId(idDoRedeiro)
      .then((value){

      })
      .catchError((erro){

      });
  }
  //#endregion Métodos

}