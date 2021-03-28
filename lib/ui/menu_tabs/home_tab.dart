import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_do_recolhimento_model.dart';
import 'package:jsvillela_app/ui/widgets/card_de_recolhimento.dart';
import 'package:jsvillela_app/ui/widgets/card_recolhimento_em_andamento.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeTab extends StatefulWidget {

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  //#region Atributos

  /// Recolhimento do dia, caso exista.
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

                      return CardRecolhimento(_recolhimento, constraints);
                    },
                  )
                ],
              ),
            );

          }
      ),
    );
  }
  //#endregion Métodos
}
