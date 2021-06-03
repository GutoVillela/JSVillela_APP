import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_nova_rede.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/stores/consultar_rede_store.dart';

class TelaCadastroDeRedes extends StatefulWidget {
  @override
  _TelaCadastroDeRedesState createState() => _TelaCadastroDeRedesState();
}

class _TelaCadastroDeRedesState extends State<TelaCadastroDeRedes> {

  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  /// ScrollController usado para saber se usuário scrollou a lista até o final.
  ScrollController _scrollController = ScrollController();

  /// Store que controla tela de consulta de redes.
  ConsultarRedeStore store = GetIt.I<ConsultarRedeStore>();
  //#endregion Atributos

  @override
  void initState() {
    super.initState();

    // Adicionando evento de Scroll ao ScrollController
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (store.temMaisRegistros && store.listaDeRede.isNotEmpty)
          store.obterListaDeRedePaginada(false, _buscaController.text);
      }
    });

    store.obterListaDeRedePaginada(true, null);
  }

  @override
  Widget build(BuildContext context) {

    // Formato de moeda
    final formatoMoeda = new NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).languageCode);
    
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
                      texto: "Buscar redes",
                      icone: Icon(Icons.search, color: PaletaDeCor.AZUL_ESCURO),
                      cor: PaletaDeCor.AZUL_ESCURO,
                      campoDeSenha: false,
                      controller: _buscaController,
                      acaoAoSubmeter: store.obterListaDeRedePaginadaComFiltro,
                      regraDeValidacao: (texto){
                        return null;
                      },
                    ),
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
                        child: Observer(
                            builder: (_){
                              return ListView.separated(
                                  controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 10),
                                  itemCount: store.listaDeRede.length + 1, // É somado um pois o último widget será um item de carregamento
                                  separatorBuilder: (_, __){
                                    return Divider();
                                  },
                                  itemBuilder: (_, index) {
                                    if (index == store.listaDeRede.length) {
                                      if (store.temMaisRegistros)
                                        return CupertinoActivityIndicator();
                                      else
                                        return Divider();
                                    }

                                    return ListViewItemPesquisa(
                                        acaoAoClicar: null,
                                        textoPrincipal: store.listaDeRede[index].nomeRede,
                                        textoSecundario: formatoMoeda.format(store.listaDeRede[index].valorUnitarioRede),
                                        iconeEsquerda: Icons.person,
                                        iconeDireita: Icons.search,
                                        acoesDoSlidable: [
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
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TelaCadastrarNovaRede(
                                                              tipoDeManutencao: TipoDeManutencao
                                                                  .alteracao,
                                                              redeASerEditada: store.listaDeRede[index]))
                                              );
                                            },
                                          )
                                        ]
                                    );
                                  }
                              );
                            }
                        )
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    ));
  }

  /// Apagar a rede.
  void _apagarRede(int indexRede) async{
    Infraestrutura.confirmar(
        context: context,
        titulo: "Tem certeza que quer apagar esta rede?",
        mensagem: "Esta ação não pode ser desfeita.",
        acaoAoConfirmar: () async {

          final rede = store.listaDeRede[indexRede];

          // Fechar diálogo de confirmação
          Navigator.of(context).pop();

          Infraestrutura.mostrarDialogoDeCarregamento(
              context: context,
              titulo: "Apagando o grupo do dia ${store.listaDeRede[indexRede].nomeRede}..."
          );

          await store.apagarRede(rede.id!);

          // Fechar diálogo de carregamento
          Navigator.of(context).pop();
        }
    );
  }
}
