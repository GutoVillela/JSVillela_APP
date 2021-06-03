import 'package:jsvillela_app/dml/lancamento_do_caderno_dml.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/parse_server/lancamento_do_caderno_parse.dart';
import 'package:mobx/mobx.dart';

part 'caderno_do_redeiro_store.g.dart';

class CadernoDoRedeiroStore = _CadernoDoRedeiroStore with _$CadernoDoRedeiroStore;

abstract class _CadernoDoRedeiroStore with Store{

  //#region Construtor(es)
  _CadernoDoRedeiroStore({required this.redeiro});
  //#endregion Construtor(es)

  //#region Atributos

  /// Redeiro a qual o caderno pertence.
  final RedeiroDmo redeiro;

  //#endregion Atributos

  //#region Observables

  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  /// Lista com lançamentos do caderno já agrupados do redeiro.
  ObservableList<List<LancamentoDoCadernoDmo>> caderno = ObservableList<List<LancamentoDoCadernoDmo>>();

  //#endregion Observables

  //#region Computed

  /// Computed que define se botão de cadastro será habilitado ou não.
  @computed
  bool get habilitaBotaoDeCadastro => !processando;
  //#endregion Computed

  //#region Actions

  ///Action que define o valor do atributo observável "caderno".
  @action
  void setCaderno(List<List<LancamentoDoCadernoDmo>> value) {
    caderno.clear();
    caderno.addAll(value);
  }

  /// Action que busca os lançamentos no caderno do redeiro.
  @action
  Future<void> carregarCadernoDoRedeiro() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{

      //Obter todos os lançamentos do redeiro
      List<LancamentoDoCadernoDmo> lancamentosDoCaderno = await LancamentoDoCadernoParse().buscarCadernoDoRedeiro(idRedeiro: redeiro.id!);

      //#region Agrupar lançamentos por data de pagamento

      List<List<LancamentoDoCadernoDmo>> listaDeCadernos = [];

      while(lancamentosDoCaderno.isNotEmpty){

        // Adicionar primeiro grupo que contém a mesma data de pagamento
        listaDeCadernos.add(lancamentosDoCaderno.where((e) => e.dataPagamento == lancamentosDoCaderno.first.dataPagamento).toList());

        // Remover todos os registros adicionados do caderno
        lancamentosDoCaderno.removeWhere((e) => e.dataPagamento == lancamentosDoCaderno.first.dataPagamento);
      }
      //#endregion Agrupar lançamentos por data de pagamento

      // Definir lista do caderno já agrupada por data de pagamento
      setCaderno(listaDeCadernos);

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