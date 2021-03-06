import 'package:get_it/get_it.dart';
import 'package:jsvillela_app/dml/rede_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/parse_server/rede_parse.dart';
import 'package:mobx/mobx.dart';
import 'consultar_rede_store.dart';

part 'cadastrar_rede_store.g.dart';

class CadastrarRedeStore = _CadastrarRedeStore with _$CadastrarRedeStore;

abstract class _CadastrarRedeStore with Store{

  //#region Construtor(es)
  _CadastrarRedeStore({required this.tipoDeManutencao, this.redeASerEditada}){
    autorun((_){
      print(redeASerEditada.toString());
      print("NOME REDE: $nomeRede");
      print("VALOR REDE: $valorUnitarioRede");
    });

  }
  //#endregion Construtor(es)

  //#region Atributos
  /// Atributo que define o tipo de manutenção da tela (inclusão ou alteração)
  final TipoDeManutencao tipoDeManutencao;

  /// Rede a ser editado (caso haja algum).
  final RedeDmo? redeASerEditada;

  /// Store que controla tela de consulta de rede (usado para atualizar informações da tela após cadastro/alteração).
  final ConsultarRedeStore storeConsulta = GetIt.I<ConsultarRedeStore>();

  //#endregion Atributos

  //#region Observables

  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  ///Atributo observável que define o nome do rede definido em tela.
  @observable
  String nomeRede = "";

  ///Atributo observável que define o valor unitário da rede definido em tela.
  @observable
  double valorUnitarioRede = 0;

  //#endregion Observables

  //#region Computed

  /// Computed que define se botão de cadastro será habilitado ou não.
  @computed
  bool get habilitaBotaoDeCadastro => !processando;
  //#endregion Computed

  //#region Actions

  /// Action que define valor do atributo observável que define o nome da rede definid em tela.
  @action
  void setNomeRede (String value) => nomeRede = value;

  ///Action que define valor do atributo observável que define o valor unit do rede definido em tela.
  @action
  void setValorUnitarioRede (String value) => valorUnitarioRede = double.tryParse(value.replaceAll(RegExp(r','), '.')) ?? 0;

  /// Action que realiza processo cadastro ou edição da rede.
  @action
  Future<RedeDmo?> cadastrarOuEditarRede() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{

      // Montando objeto para cadastro
      RedeDmo dadosDaRede = RedeDmo(
          id: redeASerEditada?.id,
          nomeRede: nomeRede,
          valorUnitarioRede: valorUnitarioRede + 0.00
          );


      late RedeDmo rede;

      if(tipoDeManutencao == TipoDeManutencao.cadastro){
        print("... -> ");
        print(dadosDaRede);
        // Realizar cadastro do redeiro.
        rede = await RedeParse().cadastrarRede(dadosDaRede);
      }
      else{
        // Realizar edição do grupo.
        //rede = await RedeParse().editarRede(dadosDaRede);
      }

      // Atualizar registro na tela de consulta após edição
      if(storeConsulta.listaDeRede.any((element) => element.id == rede.id))
        storeConsulta.listaDeRede[storeConsulta.listaDeRede.indexWhere((element) => element.id == rede.id)] = rede;
      else
        // Caso não exista, adicioná-lo
        storeConsulta.listaDeRede.add(rede);

      // Indicar que classe finalizou o processamento.
      processando = false;

      // Retornar nova rede
      return rede;
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