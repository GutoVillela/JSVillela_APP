import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/stores/card_recolhimento_em_andamento_store.dart';
import 'package:jsvillela_app/ui/widgets/carrousel_de_itens.dart';

import '../tela_caderno_do_redeiro.dart';

class CardRecolhimentoEmAndamento extends StatefulWidget {

  //#region Atributos

  /// Recolhimento associado ao card.
  final RecolhimentoDmo recolhimento;

  /// Flag que indica se processo de cadastrar redeiros está em progresso.
  bool cadastrandoRedeiros = false;

  /// Store que manipula os estados da tela
  final CardRecolhimentoEmAndamentoStore store = CardRecolhimentoEmAndamentoStore();
  //#endregion Atributos

  //#region Construtor(es)
  CardRecolhimentoEmAndamento(this.recolhimento);
  //#endregion Construtor(es)

  @override
  _CardRecolhimentoEmAndamentoState createState() => _CardRecolhimentoEmAndamentoState();
}

class _CardRecolhimentoEmAndamentoState extends State<CardRecolhimentoEmAndamento> {

  //#region Métodos

  @override
  Widget build(BuildContext context) {

    return Expanded(
        child: Column(children: [
          Expanded(child: CarrouselDeItens(widget.recolhimento)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Observer(
                builder: (_){
                  return SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        child: !widget.store.terminandoRecolhimento ?
                        Text("Terminar recolhimento",
                          style: TextStyle(fontSize: 20),
                        ) :
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                return Theme.of(context).primaryColor; // Use the component's default.
                              },
                            )
                        ),
                        onPressed: !widget.store.habilitaBotaoTerminarRecolhimento ? null : widget.store.terminarRecolhimento),
                  );
                }
            ),
          )
        ],)
    );
  }
//#endregion Métodos
}
