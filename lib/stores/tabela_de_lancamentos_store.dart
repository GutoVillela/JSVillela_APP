import 'package:jsvillela_app/dml/lancamento_do_caderno_dml.dart';
import 'package:mobx/mobx.dart';
import 'package:jsvillela_app/parse_server/lancamento_do_caderno_parse.dart';

part 'tabela_de_lancamentos_store.g.dart';

class TabelaDeLancamentosStore = _TabelaDeLancamentosStore with _$TabelaDeLancamentosStore;

abstract class _TabelaDeLancamentosStore with Store{
  //#region Construtor(es)
  _TabelaDeLancamentosStore({required this.idDoRedeiro, required this.listaDeLancamentos});
  //#endregion Construtor(es)

  //#region Atributos

  /// ID do Redeiro associado à lista de lançamentos.
  final String idDoRedeiro;

  //#endregion Atributos

  //#region Observables

  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  /// Lista de lançamentos no caderno a serem exibidas na tabela.
  ObservableList<LancamentoDoCadernoDmo> listaDeLancamentos = ObservableList<LancamentoDoCadernoDmo>();

  //#endregion Observables

  //#region Computed

  /// Computed que define se conjunto está pago
  @computed
  bool get pago => listaDeLancamentos.isNotEmpty && listaDeLancamentos.first.dataPagamento != null;

  /// Computed que define se o pagamento do conjunto está confirmado pelo redeiro.
  @computed
  bool get confirmado => listaDeLancamentos.isNotEmpty && listaDeLancamentos.first.dataConfirmacaoPagamento != null;

  /// Computed que define valor total de todos os lancamentos.
  @computed
  double get total {
    double total = 0;
    listaDeLancamentos.forEach((element) {
      total += element.quantidade * element.valorUnitario;
    });
    return total;
  }

  /// Computed que define se botão de cadastro será habilitado ou não.
  @computed
  bool get habilitaBotaoDeCadastro => !processando;
  //#endregion Computed

  //#region Actions

  ///Action que define o valor do atributo observável "listaDeLancamentos".
  @action
  void setListaDeLancamentos(List<LancamentoDoCadernoDmo> value) {
    listaDeLancamentos.clear();
    listaDeLancamentos.addAll(value);
  }

  /// Action que busca os lançamentos no caderno do redeiro.
  @action
  Future<void> processarPagamento() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{

      //Obter todos os lançamentos do redeiro
      List<LancamentoDoCadernoDmo> lancamentosPagos = await LancamentoDoCadernoParse().pagarListaDeLancamentos(idLancamentos: listaDeLancamentos.map((element) => element.idLancamento).toList());

      // Definir lista de lançamentos após pagamento
      setListaDeLancamentos(lancamentosPagos);

      // Indicar que classe finalizou o processamento.
      processando = false;
    }
    catch (e){
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      processando = false;
    }
  }
//#endregion Actions
}