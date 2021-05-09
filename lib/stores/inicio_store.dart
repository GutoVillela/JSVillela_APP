import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/parse_server/grupo_de_redeiros_parse.dart';
import 'package:jsvillela_app/parse_server/recolhimento_parse.dart';
import 'package:jsvillela_app/parse_server/redeiro_parse.dart';
import 'package:jsvillela_app/parse_server/redeiros_do_recolhimento_parse.dart';
import 'package:jsvillela_app/parse_server/relacao_redeiros_e_grupos_parse.dart';
import 'package:mobx/mobx.dart';

part 'inicio_store.g.dart';

class InicioStore = _InicioStore with _$InicioStore;

/// Store utilizado pela tela de início.
abstract class _InicioStore with Store{

  //#region Construtor(es)
  _InicioStore(){
    autorun((_){
      print("################################################# ABAIXO: ");
      print(recolhimentoDoDia.toString());
      print("################################################# existeRecolhimentoDoDia: $existeRecolhimentoDoDia ");
      print("################################################# recolhimentoEmAndamento: $recolhimentoEmAndamento ");
      print("################################################# recolhimentoDoDiaFinalizado: $recolhimentoDoDiaFinalizado ");

    });
  }
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


      // Obter redeiros relacionados aos grupos do recolhimento
      List<RedeiroDmo> redeiros = await RedeirosEGruposParse().obterRedeirosAPartirDosGrupos(recolhimentoDoDia!.gruposDoRecolhimento);

      // Criar lista de redeiros do recolhimento
      List<RedeiroDoRecolhimentoDmo> redeirosDoRecolhimento = redeiros.map((e) => RedeiroDoRecolhimentoDmo(id: "", redeiro: e, dataFinalizacao: null)).toList();

      // Cadastrar redeiros do recolhimento
      redeirosDoRecolhimento = await RedeirosDoRecolhimentoParse().cadastrarRedeirosDoRecolhimento(recolhimentoDoDia!.id!, redeirosDoRecolhimento);

      // Cadastrar data de início do recolhimento
      recolhimentoDoDia!.dataIniciado = DateTime.now();
      recolhimentoDoDia!.redeirosDoRecolhimento = redeirosDoRecolhimento;

      recolhimentoDoDia = await RecolhimentoParse().iniciarRecolhimento(recolhimentoDoDia!);

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
  //#endregion Actions


}