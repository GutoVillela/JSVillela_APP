import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/stores/widget_busca_grupos_store.dart';
import 'package:jsvillela_app/ui/widgets/checklist_item.dart';

class TelaBuscaGruposDeRedeiros extends StatefulWidget {
  //#region Atributos

  /// Define quais são os grupos que já serão marcados por padrão.
  final List<GrupoDeRedeirosDmo> gruposJaSelecionados;
  //#endregion Atributos

  //#region Contrutor(es)
  TelaBuscaGruposDeRedeiros({required this.gruposJaSelecionados});
  //#endregion Contrutor(es)

  @override
  _TelaBuscaGruposDeRedeirosState createState() =>
      _TelaBuscaGruposDeRedeirosState();
}

class _TelaBuscaGruposDeRedeirosState extends State<TelaBuscaGruposDeRedeiros> {

  //#region Atributos

  /// Store usado para manupilar estados do Widget de busca de grupos de redeiros.
  late WidgetBuscaGruposStore widgetBuscaGruposStore;

  /// ScrollController usado para saber se usuário scrollou a lista até o final.
  ScrollController _scrollController = ScrollController();

  //#endregion Atributos

  @override
  void initState() {
    super.initState();

    // Inicializar store
    widgetBuscaGruposStore = WidgetBuscaGruposStore(gruposJaSelecionados: widget.gruposJaSelecionados);

    // Adicionando evento de Scroll ao ScrollController
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Quando usuário chegar ao final da lista, obter mais registros
        if (widgetBuscaGruposStore.temMaisRegistros && widgetBuscaGruposStore.listaDeGruposDeRedeiros.isNotEmpty){
          widgetBuscaGruposStore.obterListaDeGruposPaginados(false);
        }
      }
    });

    widgetBuscaGruposStore.obterListaDeGruposPaginados(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12.withOpacity(.6),
      child: LayoutBuilder(builder: (context, constraints) {
        return Dialog(
          backgroundColor: Colors.black12,
          child: Center(
            child: Container(
              width: constraints.maxWidth - constraints.maxWidth * .05,
              height: constraints.maxHeight - constraints.maxHeight * .05,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  Center(
                    child: Icon(
                      Icons.people_alt,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    ),
                  ),
                  Text(
                    "Buscar grupo de redeiros",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 26),
                  ),
                  Observer(
                    builder: (_){
                      if(widgetBuscaGruposStore.processando)
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor
                              ),
                            )
                          );
                      else
                        return Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                             child: ListView.separated(
                                 controller: _scrollController,
                                 scrollDirection: Axis.vertical,
                                 shrinkWrap: true,
                                 padding: EdgeInsets.only(top: 10),
                                 itemCount: widgetBuscaGruposStore.listaDeGruposDeRedeiros.length +
                                     1, // É somado um pois o último widget será um item de carregamento
                                 separatorBuilder: (_, __){
                                   return Divider();
                                 },
                                 itemBuilder: (_, index) {
                                   if (index == widgetBuscaGruposStore.listaDeGruposDeRedeiros.length) {
                                     if (widgetBuscaGruposStore.temMaisRegistros)
                                       return CupertinoActivityIndicator();
                                     else
                                       return Divider();
                                   }

                                   final grupo = widgetBuscaGruposStore.listaDeGruposDeRedeiros[index];

                                   return  ChecklistItem(
                                             checkListItemModel: grupo,
                                             iconeDoCheckBox:
                                             Icon(Icons.people_alt),
                                           );
                                 }
                             )
                          ),
                        );
                    }
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red
                        ),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            List<GrupoDeRedeirosDmo> gruposChecados = [];
                            widgetBuscaGruposStore.listaDeGruposDeRedeiros.forEach((grupo) {
                              if (grupo.checado) {
                                GrupoDeRedeirosDmo novoItem =
                                    new GrupoDeRedeirosDmo(
                                        idGrupo: grupo.id,
                                        nomeGrupo: grupo.texto);
                                gruposChecados.add(novoItem);
                              }
                            });

                            Navigator.of(context).pop(gruposChecados);
                          },
                          child: Text(
                            "Concluir",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
