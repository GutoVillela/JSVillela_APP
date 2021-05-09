import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/parse_server/recolhimento_parse.dart';
import 'package:jsvillela_app/parse_server/redeiro_parse.dart';
import 'package:mobx/mobx.dart';

part 'agendar_recolhimento_store.g.dart';

class AgendarRecolhimentoStore = _AgendarRecolhimentoStore with _$AgendarRecolhimentoStore;

/// Store usada na tela de Agendar Recolhimento.
abstract class _AgendarRecolhimentoStore with Store{

  //#region Construtor(es)
  _AgendarRecolhimentoStore({required this.tipoDeManutencao, this.recolhimentoASerEditado}){
    autorun((_){

    });
  }
  //#endregion Construtor(es)

  //#region Atributos

  /// Formatar para para dd/MM/yyyy
  final formatoData = new DateFormat('dd/MM/yyyy');

  ///Atributo observável que define o tipo de manutenção da tela (inclusão ou alteração)
  final TipoDeManutencao tipoDeManutencao;

  /// Recolhimento a ser editado.
  final RecolhimentoDmo? recolhimentoASerEditado;

  /// Atributo observável que define as cidades a serem visitadas no recolhimento.
  List<String> listaDeCidades = [];
  //#endregion Atributos

  //#region Observables
  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  ///Atributo observável que define a data do recolhimento definida em tela.
  @observable
  DateTime? dataDoRecolhimento;

  /// Atributo observável que define a lista com os grupos de redeiros selecionados em tela.
  ObservableList<GrupoDeRedeirosDmo> gruposDeRedeiros = ObservableList<GrupoDeRedeirosDmo>();

  /// Atributo observável que define se existe um processo de validação de data em andamento.
  @observable
  bool validandoData = false;

  /// Atributo observável que define se existe um processo de validação de grupo(s) em andamento.
  @observable
  bool validandoGrupos = false;
  //#endregion Observables

  //#region Computed
  /// Computed que guarda o texto da Data do Recolhimento a ser exibido na tela.
  @computed
  String get textoDataRecolhimento => dataDoRecolhimento == null ? "Nenhuma data selecionada" : formatoData.format(dataDoRecolhimento!);

  /// Computed que guarda o texto dos Grupos do Recolhimento a ser exibido na tela.
  @computed
  String get textoGruposDoRecolhimento => gruposDeRedeiros.isEmpty ?
  "Nenhum grupo selecionado" :
  gruposDeRedeiros.first.nomeGrupo +
  (gruposDeRedeiros.length == 1 ? "" : " e mais ${gruposDeRedeiros.length - 1}.");

  /// Computed que define se botão de cadastro será habilitado ou não.
  @computed
  bool get habilitaBotaoDeCadastro => !processando;
  //#endregion Computed

  //#region Actions
  ///Action que define o valor do atributo observável "dataDoRecolhimento".
  @action
  Future<void> setDataDoRecolhimento(DateTime? value) async {
    // Validar data
    if(await validarData(value))
      dataDoRecolhimento = value;
  }

  ///Action que define o valor do atributo observável "dataDoRecolhimento".
  @action
  Future<void> setGruposDeRedeiros(List<GrupoDeRedeirosDmo> value) async {

    try{
      // Validar grupos
      if(await validarGrupos(value)){
        gruposDeRedeiros.clear();
        gruposDeRedeiros.addAll(value);
      }
    }
    catch(e){
      return Future.error(e.toString());
    }
  }

  @action
  Future<bool> validarData(DateTime? value) async{

    // Informar interface que a data está sendo validada
    validandoData = true;

    // Iniciar data como inválida antes das validações finalizarem.
    bool dataValida = false;

    // Retornar false caso data seja nula
    if(value == null)
      return dataValida;

    try{
      // Verificar se data é válida
      if((tipoDeManutencao == TipoDeManutencao.alteracao && value.isAtSameMomentAs(recolhimentoASerEditado!.dataDoRecolhimento))
          || await RecolhimentoParse().validarSeExisteRecolhimentoAgendadoParaAData(value)){

        dataValida = true;

        // Informar interface que a validação da data terminou.
        validandoData = false;
      }
      else{
        dataValida = false;

        // Informar interface que a validação da data terminou.
        validandoData = false;

        return Future.error("Já existe um agendamento para a data selecionada. Por favor escolha outra data!");
      }

      return dataValida;
    }
    catch(e){
      // Informar interface que a validação da data terminou.
      validandoData = false;

      return dataValida;
    }
  }

  /// Action que valida se os grupos selecionados são válidos.
  @action
  Future<bool> validarGrupos(List<GrupoDeRedeirosDmo> grupos) async{

    // Informar interface que a data está sendo validada
    validandoGrupos = true;

    try{

      // Validar se foi selecionado um conjunto de grupos diferentes
      if(!_validarSeGruposSaoIguais(gruposDeRedeiros, grupos)){

        // Informar interface que a validação dos grupos terminou.
        validandoGrupos = false;
        return false;
      }

      // Buscar lista de cidades
      List<String> cidades = await _buscarListaDeCidades(grupos);

      // Validar se existem redeiros para os grupos selecionados.
      if(cidades.isNotEmpty){
        listaDeCidades = cidades;

        // Informar interface que a validação dos grupos terminou.
        validandoGrupos = false;

        return true;
      }
      else{
        bool plural = grupos.length > 1;

        // Informar interface que a validação dos grupos terminou.
        validandoGrupos = false;

        return Future.error("Não existem redeiros associados ${plural ? "aos grupos escolhidos" : "ao grupo escolhido"}. Por favor escolha um ou mais grupos que tenha pelo menos um redeiro associado para agendar o recolhimento.");
      }
    }
    catch(e){
      // Informar interface que a validação dos grupos terminou.
      validandoGrupos = false;

      return Future.error(e);
    }
  }

  /// Action que realiza processo cadastro ou edição do recolhimento.
  @action
  Future<RecolhimentoDmo?> cadastrarOuEditarRecolhimento() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{

      // Montando objeto para cadastro
      RecolhimentoDmo dadosDoRecolhimento = RecolhimentoDmo(
          id: recolhimentoASerEditado?.id,
          dataDoRecolhimento: dataDoRecolhimento!,
          gruposDoRecolhimento: gruposDeRedeiros);

      late RecolhimentoDmo recolhimento;

      if(tipoDeManutencao == TipoDeManutencao.cadastro){
        // Realizar cadastro do redeiro.
        recolhimento = await RecolhimentoParse().cadastrarRecolhimento(dadosDoRecolhimento);
      }
      else{
        // Realizar edição do grupo.
        recolhimento = await RecolhimentoParse().editarRecolhimento(dadosDoRecolhimento);
      }

      // Indicar que classe finalizou o processamento.
      processando = false;

      // Retornar novo grupo
      return recolhimento;
    }
    catch (e){
      //erro = e.toString();
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      processando = false;
      return null;
    }
  }
  //#endregion Actions

  //#region Métodos
  /// Valida se todos os elementos selecionados entre dois grupos são iguais. Retorna true caso os grupos sejam diferentes e false caso sejam iguais.
  bool _validarSeGruposSaoIguais(List<GrupoDeRedeirosDmo> listaDegrupos1, List<GrupoDeRedeirosDmo> listaDegrupos2){
    bool saoIguais = false;

    if(listaDegrupos1.isEmpty && listaDegrupos2.isEmpty)
      return false;

    if(listaDegrupos1.isEmpty|| listaDegrupos2.isEmpty)
      return true;

    for(GrupoDeRedeirosDmo grupo1 in listaDegrupos1){
      for(GrupoDeRedeirosDmo grupo2 in listaDegrupos2){
        saoIguais = grupo1.idGrupo == grupo2.idGrupo;
      }
    }

    return !saoIguais;
  }

  /// Busca a lista de cidades para os grupos fornecidos.
  Future<List<String>> _buscarListaDeCidades(List<GrupoDeRedeirosDmo> listaDeGrupos) async {
    if(listaDeGrupos.isEmpty)
      return [];

    // Obter lista de cidades
    return await RedeiroParse().obterListaDeCidadesAPartirDosGrupos(listaDeGrupos);
  }
  //#endregion Métodos
}