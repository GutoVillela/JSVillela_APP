import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/stores/consultar_grupos_de_redeiros_store.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_novo_grupo_de_redeiros.dart';
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

  /// ScrollController usado para saber se usuário scrollou a lista até o final.
  ScrollController _scrollController = ScrollController();

  /// Store que controla tela de consulta de grupos de redeiros.
  ConsultarGruposDeRedeirosStore store = ConsultarGruposDeRedeirosStore();
  //#endregion Atributos


  @override
  void initState() {
    super.initState();

    // Adicionando evento de Scroll ao ScrollController
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Quando usuário chegar ao final da lista, obter mais registros
        if (store.temMaisRegistros && store.listaDeGruposDeRedeiros.isNotEmpty){
          store.obterListaDeGruposPaginadas(false, _buscaController.text);
        }
      }
    });

    store.obterListaDeGruposPaginadas(true, null);
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
                      texto: "Buscar grupos",
                      icone: Icon(Icons.search, color: PaletaDeCor.AZUL_ESCURO),
                      cor: PaletaDeCor.AZUL_ESCURO,
                      campoDeSenha: false,
                      controller: _buscaController,
                      onChanged: store.setTermoDeBusca,
                      acaoAoSubmeter: store.obterListaDeGruposPaginadasComFiltro,
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
                                itemCount: store.listaDeGruposDeRedeiros.length +
                                    1, // É somado um pois o último widget será um item de carregamento
                                separatorBuilder: (_, __){
                                  return Divider();
                                },
                                itemBuilder: (_, index) {
                                  if (index == store.listaDeGruposDeRedeiros.length) {
                                    if (store.temMaisRegistros)
                                      return CupertinoActivityIndicator();
                                    else
                                      return Divider();
                                  }

                                  final grupo = store.listaDeGruposDeRedeiros[index];
                                  print(grupo.idGrupo);

                                  return ListViewItemPesquisa(
                                    acaoAoClicar: null,
                                    textoPrincipal: grupo.nomeGrupo,
                                    textoSecundario: "Id: " + grupo.idGrupo,
                                    iconeEsquerda: Icons.group,
                                    iconeDireita: Icons.search,
                                    acoesDoSlidable:[
                                      IconSlideAction(
                                        caption: "Apagar",
                                        color: Colors.redAccent,
                                        icon: Icons.delete_forever_sharp,
                                        onTap: () => _apagarGrupo(index),
                                      ),
                                      IconSlideAction(
                                        caption: "Editar",
                                        color: Colors.yellow[800],
                                        icon: Icons.edit,
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => TelaCadastrarNovoGrupoDeRedeiros(tipoDeManutencao: TipoDeManutencao.alteracao, grupoASerEditado: grupo))
                                          );
                                        },
                                      )
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

  /// Apagar o grupo de redeiros.
  void _apagarGrupo(int indexGrupo) async{
    Infraestrutura.confirmar(
        context: context,
        titulo: "Tem certeza que quer apagar o este grupo de redeiro?",
        mensagem: "Esta ação não pode ser desfeita.",
        acaoAoConfirmar: () async {

          final grupo = store.listaDeGruposDeRedeiros[indexGrupo];

          // Fechar diálogo de confirmação
          Navigator.of(context).pop();

          Infraestrutura.mostrarDialogoDeCarregamento(
              context: context,
              titulo: "Apagando o grupo do dia ${grupo.nomeGrupo}..."
          );

          await store.apagarGrupoDeRedeiros(grupo.idGrupo);

          // Fechar diálogo de carregamento.
          Navigator.of(context).pop();

        }
    );
  }
}
