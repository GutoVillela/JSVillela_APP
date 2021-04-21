import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/redeiro_do_recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/tela_caderno_do_redeiro.dart';
import 'package:jsvillela_app/ui/widgets/botao_redondo.dart';
import 'package:scoped_model/scoped_model.dart';

/// Widget que constroi um item do carrousel.
class ItemDoCarrousel extends StatefulWidget {

  //#region Propriedades

  /// Redeiro do recolhimento associado ao Card.
  final RedeiroDoRecolhimentoDmo redeiroDoRecolhimento;

  /// ID do Recolhimento.
  final String idDoRecolhimento;

  /// Callback executado após finalização bem sucedida do recolhimento.
  final Function callBackFinalizarRecolhimento;

  //#endregion Propriedades

  //#region Construtor(es)
  ItemDoCarrousel(this.redeiroDoRecolhimento, this.idDoRecolhimento, this.callBackFinalizarRecolhimento);
  //#endregion Construtor(es)

  @override
  _ItemDoCarrouselState createState() => _ItemDoCarrouselState();
}

class _ItemDoCarrouselState extends State<ItemDoCarrousel> with AutomaticKeepAliveClientMixin{

  //#region Atributos

  ///Indica se aplicação está carregando aplicativo de mapa.
  bool carregandoMapa = false;

  //#endregion Atributos

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    super.build(context);

    return FutureBuilder<DocumentSnapshot>(
      future: RedeiroModel().carregarRedeiroPorId(widget.redeiroDoRecolhimento.redeiro!.id!),
      builder: (context, snapshotRedeiro){

        if(!snapshotRedeiro.hasData)
          return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              )
          );

        // Recuperar informações atualizadas do redeiro
        widget.redeiroDoRecolhimento.redeiro = RedeiroDmo.converterSnapshotEmRedeiro(snapshotRedeiro.data!);

        return ScopedModelDescendant<RedeiroDoRecolhimentoModel>(
            builder: (context, child, model){

              if(model.estaCarregando)
                return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    )
                );

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: widget.redeiroDoRecolhimento.dataFinalizacao == null ? PaletaDeCor.AZUL_BEM_CLARO : PaletaDeCor.VERMELHO_DESFOCADO,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(widget.redeiroDoRecolhimento.redeiro!.nome!,
                          style:  TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor
                          )
                      ),
                      SizedBox(height: 20),
                      Text(widget.redeiroDoRecolhimento.redeiro!.endereco.toString(),
                          textAlign: TextAlign.center,
                          style:  TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      carregandoMapa ?
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Text("Abrindo mapa..."),
                          CupertinoActivityIndicator(),
                          SizedBox(height: 20)
                        ],
                      ) :
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
                                  MaterialPageRoute(builder: (context) => TelaCadernoDoRedeiro(widget.redeiroDoRecolhimento.redeiro!))
                              );
                            },
                          ),
                          BotaoRedondo(
                            icone: Icons.pin_drop,
                            tamanho: 30,
                            corDoBotao: Theme.of(context).primaryColor,
                            acaoAoClicar: () async{
                              setState(() => carregandoMapa = true);
                              await Infraestrutura.abrirMapa(widget.redeiroDoRecolhimento.redeiro!.endereco!.posicao!);
                              setState(() => carregandoMapa = false);
                            },
                          ),
                          BotaoRedondo(
                            icone: Icons.check,
                            tamanho: 30,
                            corDoBotao: Colors.green[800],
                            acaoAoClicar: (){

                              Infraestrutura.confirmar(
                                  context: context,
                                  titulo: "Finalizar recolhimento",
                                  mensagem: "Gostaria de finalizar o recolhimento para o(a) redeiro(a) ${widget.redeiroDoRecolhimento.redeiro!.nome}?",
                                  acaoAoConfirmar: (){
                                    Navigator.of(context).pop();//Fechar mensagem de diálogo

                                    widget.redeiroDoRecolhimento.dataFinalizacao = DateTime.now();

                                    print("ID redeiro do recolhimento: ${widget.redeiroDoRecolhimento.id}");
                                    model.finalizarRecolhimentoDoRedeiro(
                                        idRecolhimento: widget.idDoRecolhimento,
                                        idRedeiroDoRecolhimento: widget.redeiroDoRecolhimento.id!,
                                        dataFinalizacao: widget.redeiroDoRecolhimento.dataFinalizacao!
                                    ).then((value) {

                                      // Executar callback
                                      widget.callBackFinalizarRecolhimento(widget.redeiroDoRecolhimento.id, widget.redeiroDoRecolhimento.dataFinalizacao);
                                      setState(() {});
                                    });
                                  }
                              );
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
            }
        );
      }
    );
  }
}
