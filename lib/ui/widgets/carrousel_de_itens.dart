import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/models/redeiro_do_recolhimento_model.dart';
import 'package:jsvillela_app/ui/widgets/item_do_carrousel.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrouselDeItens extends StatefulWidget {

  //#region Propriedades

  /// Recolhimento com redeiros associados aos Cards.
  final RecolhimentoDmo recolhimento;

  /// Callback a ser executado quando o recolhimento for finalizado.
  final VoidCallback callbackFinalizarRecolhimento;

  //#endregion Propriedades

  //#region Construtor(es)
  CarrouselDeItens(this.recolhimento, this.callbackFinalizarRecolhimento);
  //#endregion Construtor(es)

  @override
  _CarrouselDeItensState createState() => _CarrouselDeItensState();
}

class _CarrouselDeItensState extends State<CarrouselDeItens> {

  //#region Atributos

  /// Indica qual card de redeiro do recolhimento está em foco.
  int _cardAtual = 0;

  /// Define se o recolhimento foi finalizado.
  bool finalizouRecolhimento = false;

  //#endregion Atributos

  @override
  Widget build(BuildContext context) {
    print("Finalizou: ");
    print(finalizouRecolhimento);
    return Center(
      child: Container(
        child: finalizouRecolhimento ?? false ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              )
            ),
            SizedBox(height: 20),
            Text("Finalizando recolhimento..."),
          ],
        ) :
        PageView.builder(

            itemCount: widget.recolhimento.redeirosDoRecolhimento.length,
            controller: PageController(viewportFraction: 0.8, keepPage: true),
            onPageChanged: (int index) => setState(() => _cardAtual = index),
            itemBuilder: (_, index){
              return Transform.scale(
                scale: index == _cardAtual ? 1 : 0.9,
                child: ItemDoCarrousel(widget.recolhimento.redeirosDoRecolhimento[index], widget.recolhimento.id, _callBackFinalizarRecolhimento),
              );
            }
        ),
      ),
    );
  }

  /// Callback executado quando o recolhimento é finalizado.
  void _callBackFinalizarRecolhimento(String idRedeiroDoRecolhimento, DateTime dataFinalizacao){
    widget.recolhimento.redeirosDoRecolhimento.firstWhere((element) => element.id == idRedeiroDoRecolhimento).dataFinalizacao = dataFinalizacao;

    setState(() {
      // Finalizar recolhimento caso todos os redeiros do recolhimentos estejam finalizados.
      finalizouRecolhimento = !widget.recolhimento.redeirosDoRecolhimento.any((element) => element.dataFinalizacao == null);
    });

    // Iniciar callback de finalizar recolhimento quando for identificado que todos os redeiros foram finalizados.
    if(finalizouRecolhimento)
      widget.callbackFinalizarRecolhimento();
  }
}
