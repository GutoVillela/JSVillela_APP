import 'package:jsvillela_app/dml/base_dmo.dart';
import 'package:jsvillela_app/dml/endereco_dmo.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/parse_server/redeiro_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

/// Classe modelo para redeiros.
class RedeiroDmo implements BaseDmo{

  //#region Atributos

  /// Id do Redeiro.
  String? id;

  /// Nome do redeiro.
  String nome = "";

  /// Celular do redeiro.
  String? celular;

  /// Email do redeiro.
  String? email;

  /// Indica se o celular do redeiro recebe mensagens via WhatsApp.
  bool whatsApp;

  /// Endereço do Cliente.
  EnderecoDmo endereco = EnderecoDmo();

  /// Indica se o redeiro está ativo ou não.
  bool ativo;

  /// Lista de grupos associados ao redeiro.
  List<GrupoDeRedeirosDmo> gruposDoRedeiro = [];

  //#endregion Atributos

  //#region Construtor(es)
  RedeiroDmo({this.id, required this.nome, required this.endereco, this.celular, this.email, this.whatsApp = false, this.ativo = true, required this.gruposDoRedeiro});

  /// Construtor que inicializa objetos de acordo com um objeto do Parse Server.
  RedeiroDmo.fromParse(ParseObject parseObject) :
      id = parseObject.objectId ?? "",
      nome = parseObject.get(RedeiroParse.CAMPO_NOME) ?? "Falha ao obter nome do redeiro",
      celular = parseObject.get(RedeiroParse.CAMPO_CELULAR),
      email = parseObject.get(RedeiroParse.CAMPO_EMAIL),
      whatsApp = parseObject.get(RedeiroParse.CAMPO_WHATSAPP) ?? false,
      ativo = parseObject.get(RedeiroParse.CAMPO_ATIVO) ?? false,
      endereco = EnderecoDmo.fromParse(parseObject),
      gruposDoRedeiro = [];//parseObject.get<ParseObject>(RedeiroParse.RELACAO_GRUPOS);

  RedeiroDmo.fromParseComGrupos(List<ParseObject> listaComGrupos) :
        id = listaComGrupos.first.get<ParseObject>('redeiro')?.get('objectId') ?? "",
        nome = listaComGrupos.first.get<ParseObject>('redeiro')?.get(RedeiroParse.CAMPO_NOME) ?? "Falha ao obter nome do redeiro",
        celular = listaComGrupos.first.get<ParseObject>('redeiro')?.get(RedeiroParse.CAMPO_CELULAR),
        email = listaComGrupos.first.get<ParseObject>('redeiro')?.get(RedeiroParse.CAMPO_EMAIL),
        whatsApp = listaComGrupos.first.get<ParseObject>('redeiro')?.get(RedeiroParse.CAMPO_WHATSAPP) ?? false,
        ativo = listaComGrupos.first.get<ParseObject>('redeiro')?.get(RedeiroParse.CAMPO_ATIVO) ?? false,
        endereco = EnderecoDmo.fromParse(listaComGrupos.first.get<ParseObject>('redeiro')!),
        gruposDoRedeiro = listaComGrupos.map((e) => GrupoDeRedeirosDmo.fromParse(e.get<ParseObject>('grupo')!)).toList();
  //#endregion Construtor(es)

  //#region Métodos

  @override
  String toString() {
    return 'id: $id, '
        'nome: $nome, '
        'celular: $celular, '
        'email: $email, '
        'endereco: ${endereco.toString()}, '
        'gruposDoRedeiro: [${(gruposDoRedeiro.map((e) => "{ id: ${e.idGrupo}, nomeGrupo: ${e.nomeGrupo} } ")) }].';
  }


  //#endregion Métodos
}