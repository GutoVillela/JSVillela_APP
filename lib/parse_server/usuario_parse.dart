import 'package:jsvillela_app/dml/usuario_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

/// Classe responsável por realizar a conexão com a classe "User" do Parse Server.
class UsuarioParse{

  //#region Constantes

  /// Constante que define o campo "objectId" da classe "User" do Parse Server.
  static const String CAMPO_ID_USUARIO = "objectId";

  /// Constante que define o campo "username" da classe "User" do Parse Server.
  static const String CAMPO_NOME_DE_USUARIO = "username";

  /// Constante que define o campo "email" da classe "User" do Parse Server.
  static const String CAMPO_EMAIL = "email";

  /// Constante que define o campo "tipoDeUsuario" da classe "User" do Parse Server.
  static const String CAMPO_TIPO_DE_USUARIO = "tipoDeUsuario";

  /// Constante que define o campo "telefone" da classe "User" do Parse Server.
  static const String CAMPO_TELEFONE_DO_USUARIO = "telefone";

  /// Constante que define o campo "whatsapp" da classe "User" do Parse Server.
  static const String CAMPO_WHATSAPP = "whatsapp";

  //#endregion Constantes

  //#region Métodos
  /// Método responsável por cadastrar usuário no Parse Server.
  Future<UsuarioDmo> cadastrarUsuario(UsuarioDmo usuario) async {

    // Informações de login do usuário
    final parseUser = ParseUser(
        usuario.usuario,
        usuario.senha,
        usuario.email
    )
    // Demais informações do usuário
    ..set<int>(CAMPO_TIPO_DE_USUARIO, usuario.tipoDeUsuario.index)
    ..set<String>(CAMPO_TELEFONE_DO_USUARIO, usuario.telefone)
    ..set<bool>(CAMPO_WHATSAPP, usuario.whatsapp);

    // Criar usuário no Parse Server
    final response = await parseUser.signUp();
    
    if(response.success){
      // Em caso de sucesso retornar objeto de usuário preenchido.
      return _converterParseEmUsuario(response.result);
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Realiza o login do usuário no Parse Server usando usuário e senha.
  Future<UsuarioDmo> logarUsuario(String usuario, String senha) async{

    // Criar objeto Parse User para logar usuário
    final parseUser = ParseUser(usuario, senha, null);

    // Realizar login do usuário
    final response = await parseUser.login();

    if(response.success){
      // Em caso de sucesso retornar objeto de usuário preenchido.
      return _converterParseEmUsuario(response.result);
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método que converte objeto do Parse Server em um objeto UsuarioDmo.
  UsuarioDmo _converterParseEmUsuario(ParseUser usuarioParse){
    return UsuarioDmo(
        usuario: usuarioParse.get(CAMPO_NOME_DE_USUARIO),
        senha: usuarioParse.get(CAMPO_EMAIL),
        telefone: usuarioParse.get(CAMPO_TELEFONE_DO_USUARIO),
        whatsapp: usuarioParse.get(CAMPO_WHATSAPP),
        tipoDeUsuario: TipoDeUsuario.values[usuarioParse.get(CAMPO_TIPO_DE_USUARIO)],
        id: usuarioParse.objectId
    );
  }
  //#endregion Métodos
}