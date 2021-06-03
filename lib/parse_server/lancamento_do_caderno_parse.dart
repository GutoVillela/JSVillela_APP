import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/lancamento_do_caderno_dml.dart';
import 'package:jsvillela_app/dml/rede_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/rede_parse.dart';
import 'package:jsvillela_app/parse_server/relacao_redeiros_e_grupos_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe "LancamentoDoCaderno" do Parse Server.
class LancamentoDoCadernoParse{

  //#region Constantes

  /// Constante que define nome da classe "Recolhimentos" do Parse Server.
  static const String NOME_CLASSE = "LancamentoDoCaderno";

  /// Constante que define o campo "objectId" da classe "LancamentoDoCaderno" do Parse Server.
  static const String CAMPO_ID_LANCAMENTO = "objectId";

  /// Constante que define o campo "rede" da classe "LancamentoDoCaderno" do Parse Server.
  static const String CAMPO_REDE = "rede";

  /// Constante que define o campo "redeiro" da classe "LancamentoDoCaderno" do Parse Server.
  static const String CAMPO_REDEIRO = "redeiro";

  /// Constante que define o campo "quantidade" da classe "LancamentoDoCaderno" do Parse Server.
  static const String CAMPO_QUANTIDADE = "quantidade";

  /// Constante que define o campo "valor_unitario" da classe "LancamentoDoCaderno" do Parse Server.
  static const String CAMPO_VALOR_UNITARIO = "valorUnitario";

  /// Constante que define o campo "data_lancamento" da classe "LancamentoDoCaderno" do Parse Server.
  static const String CAMPO_DATA_LANCAMENTO = "dataLancamento";

  /// Constante que define o campo "quantidade" da classe "LancamentoDoCaderno" do Parse Server.
  static const String CAMPO_DATA_PAGAMENTO = "dataPagamento";

  /// Constante que define o campo "quantidade" da classe "LancamentoDoCaderno" do Parse Server.
  static const String CAMPO_DATA_CONFIRMACAO_PAGAMENTO ="dataConfirmacaoPagamento";
  //#endregion Constantes

  //#region Métodos
  /// Método responsável por cadastrar um novo lançamento no caderno do Redeiro no Parse Server.
  Future<LancamentoDoCadernoDmo> cadastrarLancamento({
    required String idRedeiro,
    required String idRede,
    required int quantidade,
    required double valorUnitario,
    required DateTime dataLancamento}) async {

    // Cloud Function
    final cloudFunction = ParseCloudFunction('cadastrarLancamentoNoCaderno');
    final parametros = {
      'idRedeiro' : idRedeiro,
      'idRede' : idRede,
      'quantidade' : quantidade,
      'valorUnitario' : valorUnitario,
      'dataLancamento' : dataLancamento.toUtc().toIso8601String()
    };

    try{

      // Executar Função pelo Servidor
      final response = await cloudFunction.execute(parameters: parametros);

      if(response.success){
        return LancamentoDoCadernoDmo.fromMap(response.result);
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

  /// Método responsável por cadastrar um novo lançamento no caderno do Redeiro no Parse Server.
  Future<List<LancamentoDoCadernoDmo>> buscarCadernoDoRedeiro({
    required String idRedeiro}) async {

    // Cloud Function
    final cloudFunction = ParseCloudFunction('buscarLancamentosDoRedeiro');
    final parametros = { 'idRedeiro' : idRedeiro };

    try{

      // Executar Função pelo Servidor
      final response = await cloudFunction.execute(parameters: parametros);

      if(response.success){

        if(response.result == null || response.result.length < 1)
          return [];

        return (response.result as List).map((e) => LancamentoDoCadernoDmo.fromMap(e)).toList();
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

  /// Método responsável por processar pagamento de uma lista de lançamentos no caderno do Redeiro no Parse Server.
  Future<List<LancamentoDoCadernoDmo>> pagarListaDeLancamentos({
    required List<String> idLancamentos}) async {

    // Cloud Function
    final cloudFunction = ParseCloudFunction('pagarLancamentos');
    final parametros = { 'lancamentos' : idLancamentos };

    try{

      // Executar Função pelo Servidor
      final response = await cloudFunction.execute(parameters: parametros);

      if(response.success){

        if(response.result == null || response.result.length < 1)
          return [];

        return (response.result as List).map((e) => LancamentoDoCadernoDmo.fromMap(e)).toList();
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
  //#endregion Métodos

}