import 'package:jsvillela_app/dml/aviso_do_usuario_dmo.dart';
import 'package:jsvillela_app/dml/lancamento_do_caderno_dml.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe "AvisosDosUsuarios" do Parse Server.
class AvisosDoUsuarioParse{

  //#region Constantes

  /// Constante que define nome da classe "AvisosDosUsuarios" do Parse Server.
  static const String NOME_CLASSE = "AvisosDosUsuarios";

  /// Constante que define o campo "objectId" da classe "AvisosDosUsuarios" do Parse Server.
  static const String CAMPO_ID_AVISOS = "objectId";

  /// Constante que define o campo "usuario" da classe "AvisosDosUsuarios" do Parse Server.
  static const String CAMPO_USUARIO = "usuario";

  /// Constante que define o campo "aviso" da classe "AvisosDosUsuarios" do Parse Server.
  static const String CAMPO_AVISO = "aviso";

  /// Constante que define o campo "aviso" da classe "AvisosDosUsuarios" do Parse Server.
  static const String CAMPO_AVISO_TITULO = "titulo";

  /// Constante que define o campo "aviso" da classe "AvisosDosUsuarios" do Parse Server.
  static const String CAMPO_AVISO_TEXTO = "texto";

  /// Constante que define o campo "tipo" da classe "AvisosDosUsuarios" do Parse Server.
  static const String CAMPO_AVISO_TIPO = "tipo";

  /// Constante que define o campo "dtHrLido" da classe "AvisosDosUsuarios" do Parse Server.
  static const String CAMPO_DTHR_LIDO = "dtHrLido";

  /// Constante que define o campo "dtHrDescartado" da classe "AvisosDosUsuarios" do Parse Server.
  static const String CAMPO_DTHR_DESCARTADO= "dtHrDescartado";
  //#endregion Constantes

  //#region Métodos
  /// Método responsável por buscar os avisos do usuário no Parse Server.
  Future<List<AvisoDoUsuarioDmo>> buscarAvisosDoUsuario({
    required String idUsuario}) async {

    // Cloud Function
    final cloudFunction = ParseCloudFunction('buscarAvisosDoUsuario');
    final parametros = { 'idUsuario' : idUsuario };

    try{

      // Executar Função pelo Servidor
      final response = await cloudFunction.execute(parameters: parametros);

      if(response.success){

        if(response.result == null || response.result.length < 1)
          return [];

        return (response.result as List).map((e) => AvisoDoUsuarioDmo.fromMap(e)).toList();
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

  /// Método responsável por descartar aviso do usuário no Parse Server.
  Future<AvisoDoUsuarioDmo> descartarAviso({ required String idAvisoDoUsuario}) async {

    // Cloud Function
    final cloudFunction = ParseCloudFunction('descartarAviso');
    final parametros = { 'idAvisoDoUsuario' : idAvisoDoUsuario };

    try{

      // Executar Função pelo Servidor
      final response = await cloudFunction.execute(parameters: parametros);

      if(response.success){

        return AvisoDoUsuarioDmo.fromMap((response.result as List).first);

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