import 'package:flutter/material.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/widgets/tela_busca_grupos_de_redeiros.dart';

class TelaAgendarRecolhimento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  textoSecundario: "Nenhuma data selecionada",
                  iconeEsquerda: Icons.calendar_today,
                  iconeDireita: Icons.arrow_forward_ios_sharp,
                  acaoAoClicar: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return TelaBuscaGruposDeRedeiros(gruposJaSelecionados: null);
                        }
                    ).then((gruposSelecionados) {

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
                  textoPrincipal: "Grupo(s) do recolhimento",
                  textoSecundario: "Nenhum grupo selecionado",
                  iconeEsquerda: Icons.calendar_today,
                  iconeDireita: Icons.arrow_forward_ios_sharp,
                  acaoAoClicar: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return TelaBuscaGruposDeRedeiros(gruposJaSelecionados: null);
                        }
                    ).then((gruposSelecionados) {

                    });
                  },
                ),
              ],
            ),
          );
          
        }
    );
  }
}
