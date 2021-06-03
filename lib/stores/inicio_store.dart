import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/parse_server/recolhimento_parse.dart';
import 'package:jsvillela_app/parse_server/redeiro_parse.dart';
import 'package:mobx/mobx.dart';

part 'inicio_store.g.dart';

class InicioStore = _InicioStore with _$InicioStore;

/// Store utilizado pela tela de início.
abstract class _InicioStore with Store{

  //#region Construtor(es)
  _InicioStore();
  //#endregion Construtor(es)

  //#region Observables
  ///Atributo observável que define se classe está buscando recolhimento do dia.
  @observable
  bool carregandoRecolhimentoDoDia = false;

  ///Atributo observável que define se classe está carregando solicitações dos redeiros.
  @observable
  bool carregandoSolicitacoes = false;

  ///Atributo observável que define se classe está iniciando o recolhimento do dia.
  @observable
  bool iniciandoRecolhimento = false;

  ///Atributo observável que define se existe recolhimento do dia.
  @observable
  RecolhimentoDmo? recolhimentoDoDia;

  /// Lista que contém as cidades do recolhimento.
  ObservableList cidadesDoRecolhimento = ObservableList<String>();
  //#endregion Observables

  //#region Computed

  /// Computed que define se existe recolhimento para o dia ou não
  @computed
  bool get existeRecolhimentoDoDia => recolhimentoDoDia != null;

  /// Computed que define se existe um recolhimento em andamento.
  @computed
  bool get recolhimentoEmAndamento => recolhimentoDoDia != null && recolhimentoDoDia?.dataIniciado != null && recolhimentoDoDia?.dataFinalizado == null;

  /// Computed que define se existe recolhimento para o dia ou não
  @computed
  bool get recolhimentoDoDiaFinalizado => existeRecolhimentoDoDia && recolhimentoDoDia?.dataFinalizado != null;

  /// Computed que define se botão de iniciar recolhimento será habilitado ou não.
  @computed
  bool get habilitaBotaoIniciaRecolhimento => !iniciandoRecolhimento;
  //#endregion Computed

  //#region Actions
  /// Action responsável por carregar o recolhimento do dia.
  @action
  Future<void> carregarRecolhimentoDoDia() async{

    // Indicar que classe iniciou o processamento.
    carregandoRecolhimentoDoDia = true;

    try{

      // Definir dia de hoje
      DateTime hoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      // Buscar recolhimentos para hoje
      var recolhimentos = await RecolhimentoParse().obterRecolhimentosNaData(hoje);

      // Atribuir recolhimento do dia
      recolhimentoDoDia = recolhimentos.isEmpty ? null : recolhimentos.first;

      print("######################################## RECOLHIMENTO DO DIA: ${recolhimentoDoDia?.toString()}");

      // Carregas cidades do recolhimento caso exista recolhimento do dia
      if(recolhimentoDoDia != null){
        setCidadesDoRecolhimento(await RedeiroParse().obterListaDeCidadesAPartirDosGrupos(recolhimentoDoDia!.gruposDoRecolhimento));
      }else{
        setCidadesDoRecolhimento([]);
      }

      // Indicar que classe finalizou o processamento.
      carregandoRecolhimentoDoDia = false;
    }
    catch (e){
      //erro = e.toString();
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      carregandoRecolhimentoDoDia = false;
      return null;
    }
  }

  /// Action responsável por carregar solicitações dos redeiros.
  @action
  Future<void> carregarSolicitacoes() async{

    // Indicar que classe iniciou o processamento.
    carregandoSolicitacoes = true;

    try{

      // Definir dia de hoje
      DateTime hoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      // Buscar recolhimentos para hoje
      var recolhimentos = await RecolhimentoParse().obterRecolhimentosNaData(hoje);

      // Atribuir recolhimento do dia
      recolhimentoDoDia = recolhimentos.isEmpty ? null : recolhimentos.first;

      // Indicar que classe finalizou o processamento.
      carregandoSolicitacoes = false;
    }
    catch (e){
      //erro = e.toString();
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      carregandoSolicitacoes = false;
      return null;
    }
  }

  /// Action responsável por iniciar o recolhimento do dia.
  @action
  Future<void> iniciarRecolhimentoDoDia() async{

    // Indicar que classe iniciou o processamento.
    iniciandoRecolhimento = true;

    try{

      // Validar se recolhimento do dia está nulo
      if(recolhimentoDoDia == null)
        return Future.error('O recolhimento do dia está nulo!');

      // Validar se recolhimento do dia possui grupos
      if (recolhimentoDoDia!.gruposDoRecolhimento.isEmpty)
        return Future.error('Não existem grupos associados ao recolhimento do dia!');

      recolhimentoDoDia!.redeirosDoRecolhimento = await RecolhimentoParse().iniciarRecolhimento(recolhimentoDoDia!.id!);
      recolhimentoDoDia!.dataIniciado = DateTime.now();

      // Redundância para ativar o Observer
      recolhimentoDoDia = recolhimentoDoDia;

      // Indicar que classe finalizou o processamento.
      iniciandoRecolhimento = false;
    }
    catch (e){
      //erro = e.toString();
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      iniciandoRecolhimento = false;
      return null;
    }
  }

  /// Action responsável por terminar o recolhimento do dia.
  @action
  Future<void> terminarRecolhimentoDoDia() async{

    // Indicar que classe iniciou o processamento.
    iniciandoRecolhimento = true;

    try{

      // Validar se recolhimento do dia está nulo
      if(recolhimentoDoDia == null)
        return Future.error('O recolhimento do dia está nulo!');

      // Validar se recolhimento do dia possui grupos
      if (recolhimentoDoDia!.gruposDoRecolhimento.isEmpty)
        return Future.error('Não existem grupos associados ao recolhimento do dia!');

      DateTime dataFinalizado = DateTime.now();
      
      RecolhimentoParse().terminarRecolhimento(recolhimentoDoDia!.id!, dataFinalizado);

      recolhimentoDoDia!.dataFinalizado = dataFinalizado;

      // Redundância para ativar o Observer
      recolhimentoDoDia = recolhimentoDoDia;

      // Indicar que classe finalizou o processamento.
      iniciandoRecolhimento = false;
    }
    catch (e){
      //erro = e.toString();
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      iniciandoRecolhimento = false;
      return null;
    }
  }

  /// Action definir valor da lista observável "cidadesDoRecolhimento".
  @action
  void setCidadesDoRecolhimento(List<String> value){
    cidadesDoRecolhimento.clear();
    cidadesDoRecolhimento.addAll(value);
  }
  
  /// Action que verifica se todos os redeiros do recolhimento foram finalizados.
  @action
  void verificarSeRecolhimentoFoiFinalizado(){
    if(recolhimentoDoDia == null)
      return;
    
    // Se existir algum recolhimento ainda não finalizado, apenas encerrar método
    for(int i = 0; i < recolhimentoDoDia!.redeirosDoRecolhimento.length; i++){
      if(recolhimentoDoDia!.redeirosDoRecolhimento[i].dataFinalizacao == null)
        return;
    }
    
    // A partir deste ponto é correto assumir que todos os redeiros foram devidamente finalizados
    terminarRecolhimentoDoDia();
  }
  //#endregion Actions


}