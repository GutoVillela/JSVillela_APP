import 'package:geolocator/geolocator.dart';
import 'package:jsvillela_app/dml/endereco_dmo.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/grupo_de_redeiros_parse.dart';
import 'package:jsvillela_app/parse_server/redeiro_parse.dart';
import 'package:jsvillela_app/parse_server/redeiros_do_recolhimento_parse.dart';
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
  Future<List<RedeiroDoRecolhimentoDmo>> iniciarRecolhimento(String idRecolhimento) async {

    // Cloud Function responsável por processar o início do recolhimento
    final cloudFunction = ParseCloudFunction('iniciarRecolhimento');
    final parametros = { 'idRecolhimento' : idRecolhimento };

    try{

      // Executar Função pelo Servidor
      final response = await cloudFunction.execute(parameters: parametros);

      if(response.success){
        return  (response.result as List).map((e) => RedeiroDoRecolhimentoDmo(
          id: e[RedeirosDoRecolhimentoParse.CAMPO_ID_RELACAO_REDEIRO_GRUPO],
          redeiro: RedeiroDmo(
            id: e[RedeirosDoRecolhimentoParse.RELACAO_REDEIRO][RedeiroParse.CAMPO_ID_REDEIRO],
            nome: e[RedeirosDoRecolhimentoParse.RELACAO_REDEIRO][RedeiroParse.CAMPO_NOME],
            endereco: EnderecoDmo(
              logradouro: e[RedeirosDoRecolhimentoParse.RELACAO_REDEIRO][RedeiroParse.CAMPO_NOME],
              numero: e[RedeirosDoRecolhimentoParse.RELACAO_REDEIRO][RedeiroParse.CAMPO_ENDERECO_NUMERO] ?? "",
              bairro: e[RedeirosDoRecolhimentoParse.RELACAO_REDEIRO][RedeiroParse.CAMPO_ENDERECO_BAIRRO] ?? "",
              cidade: e[RedeirosDoRecolhimentoParse.RELACAO_REDEIRO][RedeiroParse.CAMPO_ENDERECO_CIDADE] ?? "",
              cep: e[RedeirosDoRecolhimentoParse.RELACAO_REDEIRO][RedeiroParse.CAMPO_ENDERECO_CEP] ?? "",
              complemento: e[RedeirosDoRecolhimentoParse.RELACAO_REDEIRO][RedeiroParse.CAMPO_ENDERECO_COMPLEMENTO] ?? "",
              posicao: Position(
                  latitude: e[RedeirosDoRecolhimentoParse.RELACAO_REDEIRO][RedeiroParse.CAMPO_ENDERECO_POSICAO]['latitude'],
                  longitude: e[RedeirosDoRecolhimentoParse.RELACAO_REDEIRO][RedeiroParse.CAMPO_ENDERECO_POSICAO]['longitude'],
                  timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0
              )
            ),
            gruposDoRedeiro: []
          )
        )).toList();
      }
      else{
        print("ERRO QUE DEU: ${ErrosParse.obterDescricao(response.error!.code)}");
        if(response.error != null)
          return Future.error(ErrosParse.obterDescricao(response.error!.code));
        else
          return Future.error("Aconteceu um erro inesperado!");
      }
    }catch(ex){
      return Future.error(ex);
    }
  }

  /// Método responsável por terminar um recolhimento no Parse Server.
  Future<RecolhimentoDmo> terminarRecolhimento(String idRecolhimento, DateTime dataFinalizacao) async {

    // Definir informações do recolhimento
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..objectId = idRecolhimento
      ..set<DateTime?>(CAMPO_DATA_FINALIZADO, dataFinalizacao);

    // Criar usuário no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      // Em caso de sucesso recuperar ID do recolhimento
      return RecolhimentoDmo.fromParse(response.result as ParseObject);
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  // /// Método que busca todos os recolhimentos agendados para uma data específica no Parse Server.
  // Future<List<RecolhimentoDmo>> obterRecolhimentosNaData(DateTime data) async{
  //   // Criando consulta
  //   final queryBuilder = QueryBuilder(ParseObject(NOME_CLASSE))
  //     ..whereEqualTo(CAMPO_DATA_RECOLHIMENTO, data);
  //
  //   // Executar consulta
  //   final response = await queryBuilder.query();
  //
  //   if(response.success){
  //     /// Em caso de sucesso recuperar lista com os recolhimentos.
  //     List<RecolhimentoDmo> recolhimentos = response.results?.map((e) => RecolhimentoDmo.fromParse(e)).toList() ?? [];
  //
  //     // Buscar grupos dos recolhimentos
  //     for(int i = 0; i < recolhimentos.length; i++){
  //       recolhimentos[i].gruposDoRecolhimento = await obterGruposDoRecolhimento(recolhimentos[i].id!);
  //     }
  //
  //     // Retornar recolhimentos com grupos preenchidos
  //     return recolhimentos;
  //   }
  //   else{
  //     if(response.error != null)
  //       return Future.error(ErrosParse.obterDescricao(response.error!.code));
  //     else
  //       return Future.error("Aconteceu um erro inesperado!");
  //   }
  // }

  /// Converte o JSON recebido da Cloud Function em um RedeiroDmo
  RedeiroDmo obterRedeiroDoJSON(Map<String, dynamic> json){
    return RedeiroDmo(
        id: json['redeiro'][RedeiroParse.CAMPO_ID_REDEIRO],
        nome: json['redeiro'][RedeiroParse.CAMPO_NOME],
        endereco: EnderecoDmo(
            logradouro: json['redeiro'][RedeiroParse.CAMPO_NOME],
            numero: json['redeiro'][RedeiroParse.CAMPO_ENDERECO_NUMERO] ?? "",
            bairro: json['redeiro'][RedeiroParse.CAMPO_ENDERECO_BAIRRO] ?? "",
            cidade: json['redeiro'][RedeiroParse.CAMPO_ENDERECO_CIDADE] ?? "",
            cep: json['redeiro'][RedeiroParse.CAMPO_ENDERECO_CEP] ?? "",
            complemento: json['redeiro'][RedeiroParse.CAMPO_ENDERECO_COMPLEMENTO] ?? "",
            posicao: Position(
                latitude: json['redeiro'][RedeiroParse.CAMPO_ENDERECO_POSICAO]['latitude'],
                longitude: json['redeiro'][RedeiroParse.CAMPO_ENDERECO_POSICAO]['longitude'],
                timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0
            )
        ),
        gruposDoRedeiro: []
    );
  }

  /// Método que busca todos os recolhimentos agendados para uma data específica no Parse Server.
  Future<List<RecolhimentoDmo>> obterRecolhimentosNaData(DateTime data) async{

    // Cloud Function responsável por processar o início do recolhimento
    final cloudFunction = ParseCloudFunction('buscarRecolhimentoNaData');
    final parametros = { 'dataDoRecolhimento' :  data.toUtc().toIso8601String() };

    try{

      // Executar Função pelo Servidor
      final response = await cloudFunction.execute(parameters: parametros);

      if(response.success){

        if(response.result == null || response.result.length < 1)
          return [];

        print('TESXTE FEITO =============================== ${response.result['recolhimento'][RecolhimentoParse.CAMPO_DATA_RECOLHIMENTO]['iso']}');
        DateTime teste = DateTime.parse(response.result['recolhimento'][RecolhimentoParse.CAMPO_DATA_RECOLHIMENTO]['iso']);
        print('TESXTE DATA FEITO =============================== ${teste.toString()}');

        //Montar recolhimento
        RecolhimentoDmo recolhimento = RecolhimentoDmo(
          id: response.result['recolhimento'][RecolhimentoParse.CAMPO_ID_RECOLHIMENTO],
          dataDoRecolhimento: DateTime.parse(response.result['recolhimento'][RecolhimentoParse.CAMPO_DATA_RECOLHIMENTO]['iso']),
          dataIniciado: DateTime.tryParse(response.result['recolhimento'][RecolhimentoParse.CAMPO_DATA_INICIADO]?['iso'] ?? ""),
          dataFinalizado: DateTime.tryParse(response.result['recolhimento'][RecolhimentoParse.CAMPO_DATA_FINALIZADO]?['iso'] ?? ""),
          gruposDoRecolhimento: (response.result[RecolhimentoParse.RELACIONAMENTO_GRUPOS_DO_RECOLHIMENTO] as List).map((e) =>
              GrupoDeRedeirosDmo(
                  idGrupo: e[GrupoDeRedeirosParse.CAMPO_ID_GRUPOS_DE_REDEIROS],
                  nomeGrupo: e[GrupoDeRedeirosParse.CAMPO_NOME_GRUPO]
              )
          ).toList(),
        );

        recolhimento.redeirosDoRecolhimento = (response.result['redeirosDoRecolhimento'] as List).map((e) =>
            RedeiroDoRecolhimentoDmo(
              id: e[RedeirosDoRecolhimentoParse.CAMPO_ID_RELACAO_REDEIRO_GRUPO],
              redeiro: obterRedeiroDoJSON(e),
              dataFinalizacao: DateTime.tryParse(e[RedeirosDoRecolhimentoParse.CAMPO_DATA_FINALIZADO]?['iso'] ?? "")
            ),
        ).toList();
        return  [recolhimento];
      }
      else{
        if(response.error != null)
          return Future.error(ErrosParse.obterDescricao(response.error!.code));
        else
          return Future.error("Aconteceu um erro inesperado!");
      }
    }catch(ex){
      return Future.error(ex);
    }
  }

  /// Método que verifica se existe algum recolhimento agendado para uma data específica no Parse Server.
  Future<bool> validarSeExisteRecolhimentoAgendadoParaAData(DateTime data) async{

    List<RecolhimentoDmo> recolhimentosDaData =
    await obterRecolhimentosNaData(data);

    print('VÁLIDO ================================================== ${!recolhimentosDaData.any((element) => true)}');
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