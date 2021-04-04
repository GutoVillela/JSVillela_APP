import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';

class TelaCadastroDeGruposDeRedeiros extends StatefulWidget {
  @override
  _TelaCadastroDeGruposDeRedeirosState createState() => _TelaCadastroDeGruposDeRedeirosState();
}

class _TelaCadastroDeGruposDeRedeirosState extends State<TelaCadastroDeGruposDeRedeiros> {

  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  List<GrupoDeRedeirosDmo> _listaDeGruposDeRedeiros = [];

  /// Último grupo carregado em tela.
  DocumentSnapshot _ultimoGrupoCarregado;

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
                  texto: "Buscar grupos",
                  icone: Icon(Icons.search, color: PaletaDeCor.AZUL_ESCURO),
                  cor: PaletaDeCor.AZUL_ESCURO,
                  campoDeSenha: false,
                  controller: _buscaController,
                  acaoAoSubmeter: (String filtro) {
                    setState(() {
                      print("Submeteu");
                      print(_buscaController.text);
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
                        itemCount: _listaDeGruposDeRedeiros.length +
                            1, // É somado um pois o último widget será um item de carregamento
                        itemBuilder: (context, index) {
                          if (index == _listaDeGruposDeRedeiros.length) {
                            if (_temMaisRegistros)
                              return CupertinoActivityIndicator();
                            else
                              return Divider();
                          }

                          return ListViewItemPesquisa(
                              textoPrincipal: _listaDeGruposDeRedeiros[index].nomeGrupo,
                              textoSecundario: "Id" + _listaDeGruposDeRedeiros[index].idGrupo.toString(),
                              iconeEsquerda: Icons.group,
                              iconeDireita: Icons.search
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

    print("obter_mais_registros");
    GrupoDeRedeirosModel().carregarGruposDeRedeirosPaginados(_ultimoGrupoCarregado, _buscaController.text)
        .then((snapshot) {
      // Obter e salvar último grupo
      _ultimoGrupoCarregado = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      // Se a quantidade de registros obtidos na nova busca for menor que a quantidade
      // de registros a se recuperar por vez, então não existem mais documentos a serem carregados.
      if (snapshot.docs.length < Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        _temMaisRegistros = false;

      // Adicionar na lista de redes elementos não repetidos
      snapshot.docs.toList().forEach((element) {
        if (!_listaDeGruposDeRedeiros.any((grupoDeRedeiros) => grupoDeRedeiros.idGrupo == element.id))
          _listaDeGruposDeRedeiros.add(GrupoDeRedeirosModel().converterSnapshotEmGrupoDeRedeiros(element));
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
    _listaDeGruposDeRedeiros = [];
    _temMaisRegistros = true;
    _ultimoGrupoCarregado = null;
  }
}
