import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/stores/consultar_redeiros_store.dart';
import 'package:jsvillela_app/ui/tela_informacoes_do_redeiro.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_novo_redeiro.dart';

class TelaCadastroDeRedeiros extends StatefulWidget {

  @override
  _TelaCadastroDeRedeirosState createState() => _TelaCadastroDeRedeirosState();
}

class _TelaCadastroDeRedeirosState extends State<TelaCadastroDeRedeiros> {

  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  /// ScrollController usado para saber se usuário scrollou a lista até o final.
  ScrollController _scrollController = ScrollController();

  /// Store que controla tela de consulta de redeiros.
  final ConsultarRedeirosStore store = GetIt.I<ConsultarRedeirosStore>();
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
        if (store.temMaisRegistros && store.listaDeRedeiros.isNotEmpty){
          store.obterListaDeRedeirosPaginada(false, _buscaController.text);
        }
      }
    });

    store.obterListaDeRedeirosPaginada(true, null);
  }

  @override
  Widget build(BuildContext context) {

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
                  store.processando ?
                  Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor
                        ),
                      )
                  )
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
                                itemCount: store.listaDeRedeiros.length +
                                    1, // É somado um pois o último widget será um item de carregamento
                                separatorBuilder: (_, __){
                                  return Divider();
                                },
                                itemBuilder: (_, index) {
                                  if (index == store.listaDeRedeiros.length) {
                                    if (store.temMaisRegistros)
                                      return CupertinoActivityIndicator();
                                    else
                                      return Divider();
                                  }

                                  final redeiro = store.listaDeRedeiros[index];

                                  return ListViewItemPesquisa(
                                    acaoAoClicar: () => Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => TelaInformacoesDoRedeiro(store.listaDeRedeiros[index]))
                                    ),
                                    textoPrincipal: redeiro.nome,
                                    textoSecundario: redeiro.endereco.toString(),
                                    iconeEsquerda: Icons.group,
                                    iconeDireita: Icons.search,
                                    acoesDoSlidable:[
                                      IconSlideAction(
                                        caption: "Apagar",
                                        color: Colors.redAccent,
                                        icon: Icons.delete_forever_sharp,
                                        onTap: () => _apagarRedeiro(index),
                                      ),
                                      IconSlideAction(
                                        caption: store.listaDeRedeiros[index].ativo ? "Desativar" : "Reativar",
                                        color: store.listaDeRedeiros[index].ativo ? Colors.yellow[800] : Colors.blueGrey,
                                        icon: Icons.remove_circle_outlined,
                                        onTap: () => store.listaDeRedeiros[index].ativo ? _desativarRedeiro(index) : _ativarRedeiro(index),
                                      ),
                                      IconSlideAction(
                                        caption: "Editar",
                                        color: PaletaDeCor.AZUL_BEM_CLARO,
                                        icon: Icons.edit,
                                        onTap: () async {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => TelaCadastrarNovoRedeiro(tipoDeManutencao: TipoDeManutencao.alteracao, redeiroASerEditado: store.listaDeRedeiros[index]))
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }
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
  }


  /// Desativa o redeiro.
  void _desativarRedeiro(int indexRedeiro) async{
    Infraestrutura.confirmar(
        context: context,
        titulo: "Desativar o redeiro?",
        mensagem: "Você ainde pode consultar os registros deste redeiro mas ele não será incluído nos recolhimentos enquanto estiver desativado.",
        acaoAoConfirmar: () async {

          // Fechar diálogo de confirmação
          Navigator.of(context).pop();

          Infraestrutura.mostrarDialogoDeCarregamento(
            context: context,
            titulo: "Desativando o redeiro ${store.listaDeRedeiros[indexRedeiro].nome}..."
          );

          await store.ativarOuDesativarRedeiro(store.listaDeRedeiros[indexRedeiro].id!, false);

          List<RedeiroDmo> lista = store.listaDeRedeiros.toList();
          lista[indexRedeiro].ativo = false;
          store.setListaDeRedeiros(lista);

           // Fechar diálogo de carregamento.
           Navigator.of(context).pop();
        }
    );
  }

  /// Ativa o redeiro.
  void _ativarRedeiro(int indexRedeiro) async{
    Infraestrutura.confirmar(
        context: context,
        titulo: "Reativar o redeiro?",
        mensagem: "Este redeiro será incluído nos próximos recolhimentos.",
        acaoAoConfirmar: () async {
          // Fechar diálogo de confirmação
          Navigator.of(context).pop();

          Infraestrutura.mostrarDialogoDeCarregamento(
              context: context,
              titulo: "Reativando o redeiro ${store.listaDeRedeiros[indexRedeiro].nome}..."
          );

          await store.ativarOuDesativarRedeiro(store.listaDeRedeiros[indexRedeiro].id!, true);

          List<RedeiroDmo> lista = store.listaDeRedeiros.toList();
          lista[indexRedeiro].ativo = true;
          store.setListaDeRedeiros(lista);

          // Fechar diálogo de carregamento.
          Navigator.of(context).pop();
        }
    );
  }

  /// Apagar o redeiro e os registros associados à ele.
  void _apagarRedeiro(int indexRedeiro) async{
    Infraestrutura.confirmar(
        context: context,
        titulo: "Tem certeza que quer apagar o registro deste redeiro?",
        mensagem: "Esta ação não pode ser desfeita. Todos os registros de Solicitações deste redeiro também serão apagados.",
        acaoAoConfirmar: () async {
          // Fechar diálogo de confirmação
          Navigator.of(context).pop();

          Infraestrutura.mostrarDialogoDeCarregamento(
              context: context,
              titulo: "Apagando o redeiro ${store.listaDeRedeiros[indexRedeiro].nome}..."
          );

          try{
            await store.apagarRedeiro(store.listaDeRedeiros[indexRedeiro].id!);

            List<RedeiroDmo> lista = store.listaDeRedeiros.toList();
            lista.removeAt(indexRedeiro);
            store.setListaDeRedeiros(lista);

            // Fechar diálogo de carregamento.
            Navigator.of(context).pop();
          }
          catch(e){
            // Fechar diálogo de carregamento.
            Navigator.of(context).pop();
          }
        }
    );
  }
  //#endregion Métodos
}
