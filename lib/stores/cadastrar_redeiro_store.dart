import 'package:get_it/get_it.dart';
import 'package:jsvillela_app/dml/endereco_dmo.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/parse_server/redeiro_parse.dart';
import 'package:mobx/mobx.dart';
import 'consultar_redeiros_store.dart';

part 'cadastrar_redeiro_store.g.dart';

class CadastrarRedeiroStore = _CadastrarRedeiroStore with _$CadastrarRedeiroStore;

abstract class _CadastrarRedeiroStore with Store{

  //#region Construtor(es)
  _CadastrarRedeiroStore({required this.tipoDeManutencao, this.redeiroASerEditado}){
    autorun((_){
      print(redeiroASerEditado.toString());
    });

  }
  //#endregion Construtor(es)

  //#region Atributos
  /// Atributo que define o tipo de manutenção da tela (inclusão ou alteração)
  final TipoDeManutencao tipoDeManutencao;

  /// Redeiro a ser editado (caso haja algum).
  final RedeiroDmo? redeiroASerEditado;

  /// Store que controla tela de consulta de redeiros (usado para atualizar informações da tela após cadastro/alteração).
  final ConsultarRedeirosStore storeConsulta = GetIt.I<ConsultarRedeirosStore>();

  //#endregion Atributos

  //#region Observables

  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  ///Atributo observável que define o nome do redeiro definido em tela.
  @observable
  String nomeRedeiro = "";

  ///Atributo observável que define o email do redeiro definido em tela.
  @observable
  String emailRedeiro = "";

  ///Atributo observável que define o celular do redeiro definido em tela.
  @observable
  String celularRedeiro = "";

  ///Atributo observável que define se o celular do redeiro suporta WhatsApp.
  @observable
  bool whatsapp = false;

  ///Atributo observável que define todos os campos de endereço.
  @observable
  EnderecoDmo endereco = EnderecoDmo();

  ///Atributo observável que define o complemento do endereço do redeiro definido em tela.
  @observable
  String complemento = "";

  /// Atributo observável que define a lista com os grupos de redeiros selecionados em tela.
  ObservableList<GrupoDeRedeirosDmo> gruposDeRedeiros = ObservableList<GrupoDeRedeirosDmo>();

  ///Atributo observável que indica se a interface está carregando o endereço com base na localização atual do usuário.
  @observable
  bool carregandoEndereco = false;
  //#endregion Observables

  //#region Computed
  /// Computed que guarda o texto dos Grupos do Recolhimento a ser exibido na tela.
  @computed
  String get textoGruposDoRecolhimento => gruposDeRedeiros.isEmpty ?
  "Nenhum grupo selecionado" :
  gruposDeRedeiros.first.nomeGrupo +
      (gruposDeRedeiros.length == 1 ? "" : " e mais ${gruposDeRedeiros.length - 1}.");

  /// Computed que define se botão de cadastro será habilitado ou não.
  @computed
  bool get habilitaBotaoDeCadastro => !processando;
  //#endregion Computed

  //#region Actions

  /// Action que define valor do atributo observável que define o nome do redeiro definido em tela.
  @action
  void setNomeRedeiro (String value) => nomeRedeiro = value;

  ///Action que define valor do atributo observável que define o email do redeiro definido em tela.
  @action
  void setEmailRedeiro (String value) => emailRedeiro = value;

  ///Action que define valor do atributo observável que define o celular do redeiro definido em tela.
  @action
  void setCelularRedeiro (String value) => celularRedeiro = value;

  ///Action que define valor do atributo observável que define se o celular do redeiro suporta WhatsApp.
  @action
  void setWhatsapp (bool? value) => whatsapp = value ?? false;

  ///Action que define valor do atributo observável que define todos os campos de endereço.
  @action
  void setEndereco (EnderecoDmo value) => endereco = value;

  ///Action que define valor do atributo observável "complemento".
  @action
  void setComplemento (String value) => complemento = value;

  ///Action que define valor do atributo observável que indica se a interface está carregando o endereço com base na localização atual do usuário.
  @action
  void setCarregandoEndereco (bool value) => carregandoEndereco = value;

  ///Action que define valor do atributo observável que define a lista com os grupos de redeiros selecionados em tela.
  @action
  void setGruposDeRedeiros (List<GrupoDeRedeirosDmo> value) {
    gruposDeRedeiros.clear();
    gruposDeRedeiros.addAll(value);
  }

  /// Action que realiza processo cadastro ou edição do redeiro.
  @action
  Future<RedeiroDmo?> cadastrarOuEditarRedeiro() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{

      endereco.complemento = complemento;

      // Montando objeto para cadastro
      RedeiroDmo dadosDoRedeiro = RedeiroDmo(
          id: redeiroASerEditado?.id,
          nome: nomeRedeiro,
          celular: celularRedeiro,
          email: emailRedeiro,
          whatsApp: whatsapp,
          endereco: endereco,
          ativo: true,
          gruposDoRedeiro: gruposDeRedeiros);

      late RedeiroDmo redeiro;

      if(tipoDeManutencao == TipoDeManutencao.cadastro){
        // Realizar cadastro do redeiro.
        redeiro = await RedeiroParse().cadastrarRedeiro(dadosDoRedeiro);
      }
      else{
        // Realizar edição do grupo.
        redeiro = await RedeiroParse().editarRedeiro(dadosDoRedeiro);
      }

      // Atualizar registro na tela de consulta após edição
      if(storeConsulta.listaDeRedeiros.any((element) => element.id == redeiro.id))
        storeConsulta.listaDeRedeiros[storeConsulta.listaDeRedeiros.indexWhere((element) => element.id == redeiro.id)] = redeiro;
      else
        // Caso não exista, adicioná-lo
        storeConsulta.listaDeRedeiros.add(redeiro);

      // Indicar que classe finalizou o processamento.
      processando = false;

      // Retornar novo grupo
      return redeiro;
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