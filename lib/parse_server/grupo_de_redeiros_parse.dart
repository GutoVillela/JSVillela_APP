import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe "GruposDeRedeiros" do Parse Server.
class GrupoDeRedeirosParse{

  //#region Constantes

  /// Constante que define nome da classe "GruposDeRedeiros" do Parse Server.
  static const String NOME_CLASSE = "GruposDeRedeiros";

  /// Constante que define o campo "objectId" da classe "Recolhimentos" do Parse Server.
  static const String CAMPO_ID_GRUPOS_DE_REDEIROS = "objectId";

  /// Constante que define o campo "nomeGrupo" da classe "Recolhimentos" do Parse Server.
  static const String CAMPO_NOME_GRUPO = "nomeGrupo";

  //#endregion Constantes

  //#region Métodos
  /// Método responsável por cadastrar grupo de redeiros no Parse Server.
  Future<GrupoDeRedeirosDmo> cadastrarGrupoDeRedeiros(String nomeGrupo) async {

    // Definir informações do grupo
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..set<String>(CAMPO_NOME_GRUPO, nomeGrupo);

    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      // Em caso de sucesso retornar objeto de grupo de redeiros preenchido.
      return GrupoDeRedeirosDmo.fromParse((response.result));
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por editar grupo de redeiros no Parse Server.
  Future<GrupoDeRedeirosDmo> editarGrupoDeRedeiros(GrupoDeRedeirosDmo grupo) async {

    // Alterar informações do grupo
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..objectId = grupo.idGrupo
      ..set<String>(CAMPO_NOME_GRUPO, grupo.nomeGrupo);

    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      // Em caso de sucesso retornar objeto de grupo de redeiros preenchido.
      return GrupoDeRedeirosDmo.fromParse((response.result));
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por obter a lista de Grupos de Redeiros do Parse Server de forma paginada.
  Future<List<GrupoDeRedeirosDmo>> obterListaDeGruposPaginadas(int registrosAPular, String? filtroPorNome) async{

    // Criando consulta
    final queryBuilder = QueryBuilder(ParseObject(NOME_CLASSE))
        ..setAmountToSkip(registrosAPular)
        ..setLimit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        ..orderByAscending(CAMPO_NOME_GRUPO);

    // Definir filtro, caso tenha sido fornecido.
    if(filtroPorNome != null)
      queryBuilder.whereStartsWith(CAMPO_NOME_GRUPO, filtroPorNome);

    // Executar consulta
    final response = await queryBuilder.query();

    if(response.success){

      // Em caso de sucesso retornar objeto de grupo de redeiros preenchido.
      if(response.results != null)
        return response.results!.map((e) => GrupoDeRedeirosDmo.fromParse(e)).toList();
      else
        return [];
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por apagar um Grupo de Redeiros do Parse Server.
  Future<void> apagarGrupoDeRedeiros(String idGrupo) async {

    // Alterar informações do grupo
    final registroAApagar = ParseObject(NOME_CLASSE)
      ..objectId = idGrupo;

    // Gravar dados no Parse Server
    final response = await registroAApagar.delete();

    if(!response.success){
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }
  //#endregion Métodos

}