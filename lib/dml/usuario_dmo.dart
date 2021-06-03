import 'package:jsvillela_app/infra/enums.dart';

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

}