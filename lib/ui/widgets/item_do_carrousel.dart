import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/redeiro_do_recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/parse_server/redeiros_do_recolhimento_parse.dart';
import 'package:jsvillela_app/stores/item_do_carrousel_store.dart';
import 'package:jsvillela_app/ui/tela_caderno_do_redeiro.dart';
import 'package:jsvillela_app/ui/widgets/botao_redondo.dart';
import 'package:scoped_model/scoped_model.dart';

/// Widget que constroi um item do carrousel.
class ItemDoCarrousel extends StatefulWidget {

  //#region Propriedades

  /// Store responsável por manipular eventos desta tela.
  late ItemDoCarrouselStore store;

  //#endregion Propriedades

  //#region Construtor(es)
  ItemDoCarrousel({required RedeiroDoRecolhimentoDmo redeiroDoRecolhimento}){
    store = ItemDoCarrouselStore(redeiroDoRecolhimento);
  }
  //#endregion Construtor(es)

  @override
  _ItemDoCarrouselState createState() => _ItemDoCarrouselState();
}

class _ItemDoCarrouselState extends State<ItemDoCarrousel> with AutomaticKeepAliveClientMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    super.build(context);
    
    return Observer(builder: (_){
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: !widget.store.finalizado ? PaletaDeCor.AZUL_BEM_CLARO : PaletaDeCor.VERMELHO_DESFOCADO,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(widget.store.redeiroDoRecolhimento.redeiro!.nome,
                  style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                  )
              ),
              SizedBox(height: 20),
              Text(widget.store.redeiroDoRecolhimento.redeiro!.endereco.toString(),
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  )
              ),
              Observer(builder: (_){
                return SizedBox(height: 20,
                    child: !widget.store.carregandoMapa ? null :
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text("Abrindo mapa..."),
                        CupertinoActivityIndicator(),
                        SizedBox(height: 20)
                      ],
                    )
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Observer(builder: (_){
                    return BotaoRedondo(
                      icone: Icons.perm_contact_cal_sharp,
                      tamanho: 30,
                      corDoBotao: Theme.of(context).primaryColor,
                      acaoAoClicar: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TelaCadernoDoRedeiro(redeiro: widget.store.redeiroDoRecolhimento.redeiro!))
                        );
                      },
                    );
                  }),
                  Observer(builder: (_){
                    return BotaoRedondo(
                      icone: Icons.pin_drop,
                      tamanho: 30,
                      corDoBotao: Theme.of(context).primaryColor,
                      acaoAoClicar: widget.store.carregandoMapa ? null : widget.store.abrirMapa,
                      exibirIconeDeProcessamento: widget.store.carregandoMapa,
                    );
                  }),
                  Observer(builder: (_){
                    return BotaoRedondo(
                      icone: Icons.check,
                      tamanho: 30,
                      corDoBotao: Colors.green[800],
                      exibirIconeDeProcessamento: widget.store.processando,
                      acaoAoClicar: (){

                        Infraestrutura.confirmar(
                            context: context,
                            titulo: "Finalizar recolhimento",
                            mensagem: "Gostaria de finalizar o recolhimento para o(a) redeiro(a) ${widget.store.redeiroDoRecolhimento.redeiro!.nome}?",
                            acaoAoConfirmar: () async {
                              Navigator.of(context).pop();//Fechar mensagem de diálogo

                              await widget.store.finalizarRecolhimentoDoRedeiro();
                            }
                        );
                      },
                    );
                  }),
                  Observer(builder: (_){
                    return BotaoRedondo(
                      icone: Icons.clear,
                      tamanho: 30,
                      corDoBotao: Colors.red,
                      acaoAoClicar: (){

                      },
                    );
                  })
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
