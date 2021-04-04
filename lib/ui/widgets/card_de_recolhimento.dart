import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_do_recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/botao_arredondado.dart';
import 'package:jsvillela_app/ui/widgets/card_recolhimento_em_andamento.dart';
import 'package:scoped_model/scoped_model.dart';

class CardRecolhimento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RecolhimentoModel>(
        builder: (context, child, modelRecolhimento){
          // Formatar para para dd/MM/yyyy
          final formatoData = new DateFormat('dd/MM/yyyy');

          // Verificar se existe recolhimento do dia.
          bool existeRecolhimento = modelRecolhimento.recolhimentoDoDia != null;

          // Verificar se recolhimento do dia já foi finalizado
          bool recolhimentoDoDiaFinalizado = existeRecolhimento && modelRecolhimento.recolhimentoDoDia.dataFinalizado != null;

          if(!existeRecolhimento || recolhimentoDoDiaFinalizado)
            return _cardNaoExisteRecolhimento(context, formatoData, recolhimentoDoDiaFinalizado);
          else{
            // Obter cidades dos redeiros
            List<String> cidadesDoRecolhimento = RedeiroModel().obterCidadesAPartirDosRedeiros(modelRecolhimento.recolhimentoDoDia.redeirosDoRecolhimento.map((e) => e.redeiro).toList());

            // Verificar se para este recolhimento existe algum redeiro já cadastrado
            return ScopedModel<RedeiroDoRecolhimentoModel>(
              model: RedeiroDoRecolhimentoModel(),
              child: !modelRecolhimento.recolhimentoEmAndamento ?
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: PaletaDeCor.AZUL_BEM_CLARO
                ),
                child: Column(
                  children: [
                    Text(formatoData.format(DateTime.now()),
                        style:  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                        )
                    ),
                    SizedBox(height: 20),
                    existeRecolhimento ?
                    ScopedModelDescendant<RedeiroDoRecolhimentoModel>(
                      builder: (context, child, model){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Você tem um recolhimento agendado para hoje.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16
                                )
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("DESTINO: ", style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: cidadesDoRecolhimento.length,
                                itemBuilder: (context, index) => Text(cidadesDoRecolhimento[index], textAlign: TextAlign.center)
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: (){
                                model.cadastrarRedeirosDoRecolhimento(
                                    idRecolhimento: modelRecolhimento.recolhimentoDoDia.id,
                                    redeirosDoRecolhimento: modelRecolhimento.recolhimentoDoDia.redeirosDoRecolhimento,
                                    onSuccess: (redeirosCadastrados) async {
                                      // Após a Model cadastrar os Redeiros do Recolhimento ela devolve
                                      //no callback uma nova lista dos redeiros cadastrados com ID's preenchidos.
                                      // Portanto esses IDs são recuperados e atribuídos aqui.
                                      modelRecolhimento.recolhimentoDoDia.redeirosDoRecolhimento = redeirosCadastrados;

                                      await _iniciarRecolhimento(context, modelRecolhimento.recolhimentoDoDia.id);
                                    },
                                    onFail: () => _informarFalhaAoIniciarRecolhimento(context));
                              },
                              child: BotaoArredondado(
                                  textoDoBotao: "Iniciar recolhimento"
                              ),
                            )
                          ],
                        );
                      },
                    ) :
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Você não tem nada agendado para hoje. Aproveite o dia!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ) :
              CardRecolhimentoEmAndamento(modelRecolhimento.recolhimentoDoDia),
            );
          }
        }
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   print("Recolhimento em andamento: $recolhimentoEmAndamento");
  //   // Formatar para para dd/MM/yyyy
  //   final formatoData = new DateFormat('dd/MM/yyyy');
  //
  //   // Verificar se existe recolhimentos
  //   existeRecolhimento = widget.recolhimento != null;
  //
  //   bool recolhimentoDoDiaFinalizado = existeRecolhimento && widget.recolhimento.dataFinalizado != null;
  //
  //   if(!existeRecolhimento || recolhimentoDoDiaFinalizado)
  //     return _cardNaoExisteRecolhimento(formatoData, recolhimentoDoDiaFinalizado);
  //   else
  //     // Verificar se para este recolhimento existe algum redeiro já cadastrado
  //     return FutureBuilder<QuerySnapshot>(
  //       future: RedeiroDoRecolhimentoModel().carregarRedeirosDeUmRecolhimento(widget.recolhimento.id),
  //       builder: (context, snapshotRedeiros){
  //
  //         if(!snapshotRedeiros.hasData)
  //           return Center(
  //               child: CircularProgressIndicator(
  //                 valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
  //               )
  //           );
  //
  //         // Inicializar a lista de redeiros do recolhimento, caso exista um recolhimento
  //         if(existeRecolhimento)
  //           widget.recolhimento.redeirosDoRecolhimento = [];
  //
  //         // Obter os redeiros do recolhimento cadastrados no recolhimento
  //         snapshotRedeiros.data.docs.forEach((element) {
  //           widget.recolhimento.redeirosDoRecolhimento.add(RedeiroDoRecolhimentoDmo.converterSnapshotEmRedeiroDoRecolhimento(element));
  //         });
  //
  //         // Verificar se o recolhimento já está em andamento
  //         recolhimentoEmAndamento = widget.recolhimento != null && widget.recolhimento.redeirosDoRecolhimento != null && widget.recolhimento.redeirosDoRecolhimento.any((e) => true);
  //
  //         return ScopedModel<RedeiroDoRecolhimentoModel>(
  //           model: RedeiroDoRecolhimentoModel(),
  //           child: !recolhimentoEmAndamento ?
  //           Container(
  //             padding: EdgeInsets.all(20),
  //             margin: EdgeInsets.all(20),
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(30),
  //                 color: PaletaDeCor.AZUL_BEM_CLARO
  //             ),
  //             child: Column(
  //               children: [
  //                 Text(formatoData.format(DateTime.now()),
  //                     style:  TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold,
  //                         color: Theme.of(context).primaryColor
  //                     )
  //                 ),
  //                 SizedBox(height: 20),
  //                 existeRecolhimento ?
  //                 ScopedModelDescendant<RedeiroDoRecolhimentoModel>(
  //                   builder: (context, child, model){
  //                     return Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Text("Você tem um recolhimento agendado para hoje.",
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                                 fontSize: 16
  //                             )
  //                         ),
  //                         SizedBox(height: 20),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text("DESTINO: ", style: TextStyle(fontWeight: FontWeight.bold)),
  //
  //
  //                           ],
  //                         ),
  //                         FutureBuilder<QuerySnapshot>(
  //                           future: RedeiroModel().carregarRedeirosPorGrupos(widget.recolhimento.gruposDoRecolhimento.map((e) => e.idGrupo).toList()),
  //                           builder: (context, snapshotRedeiros){
  //                             if(!snapshotRedeiros.hasData)
  //                               return Center(
  //                                   child: CupertinoActivityIndicator()
  //                               );
  //
  //                             // Obter redeiros dos grupos
  //                             List<RedeiroDmo> listaDeRedeiros = [];
  //                             snapshotRedeiros.data.docs.forEach((element) {
  //                               listaDeRedeiros.add(RedeiroDmo.converterSnapshotEmRedeiro(element));
  //                             });
  //
  //                             // Converter redeiros em Redeiros do Recolhimento
  //                             widget.recolhimento.redeirosDoRecolhimento = listaDeRedeiros.map((e) => RedeiroDoRecolhimentoDmo(redeiro: e)).toList();
  //
  //                             // Obter cidades dos redeiros
  //                             List<String> cidadesDoRecolhimento = RedeiroModel().obterCidadesDosRedeiros(snapshotRedeiros.data.docs.toList());
  //
  //                             return ListView.builder(
  //                                 shrinkWrap: true,
  //                                 itemCount: cidadesDoRecolhimento.length,
  //                                 itemBuilder: (context, index) => Text(cidadesDoRecolhimento[index], textAlign: TextAlign.center)
  //                             );
  //                           },
  //                         ),
  //                         SizedBox(height: 20),
  //                         GestureDetector(
  //                           onTap: (){
  //                             model.cadastrarRedeirosDoRecolhimento(
  //                                 idRecolhimento: widget.recolhimento.id,
  //                                 redeirosDoRecolhimento: widget.recolhimento.redeirosDoRecolhimento,
  //                                 onSuccess: (redeirosCadastrados) {
  //                                   // Após a Model cadastrar os Redeiros do Recolhimento ela devolve
  //                                   //no callback uma nova lista dos redeiros cadastrados com ID's preenchidos.
  //                                   // Portanto esses IDs são recuperados e atribuídos aqui.
  //                                   widget.recolhimento.redeirosDoRecolhimento = redeirosCadastrados;
  //
  //                                   _iniciarRecolhimento();
  //                                 },
  //                                 onFail: () => _informarFalhaAoIniciarRecolhimento(context));
  //                           },
  //                           child: BotaoArredondado(
  //                               textoDoBotao: "Iniciar recolhimento"
  //                           ),
  //                         )
  //                       ],
  //                     );
  //                   },
  //                 ) :
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Text("Você não tem nada agendado para hoje. Aproveite o dia!",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             fontSize: 16
  //                         )
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ) :
  //           CardRecolhimentoEmAndamento(_finalizarRecolhimento, widget.recolhimento, _finalizarRecolhimento),
  //         );
  //
  //       }
  //     );
  // }

  Widget _cardNaoExisteRecolhimento(BuildContext context, DateFormat formatoData, bool recolhimentoDoDiaFinalizado) => Container(
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: PaletaDeCor.AZUL_BEM_CLARO
    ),
    child: Column(
      children: [
        Text(formatoData.format(DateTime.now()),
            style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor
            )
        ),
        SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(recolhimentoDoDiaFinalizado ?
            "O recolhimento de hoje foi finalizado. Aproveite o resto do dia!" :
            "Você não tem nada agendado para hoje. Aproveite o dia!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16
                )
            ),
          ],
        )
      ],
    ),
  );

  /// Informa a interface que existe um recolhimento em andamento.
  Future<void> _iniciarRecolhimento(BuildContext context, String idRecolhimento) async{
    await RecolhimentoModel.of(context).iniciarRecolhimento(idRecolhimento);
  }

  /// Informa a interface que aconteceu um erro ao iniciar o recolhimento.
  void _informarFalhaAoIniciarRecolhimento(BuildContext context){
    Infraestrutura.mostrarMensagemDeErro(context, "Aconteceu um erro ao iniciar o recolhimento.");
  }
}
