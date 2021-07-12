import 'package:jsvillela_app/dml/materia_prima_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:jsvillela_app/parse_server/erros_parse.dart';

/// Classe responsável por realizar a conexão com a classe "Materia Prima" do Parse Server.
class MateriaPrimaParse{

  //#region Constantes

  /// Constante que define nome da classe "Materia Prima" do Parse Server.
  static const String NOME_CLASSE ="MateriaPrima";

  /// Constante que define o campo "objectId" da classe "Materia Prima" do Parse Server.
  static const String CAMPO_ID_MP = "objectId";

  /// Constante que define o campo "nomeMateriaPrima" da classe "Materia Prima" do Parse Server.
  static const String CAMPO_NOME_MATERIA_PRIMA = "nomeMateriaPrima";

  /// Constante que define o campo "iconeMateriaPrima" da classe "Materia Prima" do Parse Server.
  static const String CAMPO_ICONE_MATERIA_PRIMA = "iconeMateriaPrima";

  //#endregion Constantes

  //#region Métodos
  /// Método responsável por cadastrar uma nova materia prima no Parse Server.
  Future<MateriaPrimaDmo> cadastrarMateriaPrima(MateriaPrimaDmo materiaPrima) async {

    print("CHEGOU AQUI ÓÓÓ");

    // Definir informações da materia prima a ser salva
    final dadosASalvar = ParseObject(NOME_CLASSE)
      ..set<String?>(CAMPO_NOME_MATERIA_PRIMA, materiaPrima.nomeMateriaPrima)
      ..set<String?>(CAMPO_ICONE_MATERIA_PRIMA, materiaPrima.iconeMateriaPrima);
    print("Dados a sakvar da rede: " + dadosASalvar.toString());
    // Gravar dados no Parse Server
    final response = await dadosASalvar.save();

    if(response.success){
      // Em caso de sucesso recuperar id da Materia Prima cadastrada.
      materiaPrima.id = (response.result as ParseObject).objectId;

      // Retornar redeiro com ID preenchido.
      return materiaPrima;
    }
    else{
      if(response.error != null)
        return Future.error(ErrosParse.obterDescricao(response.error!.code));
      else
        return Future.error("Aconteceu um erro inesperado!");
    }
  }

  /// Método responsável por obter a lista de Mp do Parse Server de forma paginada.
  Future<List<MateriaPrimaDmo>> obterListaDeMateriaPrimaPaginadas(int registrosAPular, String? filtroPorNome) async{

    // Criando consulta
    final queryBuilder = QueryBuilder(ParseObject(NOME_CLASSE))
      ..setAmountToSkip(registrosAPular)
      ..setLimit(Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
      ..orderByAscending(CAMPO_NOME_MATERIA_PRIMA);

    // Definir filtro, caso tenha sido fornecido.
    if(filtroPorNome != null)
      queryBuilder.whereStartsWith(CAMPO_NOME_MATERIA_PRIMA, filtroPorNome);

    // Executar consulta
    final response = await queryBuilder.query();

    if(response.success){

      // Em caso de sucesso retornar objeto de mp preenchida.
      if(response.results != null){
        //Montar lista com objetos de retorno
        List<MateriaPrimaDmo> lista = [];

        // Converter lista retornada para lista de MateriaPrimaDmo
        lista.addAll(response.results!.map((e) => MateriaPrimaDmo.fromParse(e)));

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

  /// Método responsável por apagar uma Materia Prima do Parse Server.
  Future<void> apagarMateriaPrima(String idMatPrima) async {

    // Alterar informações da Materia Prima
    final registroAApagar = ParseObject(NOME_CLASSE)
      ..objectId = idMatPrima;

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