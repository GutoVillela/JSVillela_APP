import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/stores/consultar_recolhimentos_store.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_agendar_recolhimento.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';

import '../tela_informacoes_do_recolhimento.dart';

class TelaConsultarRecolhimento extends StatefulWidget {
  @override
  _TelaConsultarRecolhimentoState createState() => _TelaConsultarRecolhimentoState();
}

class _TelaConsultarRecolhimentoState extends State<TelaConsultarRecolhimento> {

  //#region Atributos

  /// Store que controla tela de consulta de recolhimentos.
  ConsultarRecolhimentosStore store = GetIt.I<ConsultarRecolhimentosStore>();

  /// ScrollController usado para saber se usuário scrollou a lista até o final.
  final ScrollController _scrollController = ScrollController();
  //#endregion Atributos

  //#region Métodos

  @override
  void initState() {
    super.initState();

    // Adicionando evento de Scroll ao ScrollController
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Quando usuário chegar ao final da lista, obter mais registros
        if (store.temMaisRegistros && store.listaDeRecolhimentos.isNotEmpty){
          store.obterListaPaginadaDeRecolhimentos(false);
        }
      }
    });

    store.obterListaPaginadaDeRecolhimentos(true);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        child:
        LayoutBuilder(
          builder: (context, constraints){
            return Container(
              padding: EdgeInsets.all(10),
              height: constraints.maxHeight,
              child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 1),
                            child: Observer(
                              builder: (context){
                                return ListTile(
                                  leading: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                                  title: Text(store.textoFiltroDataInicial),
                                  tileColor: PaletaDeCor.AZUL_BEM_CLARO,
                                  onTap: () async{
                                    DateTime? dataSelecionada = await showDatePicker(
                                        context: context,
                                        locale: Locale(WidgetsBinding.instance!.window.locale.languageCode, WidgetsBinding.instance!.window.locale.countryCode),
                                        initialDate: store.filtroDataInicial == null ? (store.filtroDataFinal != null && store.filtroDataFinal!.isBefore(DateTime.now()) ? store.filtroDataFinal! : DateTime.now()) : store.filtroDataInicial!,
                                        firstDate: DateTime(1900),
                                        lastDate: store.filtroDataFinal == null ? DateTime(3000) : store.filtroDataFinal!
                                    );

                                    store.setFiltroDataInicial(dataSelecionada);
                                  },
                                );
                              }
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1),
                            child: Observer(
                              builder: (context){
                                return ListTile(
                                  leading: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                                  title: Text(store.textoFiltroDataFinal),
                                  tileColor: PaletaDeCor.AZUL_BEM_CLARO,
                                  onTap: () async{
                                    DateTime? dataSelecionada = await showDatePicker(
                                        context: context,
                                        locale: Locale(WidgetsBinding.instance!.window.locale.languageCode, WidgetsBinding.instance!.window.locale.countryCode),
                                        initialDate: store.filtroDataFinal == null ? (store.filtroDataInicial == null ? DateTime.now() : store.filtroDataInicial!) : store.filtroDataFinal!,
                                        firstDate: store.filtroDataInicial == null ? DateTime(1900) : store.filtroDataInicial!,
                                        lastDate: DateTime(3000)
                                    );

                                    store.setFiltroDataFinal(dataSelecionada);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Observer(
                        builder: (_){
                          return CheckboxListTile(
                            title: const Text("Incluir recolhimentos finalizados"),
                            secondary: Icon(Icons.av_timer, color: Theme.of(context).primaryColor),
                            tileColor: PaletaDeCor.AZUL_BEM_CLARO,
                            value: store.incluirRecolhimentosFinalizados,
                            onChanged: store.setIncluirRecolhimentosFinalizados,
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Observer(builder: (_){

                      return Container(
                        child: store.processando ?
                        Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor
                              ),
                            )
                        ) :
                        Expanded(
                          child: Container(
                            child: Observer(
                              builder: (_){
                                return RefreshIndicator(
                                    child: ListView.builder(
                                        controller: _scrollController,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(top: 10),
                                        itemCount:  store.listaDeRecolhimentos.length + 1, // É somado um pois o último widget será um item de carregamento
                                        itemBuilder: (context, index){

                                          if(index == store.listaDeRecolhimentos.length){
                                            if(store.temMaisRegistros)
                                              return CupertinoActivityIndicator();
                                            else
                                              return Divider();
                                          }

                                          /// Formatar para para dd/MM/yyyy
                                          final formatoData = new DateFormat('dd/MM/yyyy');

                                          return ListViewItemPesquisa(
                                            textoPrincipal: formatoData.format(store.listaDeRecolhimentos[index].dataDoRecolhimento.toLocal()),
                                            textoSecundario: store.listaDeRecolhimentos[index].dataFinalizado != null ? ("Finalizado em ${formatoData.format(store.listaDeRecolhimentos[index].dataFinalizado!)}.") : "Não finalizado",
                                            iconeEsquerda: Icons.directions_car,
                                            iconeDireita: Icons.arrow_forward_ios_sharp,
                                            acaoAoClicar: () async {

                                              // Buscar grupos do recolhimento caso não tenha sido buscado inicialmente
                                              if(store.listaDeRecolhimentos[index].gruposDoRecolhimento.isEmpty){
                                                Infraestrutura.mostrarDialogoDeCarregamento(
                                                    context: context,
                                                    titulo: "Buscando grupos do recolhimento..."
                                                );

                                                store.listaDeRecolhimentos[index].gruposDoRecolhimento = await store.buscarGruposDoRecolhimento(store.listaDeRecolhimentos[index].id!);

                                                // Fechar diálogo de carregamento.
                                                Navigator.of(context).pop();
                                              }

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => TelaInformacoesDoRecolhimento(store.listaDeRecolhimentos[index]))
                                              );
                                            },
                                            acoesDoSlidable:
                                            store.listaDeRecolhimentos[index].dataFinalizado == null ? [
                                            IconSlideAction(
                                              caption: "Apagar",
                                              color: Colors.redAccent,
                                              icon: Icons.delete_forever_sharp,
                                              onTap: () => _apagarRecolhimento(index),
                                            ),
                                            IconSlideAction(
                                              caption: "Editar",
                                              color: Colors.yellow[800],
                                              icon: Icons.edit,
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder: (context) => TelaAgendarRecolhimento(tipoDeManutencao: TipoDeManutencao.alteracao, recolhimentoASerEditado: store.listaDeRecolhimentos[index]))
                                                );
                                              },
                                            )
                                            ] : null,
                                          );
                                        }
                                    ),
                                    onRefresh: () async => store.obterListaPaginadaDeRecolhimentos(true)
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    })
                  ]
              ),
            );
          },
        )
    );
  }

  /// Apagar o recolhimento.
  void _apagarRecolhimento(int indexRecolhimento) async{
    Infraestrutura.confirmar(
        context: context,
        titulo: "Tem certeza que quer apagar o registro deste recolhimento?",
        mensagem: "Esta ação não pode ser desfeita.",
        acaoAoConfirmar: () async {
          // Fechar diálogo de confirmação
          Navigator.of(context).pop();

          // Verificar se o recolhimento está em andamento
          if(store.listaDeRecolhimentos[indexRecolhimento].dataIniciado != null && store.listaDeRecolhimentos[indexRecolhimento].dataFinalizado == null){
            Infraestrutura.mostrarAviso(context: context,
                titulo: "Recolhimento em andamento",
                mensagem: "Ops... Parece que este recolhimento está em andamento. Por favor finalize o recolhimento para poder apagá-lo!",
                acaoAoConfirmar: () => Navigator.of(context).pop()
            );
          }
          else{
            Infraestrutura.mostrarDialogoDeCarregamento(
                context: context,
                titulo: "Apagando o recolhimento do dia ${store.listaDeRecolhimentos[indexRecolhimento].dataDoRecolhimento}..."
            );

            await store.apagarRecolhimento(store.listaDeRecolhimentos[indexRecolhimento].id!);

            // Fechar diálogo de carregamento.
            Navigator.of(context).pop();
          }
        }
    );
  }
  //#endregion Métodos
}