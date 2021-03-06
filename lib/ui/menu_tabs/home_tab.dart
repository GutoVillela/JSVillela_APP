import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:jsvillela_app/dml/solicitacao_de_materia_prima_dmo.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/stores/inicio_store.dart';
import 'package:jsvillela_app/ui/widgets/card_de_recolhimento.dart';
import 'package:jsvillela_app/ui/widgets/custom_drawer.dart';
import 'package:jsvillela_app/ui/widgets/slim_list_view_item_pesquisa.dart';

class HomeTab extends StatefulWidget {

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  //#region Atributos
  /// Store que controla tela inicial.
  final InicioStore store = GetIt.I<InicioStore>();
  //#endregion Atributos

  //#region Métodos

  @override
  void initState() {
    super.initState();
    store.carregarRecolhimentoDoDia();
    store.carregarSolicitacoes();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("RECOLHEDOR"),
          centerTitle: true,
          backgroundColor: PaletaDeCor.AZUL_BEM_CLARO,
        ),
        drawer: CustomDrawer(),
        body: Container(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
                return Container(
                  child: Observer(
                    builder: (_){
                      return Column(
                        children: [
                          Center(child: Icon(Icons.directions_car, size: 80, color: Theme.of(context).primaryColor)),
                          SizedBox(height: 20),
                          CardRecolhimento(),
                          !store.recolhimentoEmAndamento ?
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
                                Observer(builder: (context){
                                  // Retorno caso não haja solicitações dos redeiros
                                  if(store.solicitacoesDosRedeiros.isEmpty)
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
                                            itemCount: store.solicitacoesDosRedeiros.length,
                                            itemBuilder: (context, index){
                                              SolicitacaoDeMateriaPrimaDmo solicitacao = store.solicitacoesDosRedeiros[index];
                                              return SlimListViewItemPesquisa(
                                                textoPrincipal: solicitacao.redeiroSolicitante.nome + " - " + solicitacao.materiasPrimasSolicitadas.first.nomeMateriaPrima,
                                                iconeEsquerda: Icons.dns_rounded,
                                                acaoAoClicar: () {},
                                              );

                                            }
                                        ),
                                      ),
                                    );
                                })
                              ],
                            ),
                          ) :
                          SizedBox()
                        ],
                      );
                    },
                  ),
                );
              }
          ),
        ),
        drawerScrimColor: Color.fromARGB(100, 100, 100, 100)
    );
  }
  //#endregion Métodos
}
