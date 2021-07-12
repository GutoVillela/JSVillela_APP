import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/solicitacao_de_materia_prima_dmo.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/stores/consultar_solicitacoes_redeiros_store.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/widgets/slim_list_view_item_pesquisa.dart';

class TelaConsultarSolicitacoesRedeiros extends StatefulWidget {
  @override
  _TelaConsultarSolicitacoesRedeirosState createState() =>
      _TelaConsultarSolicitacoesRedeirosState();
}

class _TelaConsultarSolicitacoesRedeirosState
    extends State<TelaConsultarSolicitacoesRedeiros> {

  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  /// ScrollController usado para saber se usuário scrollou a lista até o final.
  ScrollController _scrollController = ScrollController();

  /// Store que controla tela de consulta de redeiros.
  final ConsultarSolicitacoesRedeirosStore store = ConsultarSolicitacoesRedeirosStore();
  //#endregion Atributos

  @override
  void initState() {
    super.initState();

    // Adicionando evento de Scroll ao ScrollController
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Quando usuário chegar ao final da lista, obter mais registros
        if (store.temMaisRegistros && store.solicitacoes.isNotEmpty){
          store.obterListaDeSolicitacoesPaginada(false, _buscaController.text);
        }
      }
    });

    store.obterListaDeSolicitacoesPaginada(true, null);
  }

  @override
  Widget build(BuildContext context) {

    // Formatar para para dd/MM/yyyy
    final formatoData = new DateFormat('dd/MM/yyyy');

    return Container(child: LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          child: Observer(
            builder: (_){
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    child: CampoDeTextoComIcone(
                      texto: "Nome do redeiro",
                      icone: Icon(Icons.search, color: PaletaDeCor.AZUL_ESCURO),
                      cor: PaletaDeCor.AZUL_ESCURO,
                      campoDeSenha: false,
                      controller: _buscaController,
                      onChanged: store.setTermoDeBusca,
                      acaoAoSubmeter: store.obterListaDeRedeirosPaginadasComFiltro,
                      regraDeValidacao: (texto){
                        return null;
                      },
                    ),
                  ),
                  Observer(
                    builder: (context){
                      return  CheckboxListTile(
                        title: const Text("Incluir recolhimentos finalizados"),
                        secondary: Icon(Icons.av_timer, color: Theme.of(context).primaryColor),
                        tileColor: PaletaDeCor.AZUL_BEM_CLARO,
                        value: store.incluirSolicitacoesAtendidas,
                        onChanged: store.setIncluirSolicitacoesAtendidas,
                      );
                    },
                  ),
                  store.processando ?
                  Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor
                          ),
                        )
                    ),
                  )
                      : Expanded(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Observer(
                          builder: (_){
                            return RefreshIndicator(
                              child: ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 10),
                                  itemCount: store.solicitacoes.length + 1, // É somado um pois o último widget será um item de carregamento
                                  itemBuilder: (context, index){

                                    if(index == store.solicitacoes.length){
                                      if(store.temMaisRegistros)
                                        return CupertinoActivityIndicator();
                                      else
                                        return Divider();
                                    }

                                    return ListViewItemPesquisa(
                                      textoPrincipal: store.solicitacoes[index].materiasPrimasSolicitadas.first.nomeMateriaPrima +
                                          (store.solicitacoes[index].materiasPrimasSolicitadas.length > 1 ? " e mais ${store.solicitacoes[index].materiasPrimasSolicitadas.length - 1}" : ""),
                                      textoSecundario: store.solicitacoes[index].redeiroSolicitante.nome,
                                      iconeEsquerda: Icons.dns_rounded,
                                      iconeDireita: Icons.search,
                                      acaoAoClicar: (){

                                        // Montar alerta
                                        AlertDialog alerta = AlertDialog(
                                          title: Text("Detalhes da solicitação",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context).primaryColor
                                              )),
                                          content: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Solicitado por:"),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Text(store.solicitacoes[index].redeiroSolicitante.nome,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Theme.of(context).primaryColor,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                ),
                                              ),
                                              Text("Data da solicitação:"),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Text(formatoData.format(store.solicitacoes[index].dataDaSolicitacao.toLocal()),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Theme.of(context).primaryColor,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                ),
                                              ),
                                              Text("Solicitação atendida em:"),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Text(store.solicitacoes[index].dataFinalizacao != null ? formatoData.format(store.solicitacoes[index].dataFinalizacao!) : "Não atendida",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Theme.of(context).primaryColor,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                ),
                                              ),
                                              Text("Materiais solicitados:"),
                                              Expanded(
                                                child: Container(
                                                  width: double.maxFinite,
                                                  child: ListView.builder(
                                                      itemCount: store.solicitacoes[index].materiasPrimasSolicitadas.length,
                                                      itemBuilder: (context, indexMp){
                                                        return SlimListViewItemPesquisa(
                                                          textoPrincipal: store.solicitacoes[index].materiasPrimasSolicitadas[indexMp].nomeMateriaPrima,
                                                          iconeEsquerda: Icons.dns_rounded,
                                                          acaoAoClicar: null,
                                                        );
                                                      }
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("OK")
                                            )
                                          ],
                                        );

                                        // Mostrar alerta
                                        showDialog(
                                            context: context,
                                            builder: (_) => alerta
                                        );
                                      },
                                    );
                                  }
                              ),
                              onRefresh: () async => await store.obterListaDeSolicitacoesPaginada(true, _buscaController.text)
                            );
                          },
                        )
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    )
    );

    // return Container(child: LayoutBuilder(
    //   builder: (context, constraints) {
    //     return Column(children: [
    //       Container(
    //         padding: EdgeInsets.all(12),
    //         child: CampoDeTextoComIcone(
    //           texto: "Pesquisar por nome de redeiro",
    //           icone: Icon(Icons.search, color: PaletaDeCor.AZUL_ESCURO),
    //           cor: PaletaDeCor.AZUL_ESCURO,
    //           campoDeSenha: false,
    //           controller: _buscaController,
    //           acaoAoSubmeter: (String filtro){
    //             setState(() {
    //               resetarCamposDeBusca();
    //               _obterRegistros(true);
    //             });
    //           },
    //           regraDeValidacao: (texto) {
    //             return null;
    //           },
    //         ),
    //       ),
    //       CheckboxListTile(
    //         title: Text("Incluir solicitações já atendidas ?"),
    //         secondary: Icon(Icons.av_timer),
    //         value: _solicitacoesJaAtendidas,
    //         onChanged: (bool? valor) {
    //           setState(() {
    //             _solicitacoesJaAtendidas = valor ?? false;
    //             resetarCamposDeBusca();
    //             _obterRegistros(true);
    //           });
    //         },
    //       ),
    //       _carregandoRegistros ?
    //       Center(
    //           child: CircularProgressIndicator(
    //             valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    //           )
    //       ) :
    //       Expanded(
    //         child: Container(
    //           padding: EdgeInsets.all(10),
    //           child: ListView.builder(
    //               controller: _scrollController,
    //               scrollDirection: Axis.vertical,
    //               shrinkWrap: true,
    //               padding: EdgeInsets.only(top: 10),
    //               itemCount: _listaDeSolicitacoes.length + 1, // É somado um pois o último widget será um item de carregamento
    //               itemBuilder: (context, index){
    //
    //                 if(index == _listaDeSolicitacoes.length){
    //                   if(_temMaisRegistros)
    //                     return CupertinoActivityIndicator();
    //                   else
    //                     return Divider();
    //                 }
    //
    //                 return ListViewItemPesquisa(
    //                   textoPrincipal: _listaDeSolicitacoes[index].materiasPrimasSolicitadas.first.nomeMateriaPrima +
    //                       (_listaDeSolicitacoes[index].materiasPrimasSolicitadas.length > 1 ? " e mais ${_listaDeSolicitacoes[index].materiasPrimasSolicitadas.length - 1}" : ""),
    //                   textoSecundario: _listaDeSolicitacoes[index].redeiroSolicitante.nome,
    //                   iconeEsquerda: Icons.dns_rounded,
    //                   iconeDireita: Icons.search,
    //                   acaoAoClicar: (){
    //
    //                     // Montar alerta
    //                     AlertDialog alerta = AlertDialog(
    //                       title: Text("Detalhes da solicitação",
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                           color: Theme.of(context).primaryColor
    //                         )),
    //                       content: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           Text("Solicitado por:"),
    //                           Padding(
    //                             padding: const EdgeInsets.symmetric(vertical: 8),
    //                             child: Text(_listaDeSolicitacoes[index].redeiroSolicitante.nome,
    //                               style: TextStyle(
    //                                 fontSize: 20,
    //                                 color: Theme.of(context).primaryColor,
    //                                 fontWeight: FontWeight.bold
    //                               )
    //                             ),
    //                           ),
    //                           Text("Data da solicitação:"),
    //                           Padding(
    //                             padding: const EdgeInsets.symmetric(vertical: 8),
    //                             child: Text(formatoData.format(_listaDeSolicitacoes[index].dataDaSolicitacao.toLocal()),
    //                               style: TextStyle(
    //                                 fontSize: 20,
    //                                 color: Theme.of(context).primaryColor,
    //                                 fontWeight: FontWeight.bold
    //                               )
    //                             ),
    //                           ),
    //                           Text("Solicitação atendida em:"),
    //                           Padding(
    //                             padding: const EdgeInsets.symmetric(vertical: 8),
    //                             child: Text(_listaDeSolicitacoes[index].dataFinalizacao != null ? formatoData.format(_listaDeSolicitacoes[index].dataFinalizacao!) : "Não atendida",
    //                                 style: TextStyle(
    //                                     fontSize: 20,
    //                                     color: Theme.of(context).primaryColor,
    //                                     fontWeight: FontWeight.bold
    //                                 )
    //                             ),
    //                           ),
    //                           Text("Materiais solicitados:"),
    //                           Expanded(
    //                             child: Container(
    //                               width: double.maxFinite,
    //                               child: ListView.builder(
    //                                 itemCount: _listaDeSolicitacoes[index].materiasPrimasSolicitadas.length,
    //                                 itemBuilder: (context, indexMp){
    //                                   return SlimListViewItemPesquisa(
    //                                     textoPrincipal: _listaDeSolicitacoes[index].materiasPrimasSolicitadas[indexMp].nomeMateriaPrima,
    //                                     iconeEsquerda: Icons.dns_rounded,
    //                                     acaoAoClicar: null,
    //                                   );
    //                                 }
    //                               ),
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                       actions: [
    //                         TextButton(
    //                           onPressed: (){
    //                             Navigator.of(context).pop();
    //                           },
    //                             child: Text("OK")
    //                         )
    //                       ],
    //                     );
    //
    //                     // Mostrar alerta
    //                     showDialog(
    //                       context: context,
    //                       builder: (_) => alerta
    //                     );
    //                   },
    //                 );
    //               }
    //           ),
    //         ),
    //       )
    //       //return list_view_item_solicitacao
    //     ]);
    //   },
    // ));
  }
  //#endregion Métodos
}
