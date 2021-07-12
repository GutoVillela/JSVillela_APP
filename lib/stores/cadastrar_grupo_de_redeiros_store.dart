import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/parse_server/grupo_de_redeiros_parse.dart';
import 'package:mobx/mobx.dart';

part 'cadastrar_grupo_de_redeiros_store.g.dart';

class CadastrarGrupoDeRedeirosStore = _CadastrarGrupoDeRedeirosStore with _$CadastrarGrupoDeRedeirosStore;

/// Store usada na tela de Cadastrar Grupo de Redeiros.
abstract class _CadastrarGrupoDeRedeirosStore with Store{

  //#region Construtor(es)
  _CadastrarGrupoDeRedeirosStore({required this.tipoDeManutencao}){
    autorun((_){
      print("nomeGrupo: $nomeGrupo");
    });
  }
  //#endregion Construtor(es)

  //#region Observables
  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  ///Atributo observável que define o tipo de manutenção da tela (inclusão ou alteração)
  @observable
  TipoDeManutencao tipoDeManutencao;

  ///Atributo observável que define o nome do grupo definido em tela.
  @observable
  String nomeGrupo = "";

  /// Atributo observável que define se ocorreu algum erro durante processo de login.
  @observable
  String? erro;
  //#endregion Observables

  //#region Computed
  /// Computed que define se botão de cadastro será habilitado ou não.
  @computed
  bool get habilitaBotaoDeCadastro => !processando;

  //#endregion Computed

  //#region Actions

  ///Action que define o valor do atributo observável "nomeGrupo".
  @action
  void setNomeGrupo(String value) => nomeGrupo = value;

  /// Action que realiza processo cadastro do novo grupo de redeiros.
  @action
  Future<GrupoDeRedeirosDmo?> cadastrarGrupoDeRedeiros() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{
      // Realizar cadastro do grupo.
      final grupoCadastrado = await GrupoDeRedeirosParse().cadastrarGrupoDeRedeiros(nomeGrupo);

      // Indicar que classe finalizou o processamento.
      processando = false;

      // Retornar novo grupo
      return grupoCadastrado;
    }
    catch (e){
      erro = e.toString();
      // Indicar que classe finalizou o processamento.
      processando = false;
      return null;
    }
  }

  /// Action que realiza processo edição do grupo de redeiros.
  @action
  Future<GrupoDeRedeirosDmo?> editarGrupoDeRedeiros(GrupoDeRedeirosDmo grupo) async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{
      // Realizar edição do grupo.
      final grupoEditado = await GrupoDeRedeirosParse().editarGrupoDeRedeiros(grupo);

      // Indicar que classe finalizou o processamento.
      processando = false;

      // Retornar grupo atualizado
      return grupoEditado;
    }
    catch (e){
      erro = e.toString();
      // Indicar que classe finalizou o processamento.
      processando = false;
      return null;
    }
  }
  //#endregion Actions

}