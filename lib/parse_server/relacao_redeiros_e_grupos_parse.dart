import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/parse_server/grupo_de_redeiros_parse.dart';
import 'package:jsvillela_app/parse_server/redeiro_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe entidade-relacional "RedeirosEGrupos" do Parse Server.
class RedeirosEGruposParse{

  //#region Constantes

  /// Constante que define nome da classe entidade-relacional "RedeirosEGrupos" do Parse Server.
  static const String NOME_CLASSE = "RedeirosEGrupos";

  /// Constante que define o campo "objectId" da classe entidade-relacional "RedeirosEGrupos" do Parse Server.
  static const String CAMPO_ID_RELACAO_REDEIRO_GRUPO = "objectId";

  /// Constante que define o campo que serve como chave extrangeira com a entidade "Redeiros" da entidade-relacional "RedeirosEGrupos" do Parse Server.
  static const String RELACAO_REDEIRO = "redeiro";

  /// Constante que define o campo que serve como chave extrangeira com a entidade "GruposDeRedeiros" da entidade-relacional "RedeirosEGrupos" do Parse Server.
  static const String RELACAO_GRUPO = "grupo";

  //#endregion Constantes

  //#region Métodos
  /// Método responsável por cadastrar um novo registro na entidade relacional entre Redeiros e Grupos no Parse Server.
  Future<void> cadastrarRelacaoRedeiroGrupos(String idRedeiro, List<String> idGrupos) async {

    for(int i = 0; i < idGrupos.length; i++){
      // Definir informações do grupo
      final relacaoGrupos = ParseObject(NOME_CLASSE)
        ..set(RELACAO_REDEIRO, (ParseObject(RedeiroParse.NOME_CLASSE)..objectId = idRedeiro).toPointer())
        ..set(RELACAO_GRUPO, (ParseObject(GrupoDeRedeirosParse.NOME_CLASSE)..objectId = idGrupos[i]).toPointer());

      // Gravar dados no Parse Server
      final response = await relacaoGrupos.save();

      if(!response.success){
        if(response.error != null)
          return Future.error(ErrosParse.obterDescricao(response.error!.code));
        else
          return Future.error("Aconteceu um erro inesperado!");
      }
    }
  }

  /// Remove os grupos associados com o Redeiro.
  Future<void> removerGruposDoRedeiro(String idRedeiro, List<GrupoDeRedeirosDmo> gruposARemover) async{

    // Montar query para consultar dados a serem apagados
    final dadosAApagar = QueryBuilder(ParseObject(NOME_CLASSE))
        ..whereEqualTo(RELACAO_REDEIRO, ParseObject(RedeiroParse.NOME_CLASSE)..objectId = idRedeiro)
        ..whereContainedIn(RELACAO_GRUPO, gruposARemover.map((e) => ParseObject(GrupoDeRedeirosParse.NOME_CLASSE)..objectId = e.idGrupo).toList());

    // Executar consulta dos registros
    final response = await dadosAApagar.query();

    if(!response.success){
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }

    if(response.results == null)
      return;

    // Executar comandos para deletar grupos
    for(int i = 0; i < response.results!.length; i++){

      final apagar = ParseObject(NOME_CLASSE)..objectId = (response.results![i] as ParseObject).objectId;

      final apagarResponse = await apagar.delete();

      if(!apagarResponse.success){
        if(apagarResponse.error != null)
          return Future.error(ErrosParse.obterDescricao(apagarResponse.error!.code));
        else
          return Future.error("Aconteceu um erro inesperado!");
      }
    }

  }

  /// Obtém os grupos do Redeiro.
  Future<List<GrupoDeRedeirosDmo>> obterGruposDoRedeiro(String idRedeiro) async{
    // Montar consulta
    final queryGrupos = QueryBuilder(ParseObject(NOME_CLASSE))
      ..whereEqualTo(RELACAO_REDEIRO, ParseObject(RedeiroParse.NOME_CLASSE)..objectId = idRedeiro)
      ..includeObject([RELACAO_GRUPO]);

    // Executar consulta
    final gruposResponse = await queryGrupos.query();

    if(gruposResponse.success && gruposResponse.results != null){
      return gruposResponse.results!.map((e) => GrupoDeRedeirosDmo.fromParse(e.get<ParseObject>(RELACAO_GRUPO))).toList();
    }
    else{
      if(gruposResponse.error != null)
        return Future.error(ErrosParse.obterDescricao(gruposResponse.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Obtém os redeiros que estão relacionadas aos grupos de redeiros.
  Future<List<RedeiroDmo>> obterRedeirosAPartirDosGrupos(List<GrupoDeRedeirosDmo> listaDeGrupos) async{

    // Montar query para consultar dados a serem apagados
    final query = QueryBuilder(ParseObject(NOME_CLASSE))
      ..whereValueExists(RELACAO_REDEIRO, true)
      ..whereContainedIn(RELACAO_GRUPO, listaDeGrupos.map((e) => ParseObject(GrupoDeRedeirosParse.NOME_CLASSE)..objectId = e.idGrupo).toList())
      ..includeObject([RELACAO_REDEIRO]);

    // Executar consulta dos registros
    final response = await query.query();

    if(response.success){
      return response.results?.map((e) => RedeiroDmo.fromParse(e.get<ParseObject>(RELACAO_REDEIRO))).toList() ?? [];
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }
  //#endregion Métodos

}