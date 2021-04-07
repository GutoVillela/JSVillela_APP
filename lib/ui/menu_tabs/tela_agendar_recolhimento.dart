import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/tela_confirmar_recolhimento.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/widgets/tela_busca_grupos_de_redeiros.dart';

class TelaAgendarRecolhimento extends StatefulWidget {
  @override
  _TelaAgendarRecolhimentoState createState() => _TelaAgendarRecolhimentoState();
}

class _TelaAgendarRecolhimentoState extends State<TelaAgendarRecolhimento> {

  //#region Atributos

  /// Data do Recolhimento selecionada em tela.
  DateTime _dataDoRecolhimento;

  /// Lista com os grupos de redeiros selecionados.
  List<GrupoDeRedeirosDmo> _gruposDeRedeiros;

  /// Lista com as cidades a serem visitadas no recolhimento.
  List<String> _listaDeCidades;

  /// Define se existe um processo de validação de data em andamento.
  bool validandoData = false;

  /// Define se existe um processo de validação de grupo(s) em andamento.
  bool validandoGrupos = false;

  //#endregion Atributos

  //#region Métodos
  @override
  Widget build(BuildContext context) {

    // Formatar para para dd/MM/yyyy
    final formatoData = new DateFormat('dd/MM/yyyy');
    
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){

          return Container(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Center(child: Icon(Icons.directions_car, size: 80, color: Theme.of(context).primaryColor)),
                SizedBox(height: 20),
                Text("Quando será o recolhimento?",
                    style:  TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    )
                ),
                SizedBox(height: 20),
                ListViewItemPesquisa(
                  textoPrincipal: "Data do Recolhimento",
                  textoSecundario: _dataDoRecolhimento == null ? "Nenhuma data selecionada" : formatoData.format(_dataDoRecolhimento),
                  iconeEsquerda: Icons.calendar_today,
                  iconeDireita: Icons.arrow_forward_ios_sharp,
                  acaoAoClicar: () async {

                    DateTime dataSelecionada = await showDatePicker(
                        context: context,
                        locale: Locale(WidgetsBinding.instance.window.locale.languageCode, WidgetsBinding.instance.window.locale.countryCode),
                        initialDate: _dataDoRecolhimento ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1)
                    );

                    setState(() => validandoData = true);

                    // Verificar se data é válida
                    if(!await RecolhimentoModel().validarSeExisteRecolhimentoAgendadoParaAData(dataSelecionada)){
                      dataSelecionada = null;
                      Infraestrutura.mostrarMensagemDeErro(context, "Já existe um agendamento para a data selecionada. Por favor escolha outra data!");
                    }

                    setState(() => validandoData = false);

                    // Atualizar estado da tela somente se uma data diferente for selecionada
                    if(dataSelecionada != _dataDoRecolhimento)
                      setState((){
                        _dataDoRecolhimento = dataSelecionada;
                      });
                  },
                ),
                validandoData ?
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator()
                    ],
                  ),
                ) :
                SizedBox(height: 30),
                Text("Notificar qual grupo de redeiros?",
                    style:  TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    )
                ),
                SizedBox(height: 20),
                ListViewItemPesquisa(
                  textoPrincipal: "Grupo do Redeiro",
                  textoSecundario: _gruposDeRedeiros == null || _gruposDeRedeiros.isEmpty ?
                  "Nenhum grupo selecionado" :
                  _gruposDeRedeiros.first.nomeGrupo +
                      (_gruposDeRedeiros.length - 1 == 0 ? "" : " e mais ${_gruposDeRedeiros.length - 1}."),
                  iconeEsquerda: Icons.people_sharp,
                  iconeDireita: Icons.arrow_forward_ios_sharp,
                  acaoAoClicar: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return TelaBuscaGruposDeRedeiros(gruposJaSelecionados: _gruposDeRedeiros);
                        }
                    ).then((gruposSelecionados) async {

                      // Informar tela que está acontecendo validação dos grupos
                      setState(() => validandoGrupos = true);

                      // Se nada foi selecionado, então resetar seleção de grupos
                      if(gruposSelecionados == null)
                        setState(() => _gruposDeRedeiros = null);
                      else{

                        // Validar se foi selecionado um conjunto de grupos diferentes
                        if(_validarSeGruposSaoIguais(gruposSelecionados, _gruposDeRedeiros)){

                          print("Grupos selecionados");
                          print(gruposSelecionados);
                          List<String> listaDeCidades = await _buscarListaDeCidades(gruposSelecionados);

                          // Validar se existem redeiros para os grupos selecionados.
                          if(listaDeCidades.isNotEmpty){
                            _listaDeCidades = listaDeCidades;
                            setState(() => _gruposDeRedeiros = gruposSelecionados);
                          }
                          else{
                            bool plural = gruposSelecionados.length > 1;

                            Infraestrutura.mostrarAviso(
                                context: context,
                                titulo: plural ? "Grupos vazios" : "Grupo vazio",
                                mensagem: "Não existem redeiros associados ${plural ? "aos grupos escolhidos" : "ao grupo escolhido"}. Por favor escolha um ou mais grupos que tenha pelo menos um redeiro associado para agendar o recolhimento.",
                                acaoAoConfirmar: (){
                                  // Resetar grupos escolhidos
                                  setState(() => _gruposDeRedeiros = null);
                                  Navigator.of(context).pop();//Fechar a mensagem
                                }
                            );
                          }
                        }
                        }

                      // Informar tela que foi finalizada a validação dos grupos
                      setState(() => validandoGrupos = false);
                      }
                    );
                  },
                ),
                validandoGrupos ?
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator()
                    ],
                  ),
                ) :
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 60,
                    width: constraints.maxWidth,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                          return Theme.of(context).primaryColor;
                        })
                      ),
                        child: Text(
                          "Próximo",
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                        onPressed: (){

                          if(_dataDoRecolhimento == null)
                            Infraestrutura.mostrarMensagemDeErro(context, "Escolha uma data de recolhimento para prosseguir.");
                          else if(_gruposDeRedeiros == null || _gruposDeRedeiros.isEmpty)
                            Infraestrutura.mostrarMensagemDeErro(context, "Selecione pelo menos um grupo de redeiros para prosseguir.");
                          else{

                            var recolhimento = RecolhimentoDmo(
                              dataDoRecolhimento: _dataDoRecolhimento,
                              gruposDoRecolhimento: _gruposDeRedeiros
                            );

                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => TelaConfirmarRecolhimento(recolhimento, _listaDeCidades, TipoDeManutencao.cadastro))
                            );
                          }

                        }
                    ),
                  ),
                )
              ],
            ),
          );

        }
    );
  }

  /// Valida se todos os elementos selecionados entre dois grupos são iguais. Retorna true caso os grupos sejam diferentes e false caso sejam iguais.
  bool _validarSeGruposSaoIguais(List<GrupoDeRedeirosDmo> listaDegrupos1, List<GrupoDeRedeirosDmo> listaDegrupos2){
    bool saoIguais = false;

    if(listaDegrupos1 == null && listaDegrupos2 == null)
      return false;

    if(listaDegrupos1 == null || listaDegrupos2 == null)
      return true;

    for(GrupoDeRedeirosDmo grupo1 in listaDegrupos1){
      for(GrupoDeRedeirosDmo grupo2 in listaDegrupos2){
        saoIguais = grupo1.idGrupo == grupo2.idGrupo;
      }
    }

    print("São iguais: $saoIguais");
    return !saoIguais;
  }

  /// Busca a lista de cidades para os grupos fornecidos.
  Future<List<String>> _buscarListaDeCidades(List<GrupoDeRedeirosDmo> listaDegrupos) async {

    if(listaDegrupos == null || listaDegrupos.isEmpty)
      return [];

    // Validar se existem redeiros para o recolhimento
    QuerySnapshot redeirosDosGrupos = await RedeiroModel().carregarRedeirosPorGrupos(listaDegrupos.map((e) => e.idGrupo).toList());

    // Obter lista de cidades
    return RedeiroModel().obterCidadesAPartirDosSnaptshots(redeirosDosGrupos.docs.toList());
  }
  //#endregion Métodos

}
