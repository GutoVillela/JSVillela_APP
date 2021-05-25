import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_nova_materia_prima.dart';
import 'package:jsvillela_app/stores/consultar_materia_prima_store.dart';

class TelaCadastroDeMateriaPrima extends StatefulWidget {
  @override
  _TelaCadastroDeMateriaPrimaState createState() =>
      _TelaCadastroDeMateriaPrimaState();
}

class _TelaCadastroDeMateriaPrimaState extends State<TelaCadastroDeMateriaPrima> {
  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  ConsultarMateriaPrimaStore store = ConsultarMateriaPrimaStore();

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
        if (store.temMaisRegistros && store.listaDeMateriaPrima.isNotEmpty)
          store.obterListaDeMateriaPrimaPaginada(false, _buscaController.text);
      }
    });

    store.obterListaDeMateriaPrimaPaginada(true, null);
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
                    acaoAoSubmeter: store.obterListaDeRedePaginadaComFiltro,
                    regraDeValidacao: (texto) {
                      return null;
                    },
                  )
              ),
              store.processando
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
                        itemCount: store.listaDeMateriaPrima.length + 1,
                        itemBuilder: (_, index) {
                          if (index == store.listaDeMateriaPrima.length) {
                            if (store.temMaisRegistros)
                              return CupertinoActivityIndicator();
                            else
                              return Divider();
                          }

                          return ListViewItemPesquisa(
                            acaoAoClicar: null,
                              textoPrincipal: store.listaDeMateriaPrima[index].nomeMateriaPrima,
                              textoSecundario: store.listaDeMateriaPrima[index].iconeMateriaPrima,
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
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TelaCadastrarMateriaPrima(
                                                    tipoDeManutencao:
                                                      TipoDeManutencao.alteracao,
                                                      mpASerEditada:  store.listaDeMateriaPrima[index]
                                                )
                                        )
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

  /// Apagar a matéria-prima.
  void _apagarMateriaPrima(int indexGrupo) async{
    Infraestrutura.confirmar(
        context: context,
        titulo: "Tem certeza que quer apagar esta matéria-prima?",
        mensagem: "Esta ação não pode ser desfeita.",
        acaoAoConfirmar: () async {

          final mp = store.listaDeMateriaPrima[indexGrupo];
          // Fechar diálogo de confirmação
          //Navigator.of(context).pop();

          Infraestrutura.mostrarDialogoDeCarregamento(
              context: context,
              titulo: "Apagando o grupo do dia ${store.listaDeMateriaPrima[indexGrupo].nomeMateriaPrima}..."
          );

          await store.apagarMateriaPrima(mp.id!);
        }
    );
  }
//#endregion Métodos

}
