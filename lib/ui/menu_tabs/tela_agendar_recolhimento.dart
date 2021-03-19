import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
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
  DateTime _dataDoRecolhimento = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  /// Lista com os grupos de redeiros selecionados.
  List<GrupoDeRedeirosDmo> _gruposDeRedeiros;

  //#endregion Atributos

  @override
  Widget build(BuildContext context) {

    // Formatar para para dd/MM
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
                        initialDate: _dataDoRecolhimento ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1)
                    );

                    // Atualizar estado da tela somente se uma data diferente for selecionada
                    if(dataSelecionada != _dataDoRecolhimento)
                      setState((){
                        _dataDoRecolhimento = dataSelecionada;
                      });
                  },
                ),
                SizedBox(height: 20),
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
                    ).then((gruposSelecionados) {
                      setState(() {
                        if(gruposSelecionados != null)
                          _gruposDeRedeiros = gruposSelecionados;
                      });
                    });
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
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
                        else
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => TelaConfirmarRecolhimento(_dataDoRecolhimento, _gruposDeRedeiros))
                          );

                      }
                  ),
                )
              ],
            ),
          );

        }
    );
  }
}
