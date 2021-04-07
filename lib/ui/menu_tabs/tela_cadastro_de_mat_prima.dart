import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/materia_prima_model.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/dml/materia_prima_dmo.dart';

import '../tela_cadastrar_nova_materia_prima.dart';

class TelaCadastroDeMateriaPrima extends StatefulWidget {
  @override
  _TelaCadastroDeMateriaPrimaState createState() =>
      _TelaCadastroDeMateriaPrimaState();
}

class _TelaCadastroDeMateriaPrimaState
    extends State<TelaCadastroDeMateriaPrima> {
  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  List<MateriaPrimaDmo> _listaDeMP = [];

  /// Última mp carregada em tela.
  DocumentSnapshot _ultimaMpCarregada;

  /// Define se existem mais registros a serem carregados na lista.
  bool _temMaisRegistros = true;

  /// Indica que registros estão sendo carregados.
  bool _carregandoRegistros = false;

  /// Filtro utilizado na busca
  //String filtro;

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
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: CampoDeTextoComIcone(
                    texto: "Buscar materias primas",
                    icone: Icon(Icons.search, color: PaletaDeCor.AZUL_ESCURO),
                    cor: PaletaDeCor.AZUL_ESCURO,
                    campoDeSenha: false,
                    controller: _buscaController,
                    acaoAoSubmeter: (String filtro) {
                      setState(() {
                        print("Submeteu");
                        //filtro = _buscaController.text;
                        resetarCamposDeBusca();
                        _obterRegistros(true);
                      });
                    },
                    regraDeValidacao: (texto) {
                      return null;
                    },
                  )),
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
                        itemCount: _listaDeMP.length +
                            1, // É somado um pois o último widget será um item de carregamento
                        itemBuilder: (context, index) {
                          if (index == _listaDeMP.length) {
                            if (_temMaisRegistros)
                              return CupertinoActivityIndicator();
                            else
                              return Divider();
                          }

                          return ListViewItemPesquisa(
                              textoPrincipal: _listaDeMP[index].nomeMateriaPrima,
                              textoSecundario: _listaDeMP[index].iconeMateriaPrima,
                              iconeEsquerda: Icons.person,
                              iconeDireita: Icons.search,
                              acoesDoSlidable:[
                                IconSlideAction(
                                  caption: "Apagar",
                                  color: Colors.redAccent,
                                  icon: Icons.delete_forever_sharp,
                                  onTap: () => _apagarMateriaPrima(index),
                                ),
                                IconSlideAction(
                                  caption: "Editar",
                                  color: Colors.yellow[800],
                                  icon: Icons.edit,
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => TelaCadastrarMateriaPrima(tipoDeManutencao: TipoDeManutencao.alteracao, mpASerEditada:  _listaDeMP[index]))
                                    );
                                  },
                                )
                              ]);
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

    MateriaPrimaModel().carregarMpPaginadas(_ultimaMpCarregada, _buscaController.text)
        .then((snapshot) {
      // Obter e salvar último redeiro
      _ultimaMpCarregada = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      // Se a quantidade de registros obtidos na nova busca for menor que a quantidade
      // de registros a se recuperar por vez, então não existem mais documentos a serem carregados.
      if (snapshot.docs.length < Preferencias.QUANTIDADE_REGISTROS_LAZY_LOADING)
        _temMaisRegistros = false;

      // Adicionar na lista de mp elementos não repetidos
      snapshot.docs.toList().forEach((element) {
        if (!_listaDeMP.any((matPrima) => matPrima.id == element.id))
          _listaDeMP.add(MateriaPrimaDmo.converterSnapshotEmDmo(element));
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

    // setState(() {
    //
    // });
  }

  /// Reseta os campos de busca para iniciar nova busca.
  void resetarCamposDeBusca() {
    _listaDeMP = [];
    _temMaisRegistros = true;
    _ultimaMpCarregada = null;
  }

  /// Apagar a matéria-prima.
  void _apagarMateriaPrima(int indexGrupo) async{
    Infraestrutura.confirmar(
        context: context,
        titulo: "Tem certeza que quer apagar esta matéria-prima?",
        mensagem: "Esta ação não pode ser desfeita.",
        acaoAoConfirmar: () async {
          // Fechar diálogo de confirmação
          Navigator.of(context).pop();

          Infraestrutura.mostrarDialogoDeCarregamento(
              context: context,
              titulo: "Apagando o grupo do dia ${_listaDeMP[indexGrupo].nomeMateriaPrima}..."
          );

          await MateriaPrimaModel().apagarMateriaPrima(
              idMateriaPrima: _listaDeMP[indexGrupo].id,
              context: context,
              onSuccess: (){
                // Fechar diálogo de carregamento.
                Navigator.of(context).pop();
                setState(() { _listaDeMP.removeAt(indexGrupo); });
              },
              onFail: (){
                // Fechar diálogo de carregamento.
                Navigator.of(context).pop();
              }
          );
        }
    );
  }
//#endregion Métodos

}
