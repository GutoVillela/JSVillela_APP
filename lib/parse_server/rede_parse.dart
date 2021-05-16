import 'package:jsvillela_app/dml/rede_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe "Rede" do Parse Server.
class RedeParse{

  //#region Constantes

  /// Constante que define nome da classe "Rede" do Parse Server.
  static const String NOME_CLASSE = "Rede";

  /// Constante que define o campo "objectId" da classe "Rede" do Parse Server.
  static const String CAMPO_ID_REDE = "objectId";

  /// Constante que define o campo "nome_rede" da classe "Rede" do Parse Server.
  static const String CAMPO_NOME_REDE = "nome_rede";

  /// Constante que define o campo "valor unitario" da classe "Rede" do Parse Server.
  static const String CAMPO_VLR_UNITARIO = "vlr_unitario";

  //#endregion Constantes

  //#region Métodos
  /// Método responsável por cadastrar uma nova rede no Parse Server.
  Future<RedeDmo> cadastrarRede(RedeDmo rede) async {

    // Definir informações da rede a ser salva
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..set<String?>(CAMPO_NOME_REDE, rede.nome_rede)
      ..set<double?>(CAMPO_VLR_UNITARIO, rede.valor_unitario_rede);

    print("Dados a sakvar da rede: " + dadosASalvar.toString());

    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      // Em caso de sucesso recuperar id da Rede cadastrada.
      rede.id = (response.result as ParseObject).objectId;

      // Retornar redeiro com ID preenchido.
      return rede;
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por obter a lista de Redes do Parse Server de forma paginada.
  Future<List<RedeDmo>> obterListaDeRedePaginadas(int registrosAPular, String? filtroPorNome) async{

    // Criando consulta
    final queryBuilder = QueryBuilder(ParseObject(NOME_CLASSE))
      ..setAmountToSkip(registrosAPular)
      ..setLimit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
      ..orderByAscending(CAMPO_NOME_REDE);

    // Definir filtro, caso tenha sido fornecido.
    if(filtroPorNome != null)
      queryBuilder.whereStartsWith(CAMPO_NOME_REDE, filtroPorNome);

    // Executar consulta
    final response = await queryBuilder.query();

    if(response.success){

      // Em caso de sucesso retornar objeto de redeiros preenchido.
      if(response.results != null){

        print(response.result);

        //Montar lista com objetos de retorno
        List<RedeDmo> lista = [];

        // Converter lista retornada para lista de RedeDmo
        lista.addAll(response.results!.map((e) => RedeDmo.fromParse(e)));

        return lista;
      }
      else {
        print("rede_parse.dart -> vazio");
        return [];
      }
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por apagar uma Rede do Parse Server.
  Future<void> apagarRede(String idRede) async {

    // Alterar informações da Rede
    final registroAApagar = ParseObject(NOME_CLASSE)
      ..objectId = idRede;

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