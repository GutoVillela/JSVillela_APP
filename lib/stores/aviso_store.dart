import 'package:jsvillela_app/parse_server/avisos_do_usuario_parse.dart';
import 'package:mobx/mobx.dart';
import 'package:jsvillela_app/dml/aviso_do_usuario_dmo.dart';
import 'package:jsvillela_app/infra/preferencias.dart';

part 'aviso_store.g.dart';

class AvisoStore = _AvisoStore with _$AvisoStore;

abstract class _AvisoStore with Store{

  //#region Observables

  /// Lista obsersável de CheckListItem usado para demarcar os grupos de redeiros selecionados.
  ObservableList<AvisoDoUsuarioDmo> avisos = ObservableList<AvisoDoUsuarioDmo>();

  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  //#endregion Observables

  //#region Actions

  ///Action que define o valor do atributo observável "avisos".
  @action
  void setAvisos(List<AvisoDoUsuarioDmo> value) {
    avisos.clear();
    if(value.isNotEmpty)
      avisos.addAll(value);
  }

  /// Action que busca os avisos.
  @action
  Future<void> carregarAvisos() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{

      List<AvisoDoUsuarioDmo> avisosCarregados = await AvisosDoUsuarioParse().buscarAvisosDoUsuario(idUsuario: Preferencias.idUsuarioLogado!);
      print('QUANTIDADE DE COISAS: ${avisosCarregados.length}');
      setAvisos(avisosCarregados);

      // Indicar que classe finalizou o processamento.
      processando = false;
    }
    catch (e){
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      processando = false;
    }
  }

  /// Action que descarta o aviso.
  @action
  Future<void> descartarAvisoDoUsuario(String idAvisoDoUsuario) async {

    // Indicar que classe iniciou o processamento.
    //processando = true;

    try{

      await AvisosDoUsuarioParse().descartarAviso(idAvisoDoUsuario: idAvisoDoUsuario);

      // Indicar que classe finalizou o processamento.
      //processando = false;
    }
    catch (e){
      print("ERRO: ${e.toString()}");
      // Indicar que classe finalizou o processamento.
      //processando = false;
    }
  }
  //#endregion Actions


}