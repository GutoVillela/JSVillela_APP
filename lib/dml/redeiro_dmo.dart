import 'package:jsvillela_app/dml/endereco_dmo.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';

/// Classe modelo para redeiros.
class RedeiroDmo{

  //#region Atributos

  /// Id do Redeiro.
  String id;

  /// Nome do redeiro.
  String nome;

  /// Celular do redeiro.
  String celular;

  /// Email do redeiro.
  String email;

  /// Indica se o celular do redeiro recebe mensagens via WhatsApp.
  bool whatsApp;

  /// Endereço do Cliente.
  EnderecoDmo endereco;

  /// Indica se o redeiro está ativo ou não.
  bool ativo;

  /// Lista de grupos associados ao redeiro.
  List<GrupoDeRedeirosDmo> gruposDoRedeiro;

  //#endregion Atributos

  //#region Construtor(es)
  RedeiroDmo({this.id, this.nome, this.celular, this.email, this.whatsApp, this.endereco, this.ativo, this.gruposDoRedeiro});
  //#endregion Construtor(es)

  //#region Métodos
  @override
  String toString() {
    return 'id: $id, '
        'nome: $nome, '
        'celular: $celular, '
        'email: $email, '
        'endereco: ${endereco.toString()}, '
        'gruposDoRedeiro: [${gruposDoRedeiro.map((e) => "{ id: " + e.idGrupo + ", nomeGrupo: " + e.nomeGrupo + "} ")}].';
  }
  //#endregion Métodos
}