import 'package:jsvillela_app/parse_server/avisos_do_usuario_parse.dart';
import 'package:jsvillela_app/infra/enums.dart';

/// Classe modelo para Avisos do Usuário.
class AvisoDoUsuarioDmo {

  //#region Atributos

  String idAvisoDoUsuario;

  /// Título do aviso.
  String titulo;

  /// Texto do aviso.
  String texto;

  /// Tipo de aviso.
  TiposDeAviso tipo;

  /// Data e hora de leitura do aviso.
  DateTime? dtHrLido;

  /// Data e hora que o aviso foi dispensado.
  DateTime? dtHrDescartado;
  //#endregion Atributos

  //#region Construtor(es)
  AvisoDoUsuarioDmo({required this.idAvisoDoUsuario, required this.titulo, required this.texto, required this.tipo});

  /// Construtor que inicializa objetos de acordo com um mapa vindo do Parse Server.
  AvisoDoUsuarioDmo.fromMap(Map<String, dynamic> mapa) :
        idAvisoDoUsuario = mapa[AvisosDoUsuarioParse.CAMPO_ID_AVISOS],
        titulo = mapa[AvisosDoUsuarioParse.CAMPO_AVISO][AvisosDoUsuarioParse.CAMPO_AVISO_TITULO],
        texto = mapa[AvisosDoUsuarioParse.CAMPO_AVISO][AvisosDoUsuarioParse.CAMPO_AVISO_TEXTO],
        tipo = TiposDeAviso.values[int.tryParse(mapa[AvisosDoUsuarioParse.CAMPO_AVISO][AvisosDoUsuarioParse.CAMPO_AVISO_TIPO].toString()) ?? 0],
        dtHrLido = DateTime.tryParse(mapa[AvisosDoUsuarioParse.CAMPO_DTHR_LIDO] ?? ""),
        dtHrDescartado = DateTime.tryParse(mapa[AvisosDoUsuarioParse.CAMPO_DTHR_DESCARTADO] ?? "")
  ;
  //#endregion Construtor(es)

  //#region Métodos
  @override
  String toString() {
    return 'AvisoDmo(titulo: $titulo, texto: $texto, tipo: $tipo)';
  }
//#endregion Métodos
}