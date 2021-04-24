import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/rede_model.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_nova_rede.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/dml/rede_dmo.dart';

class TelaCadastroDeRedes extends StatefulWidget {
  @override
  _TelaCadastroDeRedesState createState() => _TelaCadastroDeRedesState();
}

class _TelaCadastroDeRedesState extends State<TelaCadastroDeRedes> {

  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  List<RedeDmo> _listaDeRedes = [];

  /// Última rede carregada em tela.
  DocumentSnapshot? _ultimaRedeCarregada;

  /// Define se existem mais registros a serem carregados na lista.
  bool _temMaisRegistros = true;

  /// Indica que registros estão sendo carregados.
  bool _carregandoRegistros = false;

  /// ScrollController usado para saber se usuário scrollou a lista até o final.
  ScrollController _scrollController = ScrollController();
  //#endregion Atributos

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
    return Container(child: LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                child: CampoDeTextoComIcone(
                  texto: "Buscar redes",
                  icone: Icon(Icons.search, color: PaletaDeCor.AZUL_ESCURO),
                  cor: PaletaDeCor.AZUL_ESCURO,
                  campoDeSenha: false,
                  controller: _buscaController,
                  acaoAoSubmeter: (String filtro) {
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
              _carregandoRegistros
                  ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ))
                  : Expanded(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10),
                        itemCount: _listaDeRedes.length +
                            1, // É somado um pois o último widget será um item de carregamento
                        itemBuilder: (context, index) {
                          if (index == _listaDeRedes.length) {
                            if (_temMaisRegistros)
                              return CupertinoActivityIndicator();
                            else
                              return Divider();
                          }

                          return ListViewItemPesquisa(
                            acaoAoClicar: null,
                              textoPrincipal: _listaDeRedes[index].nome_rede!,
                              textoSecundario: "R\$ " + _listaDeRedes[index].valor_unitario_rede.toString(),
                              iconeEsquerda: Icons.person,
                              iconeDireita: Icons.search,
                              acoesDoSlidable:[
                                IconSlideAction(
                                  caption: "Apagar",
                                  color: Colors.redAccent,
                                  icon: Icons.delete_forever_sharp,
                                  onTap: () => _apagarRede(index),
                                ),
                                IconSlideAction(
                                  caption: "Editar",
                                  color: Colors.yellow[800],
                                  icon: Icons.edit,
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => TelaCadastrarNovaRede(tipoDeManutencao: TipoDeManutencao.alteracao, redeASerEditada:  _listaDeRedes[index]))
                                    );
                                  },
                                )
                              ]
                          );
                        })),
              )
            ],
          ),
        );
      },
    ));
  }

  /// Método que obtém mais registros após usuário atingir limite de Scroll da ListView.
  void _obterMaisRegistros() {
    _obterRegistros(false);
  }

  /// Método que obtém registros.
  void _obterRegistros(bool resetaLista) {
    if (resetaLista) setState(() => _carregandoRegistros = true);

    RedeModel().carregarRedesPaginadas(_ultimaRedeCarregada, _buscaController.text)
        .then((snapshot) {
      // Obter e salvar último redeiro
      _ultimaRedeCarregada = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      // Se a quantidade de registros obtidos na nova busca for menor que a quantidade
      // de registros a se recuperar por vez, então não existem mais documentos a serem carregados.
      if (snapshot.docs.length < Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        _temMaisRegistros = false;

      // Adicionar na lista de redes elementos não repetidos
      snapshot.docs.toList().forEach((element) {
        if (!_listaDeRedes.any((matPrima) => matPrima.id == element.id))
          _listaDeRedes.add(RedeModel().converterSnapshotEmRede(element));
      });

      if (resetaLista)
        setState(() => _carregandoRegistros = false);
      else
        setState(() {});
    }).catchError((e) {
      if (resetaLista)
        setState(() => _carregandoRegistros = false);
      else
        setState(() {});
    });

  }

  /// Reseta os campos de busca para iniciar nova busca.
  void resetarCamposDeBusca() {
    _listaDeRedes = [];
    _temMaisRegistros = true;
    _ultimaRedeCarregada = null;
  }

  /// Apagar a rede.
  void _apagarRede(int indexGrupo) async{
    Infraestrutura.confirmar(
        context: context,
        titulo: "Tem certeza que quer apagar esta rede?",
        mensagem: "Esta ação não pode ser desfeita.",
        acaoAoConfirmar: () async {
          // Fechar diálogo de confirmação
          Navigator.of(context).pop();

          Infraestrutura.mostrarDialogoDeCarregamento(
              context: context,
              titulo: "Apagando o grupo do dia ${_listaDeRedes[indexGrupo].nome_rede}..."
          );

          await RedeModel().apagarRede(
              idRede: _listaDeRedes[indexGrupo].id!,
              context: context,
              onSuccess: (){
                // Fechar diálogo de carregamento.
                Navigator.of(context).pop();
                setState(() { _listaDeRedes.removeAt(indexGrupo); });
              },
              onFail: (){
                // Fechar diálogo de carregamento.
                Navigator.of(context).pop();
              }
          );
        }
    );
  }
}
