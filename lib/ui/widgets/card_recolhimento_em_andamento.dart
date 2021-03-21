import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/botao_arredondado.dart';
import 'package:jsvillela_app/ui/widgets/botao_redondo.dart';

import '../tela_caderno_do_redeiro.dart';

class CardRecolhimentoEmAndamento extends StatefulWidget {

  //#region Atributos

  /// Ação do botão "Finalizar recolhimento"
  final Function acaoBotaoFinalizar;

  /// Recolhimento associado ao card.
  final RecolhimentoDmo recolhimento;

  /// Constantes do LayoutBuilder parent.
  final BoxConstraints constraints;
  //#endregion Atributos

  //#region Construtor(es)
  CardRecolhimentoEmAndamento(this.acaoBotaoFinalizar, this.recolhimento, this.constraints);
  //#endregion Construtor(es)

  @override
  _CardRecolhimentoEmAndamentoState createState() => _CardRecolhimentoEmAndamentoState();
}

class _CardRecolhimentoEmAndamentoState extends State<CardRecolhimentoEmAndamento> {

  //#region Atributos

  /// Indica qual card de redeiro do recolhimento está em foco.
  int _cardAtual = 0;

  //#endregion Atributos

  //#region Métodos
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<QuerySnapshot>(
        future: RedeiroModel().carregarRedeirosPorGrupos(widget.recolhimento.gruposDoRecolhimento.map((e) => e.idGrupo).toList()),
        builder: (context, snapshotRecolhimento){

          if(!snapshotRecolhimento.hasData)
            return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                )
            );

          // Obter redeiros dos grupos
          List<RedeiroDmo> listaDeRedeiros = [];
          snapshotRecolhimento.data.docs.forEach((element) {
            listaDeRedeiros.add(RedeiroModel().converterSnapshotEmRedeiro(element));
          });

          return carrouselDeItens(context, listaDeRedeiros);
        },
      ),
    );
  }

  /// Widget que constroi um carrousel.
  Widget carrouselDeItens(BuildContext context, List<RedeiroDmo> listaDeRedeiros) => Center(
    child: Container(
      child: PageView.builder(
          itemCount: listaDeRedeiros.length,
          controller: PageController(viewportFraction: 0.8),
          onPageChanged: (int index) => setState(() => _cardAtual = index),
          itemBuilder: (_, index){
            return Transform.scale(
              scale: index == _cardAtual ? 1 : 0.9,
              child: itemDoCarrousel(context, listaDeRedeiros[index]),
            );
          }
      ),
    ),
  );

  /// Widget que constroi um item do carrousel.
  Widget itemDoCarrousel(BuildContext context, RedeiroDmo redeiro) => Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: PaletaDeCor.AZUL_BEM_CLARO,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(redeiro.nome,
              style:  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
              )
          ),
          SizedBox(height: 20),
          Text(redeiro.endereco.toString(),
              textAlign: TextAlign.center,
              style:  TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              )
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BotaoRedondo(
                icone: Icons.perm_contact_cal_sharp,
                tamanho: 30,
                corDoBotao: Theme.of(context).primaryColor,
                acaoAoClicar: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TelaCadernoDoRedeiro(redeiro))
                  );
                },
              ),
              BotaoRedondo(
                icone: Icons.pin_drop,
                tamanho: 30,
                corDoBotao: Theme.of(context).primaryColor,
                acaoAoClicar: (){

                },
              ),
              BotaoRedondo(
                icone: Icons.check,
                tamanho: 30,
                corDoBotao: Colors.green[800],
                acaoAoClicar: (){

                },
              ),
              BotaoRedondo(
                icone: Icons.clear,
                tamanho: 30,
                corDoBotao: Colors.red,
                acaoAoClicar: (){

                },
              ),
            ],
          )
        ],
      ),
    ),
  );
//#endregion Métodos
}
