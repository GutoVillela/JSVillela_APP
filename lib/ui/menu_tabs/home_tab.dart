import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_do_recolhimento_model.dart';
import 'package:jsvillela_app/models/solicitacao_do_redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/card_de_recolhimento.dart';
import 'package:jsvillela_app/ui/widgets/card_recolhimento_em_andamento.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/widgets/slim_list_view_item_pesquisa.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeTab extends StatefulWidget {

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  //#region Atributos

  //#endregion Atributos

  //#region Métodos

  @override
  Widget build(BuildContext context) {

    return Container(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints){
            return ScopedModelDescendant<RecolhimentoModel>(
                builder: (context, child, modelRecolhimento){

                  if(modelRecolhimento.estaCarregando)
                    return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        )
                    );

                  return Container(
                    child: Column(
                      children: [
                        Center(child: Icon(Icons.directions_car, size: 80, color: Theme.of(context).primaryColor)),
                        SizedBox(height: 20),
                        CardRecolhimento(),
                        !modelRecolhimento.recolhimentoEmAndamento ?? false ?
                        Expanded(
                          child: Column(
                            children: [
                              Text("Solicitações dos redeiros",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                ),
                              ),
                              ScopedModelDescendant<SolicitacaoDoRedeiroModel>(
                                  builder: (context, child, modelSolicitacoes){

                                    if(modelSolicitacoes.estaCarregando)
                                      return Expanded(
                                        child: Center(
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                            )
                                        ),
                                      );

                                    // Retorno caso não haja solicitações dos redeiros
                                    if(modelSolicitacoes.solicitacoes.isEmpty)
                                      return Expanded(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.hail, size: 50, color: Colors.grey),
                                              Text("Todas as solicitações foram atendidas",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey
                                                ),
                                              ),
                                            ]
                                        ),
                                      );
                                    else
                                      //Retorno caso haja solicitações dos redeiros.
                                      return Expanded(
                                        child: Container(
                                          //color: Colors.blueGrey,
                                          child: ListView.builder(
                                              padding: EdgeInsets.all(10),
                                              itemCount: modelSolicitacoes.solicitacoes.length,
                                              itemBuilder: (context, index){
                                                return SlimListViewItemPesquisa(
                                                  textoPrincipal: modelSolicitacoes.solicitacoes[index].materiasPrimasSolicitadas.first.nomeMateriaPrima ?? "",
                                                  iconeEsquerda: Icons.dns_rounded,
                                                  acaoAoClicar: () {},
                                                );

                                              }
                                          ),
                                        ),
                                      );
                                  }
                              )
                            ],
                          ),
                        ) :
                        SizedBox()
                      ],
                    ),
                  );
                }
            );

          }
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //
  //   return Container(
  //     child: LayoutBuilder(
  //         builder: (BuildContext context, BoxConstraints constraints){
  //           return ScopedModelDescendant<RecolhimentoModel>(
  //             builder: (context, child, model){
  //               return Container(
  //                 child: Column(
  //                   children: [
  //                     Center(child: Icon(Icons.directions_car, size: 80, color: Theme.of(context).primaryColor)),
  //                     SizedBox(height: 20),
  //                     FutureBuilder<QuerySnapshot>(
  //                       future: RecolhimentoModel().carregarRecolhimentosAgendadosNaData(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)),
  //                       builder: (context, snapshotRecolhimentos){
  //
  //                         if(!snapshotRecolhimentos.hasData)
  //                           return Center(
  //                               child: CircularProgressIndicator(
  //                                 valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
  //                               )
  //                           );
  //
  //                         // Obter recolhimento, caso exista algum
  //                         if(snapshotRecolhimentos.data.docs.any((element) => true))
  //                           _recolhimento = RecolhimentoDmo.converterSnapshotEmRecolhimento(snapshotRecolhimentos.data.docs.first);
  //
  //                         return CardRecolhimento(_recolhimento, constraints);
  //                       },
  //                     ),
  //                     true ?
  //                     Expanded(
  //                       child: Column(
  //                         children: [
  //                           Text("Solicitações dos redeiros",
  //                             style: TextStyle(
  //                                 fontSize: 20,
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Theme.of(context).primaryColor
  //                             ),
  //                           ),
  //                           ScopedModelDescendant<SolicitacaoDoRedeiroModel>(
  //                               builder: (context, child, model){
  //
  //                                 if(model.estaCarregando)
  //                                   return Expanded(
  //                                     child: Center(
  //                                         child: CircularProgressIndicator(
  //                                           valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
  //                                         )
  //                                     ),
  //                                   );
  //
  //                                 // Retorno caso não haja solicitações dos redeiros
  //                                 if(model.solicitacoes.isEmpty)
  //                                   return Expanded(
  //                                     child: Column(
  //                                         mainAxisAlignment: MainAxisAlignment.center,
  //                                         children: [
  //                                           Icon(Icons.hail, size: 50, color: Colors.grey),
  //                                           Text("Todas as solicitações foram atendidas",
  //                                             textAlign: TextAlign.center,
  //                                             style: TextStyle(
  //                                                 fontSize: 16,
  //                                                 fontWeight: FontWeight.w400,
  //                                                 color: Colors.grey
  //                                             ),
  //                                           ),
  //                                         ]
  //                                     ),
  //                                   );
  //                                 else
  //                                   return Expanded(
  //                                     child: Container(
  //                                       //color: Colors.blueGrey,
  //                                       child: ListView.builder(
  //                                           padding: EdgeInsets.all(10),
  //                                           itemCount: model.solicitacoes.length,
  //                                           itemBuilder: (context, index){
  //                                             return ListViewItemPesquisa(
  //                                               textoPrincipal: model.solicitacoes[index].materiasPrimasSolicitadas.first.id,
  //                                               textoSecundario: model.solicitacoes[index].redeiroSolicitante.id,
  //                                               iconeEsquerda: Icons.dns_rounded,
  //                                               iconeDireita: Icons.arrow_forward_ios_sharp,
  //                                               acaoAoClicar: () {},
  //                                             );
  //
  //                                             return ListTile(
  //                                               title: Text("Solicitação número $index"),
  //                                               subtitle: Text("ISSAE MANOLO"),
  //                                               leading: Padding(
  //                                                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //                                                 child: Icon(Icons.system_update_alt_sharp),
  //                                               ),
  //                                               tileColor: PaletaDeCor.AZUL_BEM_CLARO,
  //                                               onTap: (){},
  //                                               shape: RoundedRectangleBorder(
  //                                                   borderRadius: BorderRadius.circular(30)
  //                                               ),
  //                                               contentPadding: EdgeInsets.zero,
  //                                             );
  //                                           }
  //                                       ),
  //                                     ),
  //                                   );
  //
  //                               }
  //                           )
  //                         ],
  //                       ),
  //                     ) :
  //                     SizedBox()
  //                   ],
  //                 ),
  //               );
  //             }
  //           );
  //
  //         }
  //     ),
  //   );
  // }
  //#endregion Métodos
}
