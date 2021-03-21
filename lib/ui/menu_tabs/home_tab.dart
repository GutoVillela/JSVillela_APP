import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/ui/widgets/card_de_recolhimento.dart';
import 'package:jsvillela_app/ui/widgets/card_recolhimento_em_andamento.dart';

class HomeTab extends StatefulWidget {

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  //#region Atributos

  bool recolhimentoEmAndamento = false;

  // Recolhimento do dia, caso exista.
  RecolhimentoDmo _recolhimento;

  //#endregion Atributos

  //#region Métodos

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints){
            return Container(
              child: Column(
                children: [
                  Center(child: Icon(Icons.directions_car, size: 80, color: Theme.of(context).primaryColor)),
                  SizedBox(height: 20),

                  !recolhimentoEmAndamento ?
                  FutureBuilder<QuerySnapshot>(
                    future: RecolhimentoModel().carregarRecolhimentosAgendadosNaData(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)),
                    builder: (context, snapshotRecolhimentos){

                      if(!snapshotRecolhimentos.hasData)
                        return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            )
                        );

                      // Obter recolhimento, caso exista algum
                      if(snapshotRecolhimentos.data.docs.any((element) => true))
                        _recolhimento = RecolhimentoModel().converterSnapshotEmRecolhimento(snapshotRecolhimentos.data.docs.first);

                      return Container(margin: EdgeInsets.all(20.0),child: CardRecolhimento(iniciarRecolhimento, _recolhimento));
                    },
                  ) :
                  CardRecolhimentoEmAndamento(finalizarRecolhimento, _recolhimento, constraints),
                  SizedBox(height: 20)
                ],
              ),
            );

          }
      ),
    );
  }

  /// Informa a interface que existe um recolhimento em andamento.
  void iniciarRecolhimento(){
    setState(() {
      recolhimentoEmAndamento = true;
    });
  }

  /// Informa a interface que o recolhimento foi finalizado.
  void finalizarRecolhimento(){
    setState(() {
      recolhimentoEmAndamento = false;
    });
  }
  //#endregion Métodos
}
