import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/solicitacao_do_redeiro_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe "SolicitacoesDosRedeiros" do Parse Server.
class SolicitacoesDosRedeirosParse{

  //#region Constantes

  /// Constante que define nome da classe "SolicitacoesDosRedeiros" do Parse Server.
  static const String NOME_CLASSE = "SolicitacoesDosRedeiros";

  /// Constante que define o campo "objectId" da classe "SolicitacoesDosRedeiros" do Parse Server.
  static const String CAMPO_ID = "objectId";

  /// Nome do identificador para o campo "redeiroSolicitante" utilizado na collection do Firebase.
  static const String RELACAO_REDEIRO_SOLICITANTE = "redeiroSolicitante";

  /// Constante que define o campo "dataSolicitacao" da classe "SolicitacoesDosRedeiros" do Parse Server.
  static const String CAMPO_DATA_SOLICITACAO = "dataSolicitacao";

  /// Constante que define o campo "dataFinalizacao" da classe "SolicitacoesDosRedeiros" do Parse Server.
  static const String CAMPO_DATA_FINALIZACAO = "dataFinalizacao";

  /// Constante que define o campo "materiaisSolicitados" da classe "SolicitacoesDosRedeiros" do Parse Server.
  static const String RELACAO_MATERIAIS_SOLICITADOS = "materiaisSolicitados";

  //#endregion Constantes

  //#region Métodos
  /// Método responsável por obter a lista de Grupos de Redeiros do Parse Server de forma paginada.
  Future<List<SolicitacaoDoRedeiroDmo>> obterListaPaginadaDeSolicitacoes(int registrosAPular) async{

    // Criando consulta
    final queryBuilder = QueryBuilder(ParseObject(NOME_CLASSE))
      ..setAmountToSkip(registrosAPular)
      ..setLimit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
      ..orderByAscending(CAMPO_DATA_SOLICITACAO);

    // Executar consulta
    final response = await queryBuilder.query();

    if(response.success){

      // Em caso de sucesso retornar objeto de grupo de redeiros preenchido.
      if(response.results != null)
        return response.results!.map((e) => SolicitacaoDoRedeiroDmo.fromParse(e)).toList();
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

//#endregion Métodos

}