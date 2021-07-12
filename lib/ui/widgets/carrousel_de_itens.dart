import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/stores/carrousel_de_itens_store.dart';
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

  /// Store que manipula informações da tela.
  final CarrouselDeItensStore store = GetIt.I<CarrouselDeItensStore>();

  //#endregion Atributos

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Observer(
        builder: (context){
          return Container(
            child: store.finalizouRecolhimento ?
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
            Observer(builder: (_){
              return PageView.builder(

                  itemCount: widget.recolhimento.redeirosDoRecolhimento.length,
                  controller: store.controller,
                  onPageChanged: store.setCardAtual,
                  itemBuilder: (_, index){
                    return Observer(
                      builder: (_){
                        return Transform.scale(
                          scale: index == store.cardAtual ? 1 : 0.9,
                          child: ItemDoCarrousel(redeiroDoRecolhimento: widget.recolhimento.redeirosDoRecolhimento[index]),
                        );
                      },
                    );
                  }
              );
            }),
          );
        },
      ),
    );
  }
}
