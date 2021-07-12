import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/solicitacao_de_materia_prima_dmo.dart';
import 'package:jsvillela_app/dml/materia_prima_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe "SolicitacaoDeMateriaPrima" do Parse Server.
class SolicitacaoDeMateriaPrimaParse{

  //#region Constantes

  /// Constante que define nome da classe "SolicitacaoDeMateriaPrima" do Parse Server.
  static const String NOME_CLASSE = "SolicitacaoDeMateriaPrima";

  /// Constante que define o campo "objectId" da classe "SolicitacaoDeMateriaPrima" do Parse Server.
  static const String CAMPO_ID_SOLICITACOES = "objectId";

  /// Constante que define a relação "materiasPrimas" da classe "SolicitacaoDeMateriaPrima" do Parse Server.
  static const String RELACAO_MATERIAS_PRIMAS = "materiasPrimas";

  /// Constante que define o campo "redeiro" da classe "SolicitacaoDeMateriaPrima" do Parse Server.
  static const String RELACAO_REDEIRO = "redeiro";

  /// Constante que define o campo "createdAt" da classe "SolicitacaoDeMateriaPrima" do Parse Server.
  static const String CAMPO_DTHR_SOLICITACAO = "createdAt";

  /// Constante que define o campo "dtHrAtendido" da classe "SolicitacaoDeMateriaPrima" do Parse Server.
  static const String CAMPO_DTHR_ATENDIDO = "dtHrAtendido";

  //#endregion Constantes

  //#region Métodos

  /// Método responsável por buscar solicitações do redeiro não atendidas no Parse Server.
  Future<List<SolicitacaoDeMateriaPrimaDmo>> buscarSolicitacoesNaoAtendidas({required int registrosAPular}) async {

    // Cloud Function
    final cloudFunction = ParseCloudFunction('buscarSolicitacoesNaoAtendidas');
    final parametros = { 'registrosAPular' : registrosAPular, 'totalDeRegistros' : Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING };

    try{

      // Executar Função pelo Servidor
      final response = await cloudFunction.execute(parameters: parametros);

      if(response.success){

        if(response.result == null || response.result.length < 1)
          return [];

       return (response.result as List).map((e) => SolicitacaoDeMateriaPrimaDmo.fromMap(e)).toList();
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

  /// Método responsável por obter a lista de Solicitações de Matéria-Prima do Parse Server de forma paginada.
  Future<List<SolicitacaoDeMateriaPrimaDmo>> obterListaPaginadaDeSolicitacoes(
      {required int registrosAPular,
        String? filtroNomeRedeiro,
        required bool incluirSolicitacoesAtendidas}) async{

    // Cloud Function responsável por buscar os recolhimentos.
    final cloudFunction = ParseCloudFunction('obterListaPaginadaDeSolicitacoes');
    final parametros = {
      'registrosAPular' :  registrosAPular,
      'totalDeRegistros' : Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING,
      'filtroNomeRedeiro' : filtroNomeRedeiro,
      'incluirSolicitacoesAtendidas' : incluirSolicitacoesAtendidas
    };

    try{

      // Executar Função pelo Servidor
      final response = await cloudFunction.execute(parameters: parametros);

      if(response.success){

        if(response.result == null || response.result.length < 1)
          return [];

        return (response.result as List).map((e) => SolicitacaoDeMateriaPrimaDmo.fromMap(e)).toList();
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
//#endregion Métodos

}