import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/ui/widgets/item_do_carrousel.dart';

class CarrouselDeItens extends StatefulWidget {

  //#region Propriedades

  /// Recolhimento com redeiros associados aos Cards.
  final RecolhimentoDmo recolhimento;

  //#endregion Propriedades

  //#region Construtor(es)
  CarrouselDeItens(this.recolhimento);
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

    print("############################# widget.recolhimento: ${widget.recolhimento}");
    print("############################# widget.recolhimento.redeirosDoRecolhimento: ${widget.recolhimento.redeirosDoRecolhimento}");

    return Center(
      child: Container(
        child: finalizouRecolhimento ?
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
                child: ItemDoCarrousel(redeiroDoRecolhimento: widget.recolhimento.redeirosDoRecolhimento[index]),
              );
            }
        ),
      ),
    );
  }
}
