import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/stores/agendar_recolhimento_store.dart';
import 'package:jsvillela_app/ui/tela_confirmar_recolhimento.dart';
import 'package:jsvillela_app/ui/widgets/custom_drawer.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/widgets/tela_busca_grupos_de_redeiros.dart';
import 'package:mobx/mobx.dart';

class TelaAgendarRecolhimento extends StatefulWidget {

  //#region Atributos

  /// Store usado para gerenciar os estados da tela.
  late final AgendarRecolhimentoStore store;
  //#endregion Atributos

  //#region Construtor(es)
  TelaAgendarRecolhimento({required TipoDeManutencao tipoDeManutencao, RecolhimentoDmo? recolhimentoASerEditado}){
    store = AgendarRecolhimentoStore(tipoDeManutencao: tipoDeManutencao, recolhimentoASerEditado: recolhimentoASerEditado);

    // Em caso de edição, iniciar valores
    if(tipoDeManutencao == TipoDeManutencao.alteracao){
      //store.recolhimentoASerEditado!.gruposDoRecolhimento = await GrupoDeRedeirosModel.of(context).carregarGruposPorId(widget.recolhimentoASerEditado!.gruposDoRecolhimento.map((e) => e.idGrupo).toList());
      store.dataDoRecolhimento = store.recolhimentoASerEditado?.dataDoRecolhimento;
      store.gruposDeRedeiros = ObservableList.of(store.recolhimentoASerEditado?.gruposDoRecolhimento ?? []);

    }
  }
  //#endregion Construtor(es)

  @override
  _TelaAgendarRecolhimentoState createState() => _TelaAgendarRecolhimentoState();
}

class _TelaAgendarRecolhimentoState extends State<TelaAgendarRecolhimento> {

  //#region Métodos
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.store.tipoDeManutencao == TipoDeManutencao.cadastro ? "AGENDAR RECOLHIMENTO" : "EDITAR RECOLHIMENTO"),
          centerTitle: true,
          backgroundColor: PaletaDeCor.AZUL_BEM_CLARO,
        ),
        drawer: widget.store.tipoDeManutencao == TipoDeManutencao.cadastro ? CustomDrawer() : null,
        drawerScrimColor: PaletaDeCor.AZUL_BEM_CLARO,
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){

              return Container(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Center(child: Icon(Icons.directions_car, size: 80, color: Theme.of(context).primaryColor)),
                    SizedBox(height: 20),
                    const Text("Quando será o recolhimento?",
                        style:  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    SizedBox(height: 20),
                    Observer(builder: (_){
                      return ListViewItemPesquisa(
                        textoPrincipal: "Data do Recolhimento",
                        textoSecundario: widget.store.textoDataRecolhimento,
                        iconeEsquerda: Icons.calendar_today,
                        iconeDireita: Icons.arrow_forward_ios_sharp,
                        acaoAoClicar: () async {

                          DateTime? dataSelecionada = await showDatePicker(
                              context: context,
                              locale: Locale(WidgetsBinding.instance!.window.locale.languageCode, WidgetsBinding.instance!.window.locale.countryCode),
                              initialDate: widget.store.dataDoRecolhimento ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 1)
                          );

                          try{
                            await widget.store.setDataDoRecolhimento(dataSelecionada);
                          }
                          catch(e){
                            Infraestrutura.mostrarAviso(
                                context: context,
                                titulo: "Não é possível escolher esta data!",
                                mensagem: e.toString(),
                                acaoAoConfirmar: (){
                                  Navigator.of(context).pop();//Fechar a mensagem
                                }
                            );
                          }


                        },
                      );
                    }),
                    //validandoData ?
                    Observer(builder: (_){
                      return SizedBox(
                        height: 30,
                        child: Center(
                            child: widget.store.validandoData ?
                                CupertinoActivityIndicator()
                                : null
                        ),
                      );
                    }),
                    const Text("Notificar qual grupo de redeiros?",
                        style:  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    SizedBox(height: 20),
                    Observer(builder: (_){
                        return ListViewItemPesquisa(
                          textoPrincipal: "Grupo do Redeiro",
                          textoSecundario: widget.store.textoGruposDoRecolhimento,
                          iconeEsquerda: Icons.people_sharp,
                          iconeDireita: Icons.arrow_forward_ios_sharp,
                          acaoAoClicar: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return TelaBuscaGruposDeRedeiros(gruposJaSelecionados: widget.store.gruposDeRedeiros);
                                }
                            ).then((gruposSelecionados) async {
                              try{
                                await widget.store.setGruposDeRedeiros(gruposSelecionados ?? []);
                              }
                              catch(e){
                                Infraestrutura.mostrarAviso(
                                    context: context,
                                    titulo: "Não foi possível escolher os grupos",
                                    mensagem: e.toString(),
                                    acaoAoConfirmar: (){
                                      print("FECHAR MSG");
                                      Navigator.of(context).pop();//Fechar a mensagem
                                    }
                                );
                              }
                            }
                            );
                          },
                        );
                      }
                    ),
                    Observer(builder: (_){
                      return SizedBox(
                        height: 30,
                        child: Center(
                            child: widget.store.validandoGrupos ?
                            CupertinoActivityIndicator()
                                : null
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 60,
                        width: constraints.maxWidth,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                                  return Theme.of(context).primaryColor;
                                })
                            ),
                            child: Text(
                              "Próximo",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            onPressed: (){

                              if(widget.store.dataDoRecolhimento == null)
                                Infraestrutura.mostrarMensagemDeErro(context, "Escolha uma data de recolhimento para prosseguir.");
                              else if(widget.store.gruposDeRedeiros.isEmpty)
                                Infraestrutura.mostrarMensagemDeErro(context, "Selecione pelo menos um grupo de redeiros para prosseguir.");
                              else{

                                var recolhimento = RecolhimentoDmo(
                                    id: widget.store.recolhimentoASerEditado?.id,
                                    dataDoRecolhimento: widget.store.dataDoRecolhimento ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                    gruposDoRecolhimento: widget.store.gruposDeRedeiros
                                );

                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => TelaConfirmarRecolhimento(recolhimento, widget.store.listaDeCidades, widget.store.tipoDeManutencao))
                                );
                              }

                            }
                        ),
                      ),
                    )
                  ],
                ),
              );

            }
        )
    );
  }

  //#endregion Métodos

}
