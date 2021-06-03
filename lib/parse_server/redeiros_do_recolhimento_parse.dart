import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/parse_server/recolhimento_parse.dart';
import 'package:jsvillela_app/parse_server/redeiro_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe entidade-relacional "RedeirosDoRecolhimento" do Parse Server.
class RedeirosDoRecolhimentoParse{

  //#region Constantes

  /// Constante que define nome da classe entidade-relacional "RedeirosDoRecolhimento" do Parse Server.
  static const String NOME_CLASSE = "RedeirosDoRecolhimento";

  /// Constante que define o campo "objectId" da classe entidade-relacional "RedeirosDoRecolhimento" do Parse Server.
  static const String CAMPO_ID_RELACAO_REDEIRO_GRUPO = "objectId";

  /// Constante que define o campo que serve como chave extrangeira com a entidade "Redeiros" da entidade-relacional "RedeirosDoRecolhimento" do Parse Server.
  static const String RELACAO_REDEIRO = "redeiro";

  /// Constante que define o campo que serve como chave extrangeira com a entidade "Recolhimentos" da entidade-relacional "RedeirosDoRecolhimento" do Parse Server.
  static const String RELACAO_RECOLHIMENTO = "recolhimento";

  /// Constante que define o campo "dataFinalizado" da classe entidade-relacional "RedeirosDoRecolhimento" do Parse Server.
  static const String CAMPO_DATA_FINALIZADO = "dataFinalizado";

  //#endregion Constantes

  //#region Métodos
  /// Método responsável por cadastrar os redeiros do recolhimento no Parse Server.
  Future<List<RedeiroDoRecolhimentoDmo>> cadastrarRedeirosDoRecolhimento(String idRecolhimento, List<RedeiroDoRecolhimentoDmo> redeiros) async {


    for(int i = 0; i < redeiros.length; i++){
      // Definir informações do grupo
      final dadosACadastrar = ParseObject(NOME_CLASSE)
        ..set(RELACAO_RECOLHIMENTO, (ParseObject(RecolhimentoParse.NOME_CLASSE)..objectId = idRecolhimento).toPointer())
        ..set(RELACAO_REDEIRO, (ParseObject(RedeiroParse.NOME_CLASSE)..objectId = redeiros[i].redeiro!.id!).toPointer());

      // Gravar dados no Parse Server
      final response = await dadosACadastrar.save();

      if(!response.success){
        if(response.error != null)
          return Future.error(ErrosParse.obterDescricao(response.error!.code));
        else
          return Future.error("Aconteceu um erro inesperado!");
      }

      redeiros[i].id = (response.result as ParseObject).objectId;
    }

    return redeiros;
  }

  /// Método responsável por carregar os redeiros do recolhimento no Parse Server.
  Future<List<RedeiroDoRecolhimentoDmo>> carregarRedeirosDoRecolhimento(String idRecolhimento) async{
    // Montar consulta
    final queryGrupos = QueryBuilder(ParseObject(NOME_CLASSE))
      ..whereEqualTo(RELACAO_RECOLHIMENTO, ParseObject(RedeiroParse.NOME_CLASSE)..objectId = idRecolhimento)
      ..includeObject([RELACAO_REDEIRO]);

    // Executar consulta
    final gruposResponse = await queryGrupos.query();

    if(gruposResponse.success){
      return gruposResponse.results?.map((e) => RedeiroDoRecolhimentoDmo.fromParse(e)).toList() ?? [];
    }
    else{
      if(gruposResponse.error != null)
        return Future.error(ErrosParse.obterDescricao(gruposResponse.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por finalizar o recolhimento do redeiro no Parse Server.
  Future<RedeiroDoRecolhimentoDmo?> finalizarRecolhimentoDoRedeiro(
      {required String idRedeiroDoRecolhimento, required DateTime dataFinalizacao}) async {

    // Definir informações do grupo
    final dadosACadastrar = ParseObject(NOME_CLASSE)
      ..objectId = idRedeiroDoRecolhimento
      ..set<DateTime>(CAMPO_DATA_FINALIZADO, dataFinalizacao);

    // Gravar dados no Parse Server
    final response = await dadosACadastrar.save();

    if(response.success){
      return RedeiroDoRecolhimentoDmo.fromParse(response.result);
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