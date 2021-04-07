import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/ui/tela_editar_recolhimento.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';

import '../tela_informacoes_do_recolhimento.dart';

class TelaConsultarRecolhimento extends StatefulWidget {
  @override
  _TelaConsultarRecolhimentoState createState() => _TelaConsultarRecolhimentoState();
}

class _TelaConsultarRecolhimentoState extends State<TelaConsultarRecolhimento> {
  //#region Atributos

  /// Data inicial do filtro selecionado em tela pelo usuário.
  DateTime _filtroDataInicial;

  /// Data final do filtro selecionado em tela pelo usuário.
  DateTime _filtroDataFinal;

  /// Define se o checkbox "Incluir recolhimentos finalizados" foi marcado
  bool _incluirRecolhimentosFinalizados = false;

  /// Lista de recolhimentos a ser carregada no ListView
  List<RecolhimentoDmo> _listaDeRecolhimentos = [];

  /// Último redeiro carregado em tela.
  DocumentSnapshot _ultimoRecolhimentoCarregado;

  /// Define se existem mais registros a serem carregados na lista.
  bool _temMaisRegistros = true;

  /// Indica que registros estão sendo carregados.
  bool _carregandoRegistros = false;

  /// ScrollController usado para saber se usuário scrollou a lista até o final.
  ScrollController _scrollController = ScrollController();
  //#endregion Atributos

  //#region Métodos

  @override
  void initState() {
    super.initState();

    // Adicionando evento de Scroll ao ScrollController
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(_temMaisRegistros)
          _obterMaisRegistros();
      }
    });

    _obterRegistros(true);
  }

  @override
  Widget build(BuildContext context) {

    // Formatar para para dd/MM/yyyy
    final formatoData = new DateFormat('dd/MM/yyyy');

    _listaDeRecolhimentos.forEach((element) {
      print("ID: ${element.id} | Lista: ${element.gruposDoRecolhimento.length}");
    });

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
                            child: ListTile(
                              leading: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                              title: Text(_filtroDataInicial == null ? "De" : formatoData.format(_filtroDataInicial)),
                              tileColor: PaletaDeCor.AZUL_BEM_CLARO,
                              onTap: () async{
                                DateTime dataSelecionada = await showDatePicker(
                                  context: context,
                                  locale: Locale(WidgetsBinding.instance.window.locale.languageCode, WidgetsBinding.instance.window.locale.countryCode),
                                  initialDate: _filtroDataInicial == null ? (_filtroDataFinal != null && _filtroDataFinal.isBefore(DateTime.now()) ? _filtroDataFinal : DateTime.now()) : _filtroDataInicial,
                                  firstDate: DateTime(1900),
                                  lastDate: _filtroDataFinal == null ? DateTime(3000) : _filtroDataFinal
                                );

                                // Atualizar estado da tela somente se uma data diferente for selecionada
                                if(dataSelecionada != _filtroDataInicial)
                                  setState((){
                                    _filtroDataInicial = dataSelecionada;
                                    resetarCamposDeBusca();
                                    _obterRegistros(true);
                                  });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1),
                            child: ListTile(
                              leading: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                              title: Text(_filtroDataFinal == null ? "Até" : formatoData.format(_filtroDataFinal)),
                              tileColor: PaletaDeCor.AZUL_BEM_CLARO,
                              onTap: () async{
                                DateTime dataSelecionada = await showDatePicker(
                                  context: context,
                                  locale: Locale(WidgetsBinding.instance.window.locale.languageCode, WidgetsBinding.instance.window.locale.countryCode),
                                  initialDate: _filtroDataFinal == null ? (_filtroDataInicial == null ? DateTime.now() : _filtroDataInicial) : _filtroDataFinal,
                                  firstDate: _filtroDataInicial == null ? DateTime(1900) : _filtroDataInicial,
                                  lastDate: DateTime(3000)
                                );

                                // Atualizar estado da tela somente se uma data diferente for selecionada
                                if(dataSelecionada != _filtroDataFinal)
                                  setState((){
                                    _filtroDataFinal = dataSelecionada;
                                    resetarCamposDeBusca();
                                    _obterRegistros(true);
                                  });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: CheckboxListTile(
                        title: Text("Incluir recolhimentos finalizados"),
                        secondary: Icon(Icons.av_timer, color: Theme.of(context).primaryColor),
                        tileColor: PaletaDeCor.AZUL_BEM_CLARO,
                        value: _incluirRecolhimentosFinalizados,
                        onChanged: (bool valor) {
                          setState(() {
                            _incluirRecolhimentosFinalizados = valor;
                            resetarCamposDeBusca();
                            _obterRegistros(true);
                          });
                        },
                      ),
                    ),
                    Divider(),
                    _carregandoRegistros ?
                    Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        )
                    ) :
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 10),
                            itemCount:  _listaDeRecolhimentos.length + 1, // É somado um pois o último widget será um item de carregamento
                            itemBuilder: (context, index){

                              if(index == _listaDeRecolhimentos.length){
                                if(_temMaisRegistros)
                                  return CupertinoActivityIndicator();
                                else
                                  return Divider();
                              }

                              return ListViewItemPesquisa(
                                textoPrincipal: formatoData.format(_listaDeRecolhimentos[index].dataDoRecolhimento.toLocal()),
                                textoSecundario: _listaDeRecolhimentos[index].dataFinalizado != null ? ("Finalizado em ${formatoData.format(_listaDeRecolhimentos[index].dataFinalizado)}.") : "Não finalizado",
                                iconeEsquerda: Icons.directions_car,
                                iconeDireita: Icons.arrow_forward_ios_sharp,
                                acaoAoClicar: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => TelaInformacoesDoRecolhimento(_listaDeRecolhimentos[index]))
                                  );
                                },
                                acoesDoSlidable:
                                _listaDeRecolhimentos[index].dataFinalizado == null ? [
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
                                          MaterialPageRoute(builder: (context) => TelaEditarRecolhimento(_listaDeRecolhimentos[index]))
                                      );
                                    },
                                  )
                                ] : null,
                              );
                            }
                        ),
                      ),
                    )
                  ]
              ),
            );
          },
        )
    );
  }

  /// Método que obtém mais registros após usuário atingir limite de Scroll da ListView.
  void _obterMaisRegistros(){
    _obterRegistros(false);
  }

  /// Método que obtém registros.
  void _obterRegistros(bool resetaLista) {

    if(resetaLista)
      setState(() => _carregandoRegistros = true );

    RecolhimentoModel().carregarRecolhimentosPaginados(_ultimoRecolhimentoCarregado, _filtroDataInicial, _filtroDataFinal, _incluirRecolhimentosFinalizados).then((snapshot) {

      // Obter e salvar último recolhimento
      _ultimoRecolhimentoCarregado = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      // Se a quantidade de registros obtidos na nova busca for menor que a quantidade
      // de registros a se recuperar por vez, então não existem mais documentos a serem carregados.
      if(snapshot.docs.length < Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        _temMaisRegistros = false;

      // Adicionar na lista de redeiros elementos não repetidos
      snapshot.docs.toList().forEach((element) {
        if(!_listaDeRecolhimentos.any((redeiro) => redeiro.id == element.id))
          _listaDeRecolhimentos.add(RecolhimentoDmo.converterSnapshotEmRecolhimento(element));
      });

      if(resetaLista)
        setState(() => _carregandoRegistros = false );
      else
        setState(() { });

    }).catchError((e){
      if(resetaLista)
        setState(() => _carregandoRegistros = false );
      else
        setState(() { });
    });

  }

  /// Reseta os campos de busca para iniciar nova busca.
  void resetarCamposDeBusca(){
    _listaDeRecolhimentos = [];
    _temMaisRegistros = true;
    _ultimoRecolhimentoCarregado = null;
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
          if(_listaDeRecolhimentos[indexRecolhimento].dataIniciado != null && _listaDeRecolhimentos[indexRecolhimento].dataFinalizado == null){
            Infraestrutura.mostrarAviso(context: context,
                titulo: "Recolhimento em andamento",
                mensagem: "Ops... Parece que este recolhimento está em andamento. Por favor finalize o recolhimento para poder apagá-lo!",
                acaoAoConfirmar: () => Navigator.of(context).pop()
            );
          }
          else{
            Infraestrutura.mostrarDialogoDeCarregamento(
                context: context,
                titulo: "Apagando o recolhimento do dia ${_listaDeRecolhimentos[indexRecolhimento].dataDoRecolhimento}..."
            );

            await RecolhimentoModel().apagarRecolhimento(
                idRecolhimento: _listaDeRecolhimentos[indexRecolhimento].id,
                context: context,
                onSuccess: (){
                  // Fechar diálogo de carregamento.
                  Navigator.of(context).pop();
                  setState(() { _listaDeRecolhimentos.removeAt(indexRecolhimento); });
                },
                onFail: (){
                  // Fechar diálogo de carregamento.
                  Navigator.of(context).pop();
                }
            );
          }
        }
    );
  }
//#endregion Métodos
}