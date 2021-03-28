import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/tela_informacoes_do_redeiro.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';

class TelaCadastroDeRedeiros extends StatefulWidget {
  @override
  _TelaCadastroDeRedeirosState createState() => _TelaCadastroDeRedeirosState();
}

class _TelaCadastroDeRedeirosState extends State<TelaCadastroDeRedeiros> {

  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  /// Lista de redeiros a ser carregada no ListView
  List<RedeiroDmo> _listaDeRedeiros = [];

  /// Último redeiro carregado em tela.
  DocumentSnapshot _ultimoRedeiroCarregado;

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
    return Container(
      child:
      LayoutBuilder(
          builder: (context, constraints){
            return Container(
              height: constraints.maxHeight,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(12),
                    child: CampoDeTextoComIcone(
                      texto: "Nome do redeiro",
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
                      regraDeValidacao: (texto){
                        return null;
                      },
                    ),
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
                          itemCount: _listaDeRedeiros.length + 1, // É somado um pois o último widget será um item de carregamento
                          itemBuilder: (context, index){

                            if(index == _listaDeRedeiros.length){
                              if(_temMaisRegistros)
                                return CupertinoActivityIndicator();
                              else
                                return Divider();
                            }

                            return ListViewItemPesquisa(
                              textoPrincipal: _listaDeRedeiros[index].nome,
                              textoSecundario: _listaDeRedeiros[index].endereco.toString(),
                              iconeEsquerda: Icons.person,
                              iconeDireita: Icons.search,
                              acaoAoClicar: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => TelaInformacoesDoRedeiro(_listaDeRedeiros[index]))
                                );
                              },
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

    RedeiroModel().carregarRedeirosPaginados(_ultimoRedeiroCarregado, _buscaController.text).then((snapshot) {

      // Obter e salvar último redeiro
      _ultimoRedeiroCarregado = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      // Se a quantidade de registros obtidos na nova busca for menor que a quantidade
      // de registros a se recuperar por vez, então não existem mais documentos a serem carregados.
      if(snapshot.docs.length < Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        _temMaisRegistros = false;

      // Adicionar na lista de redeiros elementos não repetidos
      snapshot.docs.toList().forEach((element) {
        if(!_listaDeRedeiros.any((redeiro) => redeiro.id == element.id))
          _listaDeRedeiros.add(RedeiroDmo.converterSnapshotEmRedeiro(element));
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
    _listaDeRedeiros = [];
    _temMaisRegistros = true;
    _ultimoRedeiroCarregado = null;
  }
  //#endregion Métodos
}
