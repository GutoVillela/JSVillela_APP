import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/relacao_redeiros_e_grupos_parse.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe "Redeiros" do Parse Server.
class RedeiroParse{

  //#region Constantes

  /// Constante que define nome da classe "Redeiros" do Parse Server.
  static const String NOME_CLASSE = "Redeiros";

  /// Constante que define o campo "objectId" da classe "Redeiros" do Parse Server.
  static const String CAMPO_ID_REDEIRO = "objectId";

  /// Constante que define o campo "nome" da classe "Redeiros" do Parse Server.
  static const String CAMPO_NOME = "nome";

  /// Constante que define o campo "celular" da classe "Redeiros" do Parse Server.
  static const String CAMPO_CELULAR = "celular";

  /// Constante que define o campo "email" da classe "Redeiros" do Parse Server.
  static const String CAMPO_EMAIL = "email";

  /// Constante que define o campo "whatsapp" da classe "Redeiros" do Parse Server.
  static const String CAMPO_WHATSAPP = "whatsapp";

  /// Constante que define o campo "endereco" da classe "Redeiros" do Parse Server.
  static const String CAMPO_ENDERECO = "endereco";

  /// Constante que define o campo "logradouro" da classe "Redeiros" do Parse Server.
  static const String CAMPO_ENDERECO_LOGRADOURO = "logradouro";

  /// Constante que define o campo "numero" da classe "Redeiros" do Parse Server.
  static const String CAMPO_ENDERECO_NUMERO = "numero";

  /// Constante que define o campo "bairro" da classe "Redeiros" do Parse Server.
  static const String CAMPO_ENDERECO_BAIRRO = "bairro";

  /// Constante que define o campo "cidade" da classe "Redeiros" do Parse Server.
  static const String CAMPO_ENDERECO_CIDADE = "cidade";

  /// Constante que define o campo "cep" da classe "Redeiros" do Parse Server.
  static const String CAMPO_ENDERECO_CEP = "cep";

  /// Constante que define o campo "posicao" da classe "Redeiros" do Parse Server.
  static const String CAMPO_ENDERECO_POSICAO = "posicao";

  /// Constante que define o campo "complemento" da classe "Redeiros" do Parse Server.
  static const String CAMPO_ENDERECO_COMPLEMENTO = "complemento";

  /// Constante que define o campo "ativo" da classe "Redeiros" do Parse Server.
  static const String CAMPO_ATIVO = "ativo";

  /// Constante que define o nome da relação N para N da classe "Redeiros" com a classe "Caderno" do Parse Server.
  static const String RELACAO_CADERNO = "caderno";

  //#endregion Constantes

  //#region Métodos
  /// Método responsável por cadastrar um novo redeiro no Parse Server.
  Future<RedeiroDmo> cadastrarRedeiro(RedeiroDmo redeiro) async {

    // Definir informações do grupo
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..set<bool>(CAMPO_ATIVO, redeiro.ativo)
      ..set<String>(CAMPO_NOME, redeiro.nome )
      ..set<String?>(CAMPO_EMAIL, redeiro.email)
      ..set<String>(CAMPO_CELULAR, redeiro.celular ?? "")
      ..set<bool>(CAMPO_WHATSAPP, redeiro.whatsApp)
      ..set<String>(CAMPO_ENDERECO_LOGRADOURO, redeiro.endereco.logradouro ?? "")
      ..set<String?>(CAMPO_ENDERECO_NUMERO, redeiro.endereco.numero)
      ..set<String?>(CAMPO_ENDERECO_BAIRRO, redeiro.endereco.bairro)
      ..set<String>(CAMPO_ENDERECO_CIDADE, redeiro.endereco.cidade ?? "")
      ..set<String?>(CAMPO_ENDERECO_CEP, redeiro.endereco.cep)
      ..set<String?>(CAMPO_ENDERECO_COMPLEMENTO, redeiro.endereco.complemento)
      ..set<ParseGeoPoint?>(CAMPO_ENDERECO_POSICAO, redeiro.endereco.posicao == null ? null : ParseGeoPoint(latitude: redeiro.endereco.posicao!.latitude, longitude: redeiro.endereco.posicao!.longitude));

    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      // Em caso de sucesso recuperar id do Redeiro cadastrado.
      redeiro.id = (response.result as ParseObject).objectId;

      // Cadastrar relação entre o Redeiro e os grupos no Parse Server.
      await RedeirosEGruposParse().cadastrarRelacaoRedeiroGrupos(redeiro.id!, redeiro.gruposDoRedeiro.map((e) => e.idGrupo).toList());

      // Retornar redeiro com ID preenchido.
      return redeiro;
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por editar redeiro no Parse Server.
  Future<RedeiroDmo> editarRedeiro(RedeiroDmo redeiro) async {

    // Obter lista de grupos de redeiros
    List<GrupoDeRedeirosDmo> gruposDoRedeiro = await RedeirosEGruposParse().obterGruposDoRedeiro(redeiro.id!);

    // Obter os grupos do redeiro a remover
    List<GrupoDeRedeirosDmo> gruposARemover = [];
    gruposDoRedeiro.forEach((grupo) {
      if(!redeiro.gruposDoRedeiro.any((element) => element.idGrupo == grupo.idGrupo))
        gruposARemover.add(grupo);
    });

    // Obter os grupos do redeiro a adicionar
    List<GrupoDeRedeirosDmo> gruposAAdicionar = [];
    redeiro.gruposDoRedeiro.forEach((grupo) {
      if(!gruposARemover.any((element) => element.idGrupo == grupo.idGrupo))
        gruposAAdicionar.add(grupo);
    });

    // Alterar informações do redeiro
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..objectId = redeiro.id
      ..set<bool>(CAMPO_ATIVO, redeiro.ativo)
      ..set<String>(CAMPO_NOME, redeiro.nome )
      ..set<String?>(CAMPO_EMAIL, redeiro.email)
      ..set<String>(CAMPO_CELULAR, redeiro.celular ?? "")
      ..set<bool>(CAMPO_WHATSAPP, redeiro.whatsApp)
      ..set<String>(CAMPO_ENDERECO_LOGRADOURO, redeiro.endereco.logradouro ?? "")
      ..set<String?>(CAMPO_ENDERECO_NUMERO, redeiro.endereco.numero)
      ..set<String?>(CAMPO_ENDERECO_BAIRRO, redeiro.endereco.bairro)
      ..set<String>(CAMPO_ENDERECO_CIDADE, redeiro.endereco.cidade ?? "")
      ..set<String?>(CAMPO_ENDERECO_CEP, redeiro.endereco.cep)
      ..set<String?>(CAMPO_ENDERECO_COMPLEMENTO, redeiro.endereco.complemento)
      ..set<ParseGeoPoint?>(CAMPO_ENDERECO_POSICAO, redeiro.endereco.posicao == null ? null : ParseGeoPoint(latitude: redeiro.endereco.posicao!.latitude, longitude: redeiro.endereco.posicao!.longitude));

    //Se existir elementos na lista de grupos a adicionar, incluir instrução para adicionar grupos.
    if(gruposAAdicionar.any((element) => true))
      await RedeirosEGruposParse().cadastrarRelacaoRedeiroGrupos(redeiro.id!, gruposAAdicionar.map((e) => e.idGrupo).toList());

    // Se existir elementos na lista de grupos a remover, adicionar instrução para remover grupos.
    if(gruposARemover.any((element) => true))
      await RedeirosEGruposParse().removerGruposDoRedeiro(redeiro.id!, gruposARemover);

    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      // Em caso de sucesso retornar objeto de grupo de redeiros preenchido.
      return redeiro;
    }
    else{
      print("ERRO QUE DEU: ${ErrosParse.obterDescricao(response.error!.code)}");
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por eativar ou desativar redeiro no Parse Server.
  Future<RedeiroDmo> ativarOuDesativarRedeiro(String idRedeiro, bool ativar) async {

    // Alterar informações do redeiro
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..objectId = idRedeiro
      ..set<bool>(CAMPO_ATIVO, ativar);

    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      // Em caso de sucesso retornar objeto de grupo de redeiros preenchido.
      return RedeiroDmo.fromParse((response.result));
    }
    else{
      print("ERRO QUE DEU: ${ErrosParse.obterDescricao(response.error!.code)}");
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por obter a lista de Redeiros do Parse Server de forma paginada.
  Future<List<RedeiroDmo>> obterListaRedeirosPaginadas(int registrosAPular, String? filtroPorNome) async{

    // Criando consulta
    final queryBuilder = QueryBuilder(ParseObject(NOME_CLASSE))
      ..setAmountToSkip(registrosAPular)
      ..setLimit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
      ..orderByAscending(CAMPO_NOME);

    // Definir filtro, caso tenha sido fornecido.
    if(filtroPorNome != null)
      queryBuilder.whereStartsWith(CAMPO_NOME, filtroPorNome);

    // Executar consulta
    final response = await queryBuilder.query();

    if(response.success){

      // Em caso de sucesso retornar objeto de redeiros preenchido.
      if(response.results != null){
        //Montar lista com objetos de retorno
        List<RedeiroDmo> lista = [];

        // Converter lista retornada para lista de RedeirosDmo
        lista.addAll(response.results!.map((e) => RedeiroDmo.fromParse(e)));

        // Obter grupos associados aos redeiros retornados
        for(int i = 0; i < lista.length; i++){
          lista[i].gruposDoRedeiro.addAll(await RedeirosEGruposParse().obterGruposDoRedeiro(lista[i].id!));
        }

        return lista;
      }
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

  /// Método responsável por obter a lista de Cidades do Parse Server a partir dos grupos de redeiros fornecidos.
  Future<List<String>> obterListaDeCidadesAPartirDosGrupos(List<GrupoDeRedeirosDmo> listaDeGrupos) async{

    // Obter lista de redeiros
    List<RedeiroDmo> redeiros = await RedeirosEGruposParse().obterRedeirosAPartirDosGrupos(listaDeGrupos);

    return redeiros.map((e) => e.endereco.cidade ?? "Cidade não cadastrada").toList();
  }

  /// Método responsável por apagar um Redeiro do Parse Server.
  Future<void> apagarRedeiro(String idRedeiro) async {

    // Alterar informações do grupo
    final registroAApagar = ParseObject(NOME_CLASSE)
      ..objectId = idRedeiro;

    // Gravar dados no Parse Server
    final response = await registroAApagar.delete();

    if(!response.success){
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }


  //#endregion Métodos

}