import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/models/redeiro_do_recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model para recolhimentos.
class RecolhimentoModel extends Model{

  //#region Construtor(es)
  RecolhimentoModel(){
    _carregarRecolhimentoDoDia();
  }
  //#endregion Construtor(es)

  //#region Constantes
  
  /// Nome do identificador para a coleção "recolhimentos" utilizado no Firebase.
  static const String NOME_COLECAO = "recolhimentos";

  /// Nome do identificador para o campo "data_recolhimento" utilizado na collection do Firebase.
  static const String CAMPO_DATA_RECOLHIMENTO = "data_recolhimento";

  /// Nome do identificador para o campo "data_iniciado" utilizado na collection do Firebase.
  static const String CAMPO_DATA_INICIADO = "data_iniciado";

  /// Nome do identificador para o campo "data_finalizado" utilizado na collection do Firebase.
  static const String CAMPO_DATA_FINALIZADO = "data_finalizado";

  /// Nome do identificador para o campo "grupos_do_recolhimento" utilizado na collection do Firebase.
  static const String CAMPO_GRUPOS_DO_RECOLHIMENTO = "grupos_do_recolhimento";

  //#endregion Constantes

  //#region Atributos
  /// Indica que existe um processo em execução a partir desta classe.
  bool estaCarregando = false;

  /// Indica se existe um recolhimento em andamento ou não.
  bool recolhimentoEmAndamento = false;

  /// Recolhimento do dia associado ao model.
  RecolhimentoDmo recolhimentoDoDia;
  //#endregion Atributos

  //#region Métodos
  static RecolhimentoModel of (BuildContext context) => ScopedModel.of<RecolhimentoModel>(context);

  ///Cadastra um recolhimento no Firebase.
  void cadastrarRecolhimento({@required RecolhimentoDmo dadosDoRecolhimento, @required Function onSuccess, @required Function onFail}){

    FirebaseFirestore.instance.collection(NOME_COLECAO).add({
      CAMPO_DATA_RECOLHIMENTO : dadosDoRecolhimento.dataDoRecolhimento,
      CAMPO_DATA_INICIADO: null,
      CAMPO_DATA_FINALIZADO : null,
      CAMPO_GRUPOS_DO_RECOLHIMENTO : dadosDoRecolhimento.gruposDoRecolhimento.map((e) => e.idGrupo).toList()
    }).then((value) async{
      onSuccess();
      await _carregarRecolhimentoDoDia();
    }).catchError((e){
      print(e.toString());
      onFail();
    });
  }

  /// Carrega os recolhimentos de forma paginada diretamente do Firebase.
  Future<QuerySnapshot> carregarRecolhimentosPaginados(DocumentSnapshot ultimoRecolhimento, DateTime filtroDataInicial, DateTime filtroDataFinal, bool incluirFinalizados) {

    //#region Filtro com data inicial e final
    if(filtroDataInicial != null && filtroDataFinal != null){
      
      if(ultimoRecolhimento == null){
        if(incluirFinalizados){
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
              .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
        else{
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
              .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
              .where(CAMPO_DATA_FINALIZADO, isNull: true)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
      }
      else{
        if(incluirFinalizados){
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
              .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
              .startAfterDocument(ultimoRecolhimento)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
        else{
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
              .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
              .where(CAMPO_DATA_FINALIZADO, isNull: true)
              .startAfterDocument(ultimoRecolhimento)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
      }
    }
    //#endregion Filtro com data inicial e final

    //#region Filtro com data inicial
    if(filtroDataInicial != null){
      if(ultimoRecolhimento == null){
        if(incluirFinalizados){
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
        else{
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
              .where(CAMPO_DATA_FINALIZADO, isNull: true)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
      }
      else{
        if(incluirFinalizados){
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
              .startAfterDocument(ultimoRecolhimento)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
        else{
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isGreaterThanOrEqualTo: filtroDataInicial)
              .where(CAMPO_DATA_FINALIZADO, isNull: true)
              .startAfterDocument(ultimoRecolhimento)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
      }
    }
    //#endregion Filtro com data inicial

    //#region Filtro com data final
    if(filtroDataFinal != null){
      if(ultimoRecolhimento == null){
        if(incluirFinalizados){
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
        else{
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
              .where(CAMPO_DATA_FINALIZADO, isNull: true)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
      }
      else{
        if(incluirFinalizados){
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
              .startAfterDocument(ultimoRecolhimento)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
        else{
          return FirebaseFirestore.instance.collection(NOME_COLECAO)
              .orderBy(CAMPO_DATA_RECOLHIMENTO)
              .where(CAMPO_DATA_RECOLHIMENTO, isLessThanOrEqualTo: filtroDataFinal)
              .where(CAMPO_DATA_FINALIZADO, isNull: true)
              .startAfterDocument(ultimoRecolhimento)
              .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
              .get();
        }
      }
    }
    //#endregion Filtro com data final

    if(ultimoRecolhimento == null){
      if(incluirFinalizados){
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .orderBy(CAMPO_DATA_RECOLHIMENTO)
            .get();
      }
      else{
        return FirebaseFirestore.instance.collection(NOME_COLECAO)
            .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
            .orderBy(CAMPO_DATA_RECOLHIMENTO)
            .where(CAMPO_DATA_FINALIZADO, isNull: true)
            .get();
      }
    }

    if(incluirFinalizados)
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .orderBy(ultimoRecolhimento)
          .startAfterDocument(ultimoRecolhimento)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .get();
    else
      return FirebaseFirestore.instance.collection(NOME_COLECAO)
          .orderBy(ultimoRecolhimento)
          .startAfterDocument(ultimoRecolhimento)
          .limit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
          .where(CAMPO_DATA_FINALIZADO, isNull: true)
          .get();
  }

  /// Carrega os recolhimentos por grupos.
  Future<QuerySnapshot> carregarRecolhimentosPorGrupos(List<String> idsDosGrupos){

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .where(CAMPO_GRUPOS_DO_RECOLHIMENTO, arrayContainsAny: idsDosGrupos)
        .get();
  }

  /// Carrega os recolhimentos agendados em uma data específica diretamente do Firebase.
  Future<QuerySnapshot> carregarRecolhimentosAgendadosNaData(DateTime dataRecolhimento) {
    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .where(CAMPO_DATA_RECOLHIMENTO, isEqualTo: dataRecolhimento.toLocal())
        .get();
  }

  /// Busca um recolhimento por ID.
  Future<DocumentSnapshot> carregarRecolhimentoPorId(String idDoRecolhimento){

    return FirebaseFirestore.instance.collection(NOME_COLECAO)
        .doc(idDoRecolhimento)
        .get();
  }

  /// Atualiza a data de Finalização para um Recolhimento.
  Future<void> finalizarRecolhimento({@required String idRecolhimento, @required DateTime dataFinalizacao}) {

    estaCarregando = true;// Indicar início do processamento
    notifyListeners();

    return FirebaseFirestore.instance.collection(RecolhimentoModel.NOME_COLECAO)
      .doc(idRecolhimento)
      .update({ CAMPO_DATA_FINALIZADO: dataFinalizacao })
      .then((value){
        estaCarregando = false;
        this.recolhimentoDoDia.dataFinalizado = dataFinalizacao;
        recolhimentoEmAndamento = false;
        notifyListeners();
      })
      .catchError((erro) {
        estaCarregando = false;
        notifyListeners();
      });
  }

  /// Carrega o recolhimento do dia.
  Future<void> _carregarRecolhimentoDoDia() async{

    estaCarregando = true;
    notifyListeners();

    QuerySnapshot recolhimento = await FirebaseFirestore.instance.collection(NOME_COLECAO)
        .where(CAMPO_DATA_RECOLHIMENTO, isEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toLocal())
        .get();

    if(recolhimento != null && recolhimento.docs.any((element) => true)){
      this.recolhimentoDoDia = RecolhimentoDmo.converterSnapshotEmRecolhimento(recolhimento.docs.first);

      // Carregar redeiros do recolhimento
      QuerySnapshot redeirosDoRecolhimento = await RedeiroModel().carregarRedeirosPorGrupos(this.recolhimentoDoDia.gruposDoRecolhimento.map((e) => e.idGrupo).toList());

      // Obter redeiros dos grupos
      List<RedeiroDmo> listaDeRedeiros = [];
      redeirosDoRecolhimento.docs.forEach((element) {
        listaDeRedeiros.add(RedeiroDmo.converterSnapshotEmRedeiro(element));
      });

      // Converter redeiros em Redeiros do Recolhimento
      recolhimentoDoDia.redeirosDoRecolhimento = listaDeRedeiros.map((e) => RedeiroDoRecolhimentoDmo(redeiro: e)).toList();
    }

    // Verificar se recolhimento do dia está em andamento
    recolhimentoEmAndamento = recolhimentoDoDia != null && recolhimentoDoDia.dataFinalizado == null && recolhimentoDoDia.dataIniciado != null;

    estaCarregando = false;
    notifyListeners();
  }

  /// Carrega os redeiros associados ao recolhimento do dia.
  Future<void> _carregarRedeirosDoRecolhimentoDoDia() async {

    estaCarregando = true;// Indicar início do processamento
    notifyListeners();

    recolhimentoDoDia.redeirosDoRecolhimento = [];

    QuerySnapshot snapshotRedeiros = await RedeiroDoRecolhimentoModel().carregarRedeirosDeUmRecolhimento(recolhimentoDoDia.id);

    // Obter os redeiros do recolhimento cadastrados no recolhimento
    snapshotRedeiros.docs.forEach((element) {
      recolhimentoDoDia.redeirosDoRecolhimento.add(RedeiroDoRecolhimentoDmo.converterSnapshotEmRedeiroDoRecolhimento(element));
    });

    estaCarregando = false;
    notifyListeners();
  }

  /// Define a flag "recolhimentoEmAndamento" para true e notifica os listeners.
  Future<void> iniciarRecolhimento(String idRecolhimento) async{

    await FirebaseFirestore.instance.collection(RecolhimentoModel.NOME_COLECAO)
        .doc(idRecolhimento)
        .update({ CAMPO_DATA_INICIADO: DateTime.now() });

    // Carregar os redeiros do recolhimento caso não existam.
    if(recolhimentoDoDia.redeirosDoRecolhimento == null || recolhimentoDoDia.redeirosDoRecolhimento.any((element) => true)){
      await _carregarRedeirosDoRecolhimentoDoDia();
    }
    recolhimentoEmAndamento = true;
    notifyListeners();
  }

//#endregion Métodos

}