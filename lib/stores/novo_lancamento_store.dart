import 'package:jsvillela_app/dml/lancamento_do_caderno_dml.dart';
import 'package:jsvillela_app/dml/rede_dmo.dart';
import 'package:jsvillela_app/parse_server/lancamento_do_caderno_parse.dart';
import 'package:jsvillela_app/parse_server/rede_parse.dart';
import 'package:mobx/mobx.dart';

part 'novo_lancamento_store.g.dart';

class NovoLancamentoStore = _NovoLancamentoStore with _$NovoLancamentoStore;

abstract class _NovoLancamentoStore with Store{

  //#region Construtor(es)
  _NovoLancamentoStore({required this.idRedeiro}){
    carregarRedes();
  }
  //#endregion Construtor(es)

  //#region Atributos

  /// ID do Redeiro a qual o lançamento será associado.
  final String idRedeiro;

  //#endregion Atributos

  //#region Observables

  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  ///Atributo observável que define se classe está buscadas redes para popular Combo Box.
  @observable
  bool buscandoRedes = false;

  ///Atributo observável que define a rede definido em tela.
  @observable
  RedeDmo? rede;

  ///Atributo observável que define a quantidade da rede definido em tela.
  @observable
  int quantidade = 0;

  ///Atributo observável que define o valor unitário da rede definido em tela.
  @observable
  double valorUnitarioRede = 0;

  ///Atributo observável que define a lista de grupos a ser exibida em tela.
  ObservableList<RedeDmo> redes = ObservableList<RedeDmo>();
  //#endregion Observables

  //#region Computed

  /// Computed que define se botão de cadastro será habilitado ou não.
  @computed
  bool get habilitaBotaoDeCadastro => !processando && !buscandoRedes;
  //#endregion Computed

  //#region Actions

  /// Action que define valor do atributo observável que define o nome da rede definid em tela.
  @action
  void setRede (String? value) => value == null ? rede = null : rede = redes.where((element) => element.id == value).first;

  ///Action que define valor do atributo observável que define o valor unit do rede definido em tela.
  @action
  void setValorUnitarioRede (String value) => valorUnitarioRede = double.tryParse(value.replaceAll(RegExp(r','), '.')) ?? 0;

  ///Action que define valor do atributo observável que define o valor unit do rede definido em tela.
  @action
  void setQuantidade (String value) => quantidade = int.tryParse(value) ?? 0;

  ///Action que define o valor do atributo observável "redes".
  @action
  void setRedes(List<RedeDmo> value) {
    redes.clear();
    redes.addAll(value);
  }

  /// Action que busca os lançamentos no caderno do redeiro.
  @action
  Future<void> carregarRedes() async {

    // Indicar que classe iniciou o processamento.
    buscandoRedes = true;

    try{

      //Obter todos os lançamentos do redeiro
      List<RedeDmo> listaDeRedes = await RedeParse().consultarTodasAsRedes();

      // Definir lista de redes para exibição no combobox
      setRedes(listaDeRedes);

      // Indicar que classe finalizou o processamento.
      buscandoRedes = false;
    }
    catch (e){
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      buscandoRedes = false;
    }
  }

  /// Action que realiza processo cadastro do lançamento.
  @action
  Future<LancamentoDoCadernoDmo?> cadastrarLancamento() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{

      // Cadastrar lançamento
      var lancamento = await LancamentoDoCadernoParse().cadastrarLancamento(
          idRedeiro: idRedeiro,
          idRede: rede!.id!,
          quantidade: quantidade,
          valorUnitario: valorUnitarioRede,
          dataLancamento: DateTime.now()
      );

      // Indicar que classe finalizou o processamento.
      processando = false;

      // Retornar nova rede
      return lancamento;
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