import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/parse_server/usuario_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

/// Classe modelo para Usuários.
class UsuarioDmo{

  //#region Construtor(es)
  UsuarioDmo({
    required this.usuario,
    required this.senha,
    required this.telefone,
    required this.whatsapp,
    required this.tipoDeUsuario,
    this.email,
    this.id
  });

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  UsuarioDmo.fromParse(ParseObject parseObject) :
        usuario = parseObject.get(UsuarioParse.CAMPO_NOME_DE_USUARIO),
        email = parseObject.get(UsuarioParse.CAMPO_EMAIL) ?? "",
        senha = "",
        telefone= parseObject.get(UsuarioParse.CAMPO_TELEFONE_DO_USUARIO),
        whatsapp= parseObject.get(UsuarioParse.CAMPO_WHATSAPP),
        tipoDeUsuario= TipoDeUsuario.values[parseObject.get(UsuarioParse.CAMPO_TIPO_DE_USUARIO)],
        id= parseObject.objectId
  ;
  //#endregion Construtor(es)

  //#region Atributos

  /// Nome de usuário.
  String usuario;

  /// Senha do usuário.
  String senha;

  /// Telefone do usuário.
  String telefone;

  /// Define se telefone do usuário é compatível com WhatsApp.
  bool whatsapp;

  /// Tipo de usuário a ser cadastrado.
  TipoDeUsuario tipoDeUsuario;

  /// E-mail do usuário.
  String? email;

  /// ID do usuário.
  String? id;

  //#endregion Atributos

//#region Métodos
@override
  String toString() {
    return 'UsuarioDmo(usuario: $usuario, senha: $senha, telefone: $telefone, whatsapp: $whatsapp, tipoDeUsuario: ${tipoDeUsuario.index}, email: $email, id: $id);';
  }
//#endregion Métodos

}