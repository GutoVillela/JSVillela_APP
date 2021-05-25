import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/dml/solicitacao_do_redeiro_dmo.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/models/solicitacao_do_redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_solicitacao.dart';
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

  /// Lista de solicitações a ser carregada no ListView
  List<SolicitacaoDoRedeiroDmo> _listaDeSolicitacoes = [];

  /// Última solicitação carregada em tela.
  DocumentSnapshot? _ultimaSolicitacaoCarregada;

  /// Define se existem mais registros a serem carregados na lista.
  bool _temMaisRegistros = true;

  /// Indica que registros estão sendo carregados.
  bool _carregandoRegistros = false;

  /// ScrollController usado para saber se usuário scrollou a lista até o final.
  ScrollController _scrollController = ScrollController();

  /// Define se o checkbox foi marcado
  bool _solicitacoesJaAtendidas = false;
  //#endregion Atributos

  //#region Métodos
  @override
  void initState() {
    super.initState();

    // Adicionando evento de Scroll ao ScrollController
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_temMaisRegistros) _obterMaisRegistros();
      }
    });

    _obterRegistros(true);
  }

  @override
  Widget build(BuildContext context) {

    // Formatar para para dd/MM/yyyy
    final formatoData = new DateFormat('dd/MM/yyyy');

    return Container(child: LayoutBuilder(
      builder: (context, constraints) {
        return Column(children: [
          Container(
            padding: EdgeInsets.all(12),
            child: CampoDeTextoComIcone(
              texto: "Pesquisar por nome de redeiro",
              icone: Icon(Icons.search, color: PaletaDeCor.AZUL_ESCURO),
              cor: PaletaDeCor.AZUL_ESCURO,
              campoDeSenha: false,
              controller: _buscaController,
              acaoAoSubmeter: (String filtro){
                setState(() {
                  resetarCamposDeBusca();
                  _obterRegistros(true);
                });
              },
              regraDeValidacao: (texto) {
                return null;
              },
            ),
          ),
          CheckboxListTile(
            title: Text("Incluir solicitações já atendidas ?"),
            secondary: Icon(Icons.av_timer),
            value: _solicitacoesJaAtendidas,
            onChanged: (bool? valor) {
              setState(() {
                _solicitacoesJaAtendidas = valor ?? false;
                resetarCamposDeBusca();
                _obterRegistros(true);
              });
            },
          ),
          _carregandoRegistros ?
          Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              )
          ) :
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10),
                  itemCount: _listaDeSolicitacoes.length + 1, // É somado um pois o último widget será um item de carregamento
                  itemBuilder: (context, index){

                    if(index == _listaDeSolicitacoes.length){
                      if(_temMaisRegistros)
                        return CupertinoActivityIndicator();
                      else
                        return Divider();
                    }

                    return ListViewItemPesquisa(
                      textoPrincipal: _listaDeSolicitacoes[index].materiasPrimasSolicitadas.first.nomeMateriaPrima +
                          (_listaDeSolicitacoes[index].materiasPrimasSolicitadas.length > 1 ? " e mais ${_listaDeSolicitacoes[index].materiasPrimasSolicitadas.length - 1}" : ""),
                      textoSecundario: _listaDeSolicitacoes[index].redeiroSolicitante.nome,
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
                                child: Text(_listaDeSolicitacoes[index].redeiroSolicitante.nome,
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
                                child: Text(formatoData.format(_listaDeSolicitacoes[index].dataDaSolicitacao.toLocal()),
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
                                child: Text(_listaDeSolicitacoes[index].dataFinalizacao != null ? formatoData.format(_listaDeSolicitacoes[index].dataFinalizacao!) : "Não atendida",
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
                                    itemCount: _listaDeSolicitacoes[index].materiasPrimasSolicitadas.length,
                                    itemBuilder: (context, indexMp){
                                      return SlimListViewItemPesquisa(
                                        textoPrincipal: _listaDeSolicitacoes[index].materiasPrimasSolicitadas[indexMp].nomeMateriaPrima,
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
            ),
          )
          //return list_view_item_solicitacao
        ]);
      },
    ));
  }

  /// Método que obtém mais registros após usuário atingir limite de Scroll da ListView.
  void _obterMaisRegistros(){
    _obterRegistros(false);
  }

  /// Método que obtém registros.
  void _obterRegistros(bool resetaLista) {

    if(resetaLista)
      setState(() => _carregandoRegistros = true );

    SolicitacaoDoRedeiroModel().carregarSolicitacoesPaginadas(_ultimaSolicitacaoCarregada, _buscaController.text, _solicitacoesJaAtendidas).then((snapshot) async {

      // Obter e salvar última solicitação
      _ultimaSolicitacaoCarregada = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      // Se a quantidade de registros obtidos na nova busca for menor que a quantidade
      // de registros a se recuperar por vez, então não existem mais documentos a serem carregados.
      if(snapshot.docs.length < Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        _temMaisRegistros = false;

      // Carregar detalhes das solicitações
      for(DocumentSnapshot doc in snapshot.docs){
        if(!_listaDeSolicitacoes.any((solicitacao) => solicitacao.id == doc.id)){
          SolicitacaoDoRedeiroDmo solicitacaoDoRedeiro = SolicitacaoDoRedeiroDmo.converterSnapshotEmDmo(doc);
          solicitacaoDoRedeiro = await SolicitacaoDoRedeiroModel().carregarDetalhesDaSolicitacao(solicitacaoDoRedeiro);
          _listaDeSolicitacoes.add(solicitacaoDoRedeiro);
        }
      }

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
    _listaDeSolicitacoes = [];
    _temMaisRegistros = true;
    _ultimaSolicitacaoCarregada = null;
  }
  //#endregion Métodos
}
