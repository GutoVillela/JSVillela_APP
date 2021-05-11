import 'package:get_it/get_it.dart';
import 'package:jsvillela_app/dml/materia_prima_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/parse_server/materia_prima_parse.dart';
import 'package:mobx/mobx.dart';
import 'consultar_materia_prima_store.dart';

part 'cadastrar_materia_prima_store.g.dart';

class CadastrarMateriaPrimaStore = _CadastrarMateriaPrimaStore with _$CadastrarMateriaPrimaStore;

abstract class _CadastrarMateriaPrimaStore with Store{

  //#region Construtor(es)
  _CadastrarMateriaPrimaStore({required this.tipoDeManutencao, this.materiaPrimaASerEditada}){
    autorun((_){
      print(materiaPrimaASerEditada.toString());
    });

  }
  //#endregion Construtor(es)

  //#region Atributos
  /// Atributo que define o tipo de manutenção da tela (inclusão ou alteração)
  final TipoDeManutencao tipoDeManutencao;

  /// Rede a ser editado (caso haja algum).
  final MateriaPrimaDmo? materiaPrimaASerEditada;

  /// Store que controla tela de consulta de redeiros (usado para atualizar informações da tela após cadastro/alteração).
  final ConsultarMateriaPrimaStore storeConsulta = GetIt.I<ConsultarMateriaPrimaStore>();

  //#endregion Atributos

  //#region Observables

  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  ///Atributo observável que define o nome da mp definida em tela.
  @observable
  String nomeMateriaPrima = "";

  ///Atributo observável que define icone da mp definida em tela.
  @observable
  String iconeMateriaPrima = "";

  //#endregion Observables

  //#region Computed

  /// Computed que define se botão de cadastro será habilitado ou não.
  @computed
  bool get habilitaBotaoDeCadastro => !processando;
  //#endregion Computed

  //#region Actions

  /// Action que define valor do atributo observável que define o nome da mp em tela.
  @action
  void setNomeMateriaPrima (String value) => nomeMateriaPrima = value;

  ///Action que define valor do atributo observável que define o icone da mp em tela.
  @action
  void setIconeMateriaPrima (String value) => iconeMateriaPrima = value;

  /// Action que realiza processo de cadastro ou edição da mp.
  @action
  Future<MateriaPrimaDmo?> cadastrarOuEditarMateriaPrima() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{

      // Montando objeto para cadastro
      MateriaPrimaDmo dadosDaRede = MateriaPrimaDmo(
          id: materiaPrimaASerEditada?.id,
          nomeMateriaPrima: nomeMateriaPrima,
          iconeMateriaPrima: iconeMateriaPrima);


      late MateriaPrimaDmo materiaPrima;

      if(tipoDeManutencao == TipoDeManutencao.cadastro){
        // Realizar cadastro do redeiro.
        materiaPrima = await MateriaPrimaParse().cadastrarMateriaPrima(dadosDaRede);
      }
      else{
        // Realizar edição do grupo.
        //rede = await RedeParse().editarRede(dadosDaRede);
      }

      // Atualizar registro na tela de consulta após edição
      if(storeConsulta.listaDeMateriaPrima.any((element) => element.id == materiaPrima.id))
        storeConsulta.listaDeMateriaPrima[storeConsulta.listaDeMateriaPrima.indexWhere((element) => element.id == materiaPrima.id)] = materiaPrima;
      else
        // Caso não exista, adicioná-lo
        storeConsulta.listaDeMateriaPrima.add(materiaPrima);

      // Indicar que classe finalizou o processamento.
      processando = false;

      // Retornar nova rede
      return materiaPrima;
    }
    catch (e){
      //erro = e.toString();
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      processando = false;
      return null;
    }
  }
//#endregion Actions
}