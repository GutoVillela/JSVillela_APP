import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/grupo_de_redeiros_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe "Recolhimento" do Parse Server.
class RecolhimentoParse{

  //#region Constantes

  /// Constante que define nome da classe "Recolhimentos" do Parse Server.
  static const String NOME_CLASSE = "Recolhimentos";

  /// Constante que define o campo "objectId" da classe "Recolhimentos" do Parse Server.
  static const String CAMPO_ID_RECOLHIMENTO = "objectId";

  /// Constante que define o campo "dataRecolhimento" da classe "Recolhimentos" do Parse Server.
  static const String CAMPO_DATA_RECOLHIMENTO = "dataRecolhimento";

  /// Constante que define o campo "dataIniciado" da classe "Recolhimentos" do Parse Server.
  static const String CAMPO_DATA_INICIADO = "dataIniciado";

  /// Constante que define o campo "dataFinalizado" da classe "Recolhimentos" do Parse Server.
  static const String CAMPO_DATA_FINALIZADO = "dataFinalizado";

  /// Constante que define o relacionamento N para N "gruposDoRecolhimento" da classe "Recolhimentos" do Parse Server.
  static const String RELACIONAMENTO_GRUPOS_DO_RECOLHIMENTO = "gruposDoRecolhimento";

  //#endregion Constantes

  //#region Métodos
  /// Método responsável por cadastrar um recolhimento no Parse Server.
  Future<RecolhimentoDmo> cadastrarRecolhimento(RecolhimentoDmo recolhimento) async {

    // Definir informações do recolhimento
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..set<DateTime>(CAMPO_DATA_RECOLHIMENTO, recolhimento.dataDoRecolhimento)
      ..set<DateTime?>(CAMPO_DATA_INICIADO, null)
      ..set<DateTime?>(CAMPO_DATA_FINALIZADO, null)
      //Criando relacionamento N para N com os grupos do recolhimento
      ..addRelation(
        RELACIONAMENTO_GRUPOS_DO_RECOLHIMENTO,
        recolhimento.gruposDoRecolhimento.map((e) =>
          ParseObject(GrupoDeRedeirosParse.NOME_CLASSE)
            ..objectId = e.idGrupo
        ).toList()
      );

    // Criar usuário no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      // Em caso de sucesso recuperar ID do recolhimento
      recolhimento.id =  (response.result as ParseObject).objectId;
      return recolhimento;
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por editar um recolhimento no Parse Server.
  Future<RecolhimentoDmo> editarRecolhimento(RecolhimentoDmo recolhimento) async {

    // Obter lista de grupos
    List<GrupoDeRedeirosDmo> grupos = await obterGruposDoRecolhimento(recolhimento.id!);

    // Obter os grupos do redeiro a remover
    List<GrupoDeRedeirosDmo> gruposARemover = [];
    grupos.forEach((grupo) {
      if(!recolhimento.gruposDoRecolhimento.any((element) => element.idGrupo == grupo.idGrupo))
        gruposARemover.add(grupo);
    });

    // Obter os grupos do redeiro a adicionar
    List<GrupoDeRedeirosDmo> gruposAAdicionar = [];
    recolhimento.gruposDoRecolhimento.forEach((grupo) {
      if(!gruposARemover.any((element) => element.idGrupo == grupo.idGrupo))
        gruposAAdicionar.add(grupo);
    });

    // Alterar informações do redeiro
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..objectId = recolhimento.id
      ..set<DateTime>(CAMPO_DATA_RECOLHIMENTO, recolhimento.dataDoRecolhimento)
      ..set<DateTime?>(CAMPO_DATA_INICIADO, null)
      ..set<DateTime?>(CAMPO_DATA_FINALIZADO, null);

    //Se existir elementos na lista de grupos a adicionar, incluir instrução para adicionar grupos.
    if(gruposAAdicionar.any((element) => true))
      await adicionarGruposAoRecolhimento(recolhimento.id!, gruposAAdicionar);

    // Se existir elementos na lista de grupos a remover, adicionar instrução para remover grupos.
    if(gruposARemover.any((element) => true))
      await removerGruposAoRecolhimento(recolhimento.id!, gruposARemover);

    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      // Em caso de sucesso retornar objeto de grupo de redeiros preenchido.
      return recolhimento;
    }
    else{
      print("ERRO QUE DEU: ${ErrosParse.obterDescricao(response.error!.code)}");
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por iniciar um recolhimento no Parse Server.
  Future<RecolhimentoDmo> iniciarRecolhimento(RecolhimentoDmo recolhimento) async {

    // Alterar informações do recolhimento
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..objectId = recolhimento.id
      ..set<DateTime?>(CAMPO_DATA_INICIADO, recolhimento.dataIniciado);

    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      return recolhimento;
    }
    else{
      print("ERRO QUE DEU: ${ErrosParse.obterDescricao(response.error!.code)}");
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método que busca todos os recolhimentos agendados para uma data específica no Parse Server.
  Future<List<RecolhimentoDmo>> obterRecolhimentosNaData(DateTime data) async{
    // Criando consulta
    final queryBuilder = QueryBuilder(ParseObject(NOME_CLASSE))
      ..whereEqualTo(CAMPO_DATA_RECOLHIMENTO, data);

    // Executar consulta
    final response = await queryBuilder.query();

    if(response.success){
      /// Em caso de sucesso recuperar lista com os recolhimentos.
      List<RecolhimentoDmo> recolhimentos = response.results?.map((e) => RecolhimentoDmo.fromParse(e)).toList() ?? [];

      // Buscar grupos dos recolhimentos
      for(int i = 0; i < recolhimentos.length; i++){
        recolhimentos[i].gruposDoRecolhimento = await obterGruposDoRecolhimento(recolhimentos[i].id!);
      }

      // Retornar recolhimentos com grupos preenchidos
      return recolhimentos;
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método que verifica se existe algum recolhimento agendado para uma data específica no Parse Server.
  Future<bool> validarSeExisteRecolhimentoAgendadoParaAData(DateTime data) async{

    List<RecolhimentoDmo> recolhimentosDaData =
    await obterRecolhimentosNaData(data);

    return !recolhimentosDaData.any((element) => true);
  }

  /// Método responsável por obter a lista de Recolhimentos do Parse Server de forma paginada.
  Future<List<RecolhimentoDmo>> obterListaPaginadaDeRecolhimentos(
      {required int registrosAPular,
      DateTime? filtroDataInicial,
      DateTime? filtroDataFinal,
      required bool incluirRecolhimentosFinalizados}) async{

    // Criando consulta
    final queryBuilder = QueryBuilder(ParseObject(NOME_CLASSE))
      ..setAmountToSkip(registrosAPular)
      ..setLimit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
      ..orderByAscending(CAMPO_DATA_RECOLHIMENTO);

    // Definir filtro de data inicial, caso tenha sido fornecido.
    if(filtroDataInicial != null)
      queryBuilder.whereGreaterThanOrEqualsTo(CAMPO_DATA_RECOLHIMENTO, filtroDataInicial);

    // Definir filtro de data final, caso tenha sido fornecido.
    if(filtroDataFinal != null)
      queryBuilder.whereLessThanOrEqualTo(CAMPO_DATA_RECOLHIMENTO, filtroDataFinal);

    // Definir filtro de incluir recolhimentos finalizados, caso tenha sido fornecido.
    if(!incluirRecolhimentosFinalizados)
      queryBuilder.whereValueExists(CAMPO_DATA_FINALIZADO, true);

    // Executar consulta
    final response = await queryBuilder.query();

    if(response.success){

      // Em caso de sucesso recuperar lista com os recolhimentos.
      List<RecolhimentoDmo> recolhimentos = response.results?.map((e) => RecolhimentoDmo.fromParse(e)).toList() ?? [];

      // Buscar grupos dos recolhimentos
      for(int i = 0; i < recolhimentos.length; i++){
        recolhimentos[i].gruposDoRecolhimento = await obterGruposDoRecolhimento(recolhimentos[i].id!);
      }

      // Retornar recolhimentos com grupos preenchidos
      return recolhimentos;
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por apagar um Recolhimento do Parse Server.
  Future<void> apagarRecolhimento(String idRecolhimento) async {

    // Alterar informações do grupo
    final registroAApagar = ParseObject(NOME_CLASSE)
      ..objectId = idRecolhimento;

    // Gravar dados no Parse Server
    final response = await registroAApagar.delete();

    if(!response.success){
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Obtém os grupos do Redeiro.
  Future<List<GrupoDeRedeirosDmo>> obterGruposDoRecolhimento(String idRecolhimento) async{
    // Montar consulta
    final queryGrupos = QueryBuilder(ParseObject(GrupoDeRedeirosParse.NOME_CLASSE))
      ..whereRelatedTo(RELACIONAMENTO_GRUPOS_DO_RECOLHIMENTO, NOME_CLASSE, idRecolhimento);

    // Executar consulta
    final gruposResponse = await queryGrupos.query();

    if(gruposResponse.success){

      return gruposResponse.results?.map((e) => GrupoDeRedeirosDmo.fromParse(e)).toList() ?? [];
    }
    else{
      if(gruposResponse.error != null)
        return Future.error(ErrosParse.obterDescricao(gruposResponse.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por adicionar grupos ao relacionamento do Recolhimento.
  Future<void> adicionarGruposAoRecolhimento(String idRecolhimento, List<GrupoDeRedeirosDmo> grupoAAdicionar) async{

    // Alterar informações do redeiro
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..objectId = idRecolhimento
      ..addRelation(RELACIONAMENTO_GRUPOS_DO_RECOLHIMENTO,
          grupoAAdicionar.map((e) =>
            ParseObject(GrupoDeRedeirosParse.NOME_CLASSE)
            ..objectId = e.idGrupo
          ).toList());

    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(!response.success){
      print("ERRO QUE DEU: ${ErrosParse.obterDescricao(response.error!.code)}");
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }

  }

  /// Método responsável por REMOVER grupos DO relacionamento do Recolhimento.
  Future<void> removerGruposAoRecolhimento(String idRecolhimento, List<GrupoDeRedeirosDmo> grupoARemover) async{

    // Alterar informações do redeiro
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..objectId = idRecolhimento
      ..removeRelation(RELACIONAMENTO_GRUPOS_DO_RECOLHIMENTO,
          grupoARemover.map((e) =>
          ParseObject(GrupoDeRedeirosParse.NOME_CLASSE)
            ..objectId = e.idGrupo
          ).toList());

    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(!response.success){
      print("ERRO QUE DEU: ${ErrosParse.obterDescricao(response.error!.code)}");
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }

  }
  //#endregion Métodos

}