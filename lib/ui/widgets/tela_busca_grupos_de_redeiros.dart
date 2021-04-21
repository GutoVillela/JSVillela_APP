import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/models/checklist_item_model.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/ui/widgets/checklist_item.dart';
import 'campo_de_texto_com_icone.dart';
import 'list_view_item_pesquisa.dart';

class TelaBuscaGruposDeRedeiros extends StatefulWidget {
  //#region Atributos

  /// Define quais são os grupos que já serão marcados por padrão.
  List<GrupoDeRedeirosDmo> gruposJaSelecionados = [];
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

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  /// Model de CheckListItem usado para demarcar os grupos de redeiros selecionados.
  List<CheckListItemModel> gruposDeRedeiros = [];
  //#endregion Atributos

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
                  // Container(
                  //   child: CampoDeTextoComIcone(
                  //     texto: "Nome do redeiro",
                  //     icone: Icon(
                  //         Icons.search,
                  //         color: Theme.of(context).primaryColor
                  //     ),
                  //     cor: Theme.of(context).primaryColor,
                  //     campoDeSenha: false,
                  //     controller: _buscaController,
                  //     regraDeValidacao: (texto){
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection(GrupoDeRedeirosModel.NOME_COLECAO)
                        .orderBy(GrupoDeRedeirosModel.CAMPO_NOME)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                          ),
                        );
                      else {
                        // Limpar e popular lista de Grupos de Redeiros
                        gruposDeRedeiros = [];
                        snapshot.data!.docs.forEach((grupo) {
                          bool checarGrupo =
                              widget.gruposJaSelecionados.isNotEmpty &&
                              widget.gruposJaSelecionados.any(
                                  (elemento) => elemento.idGrupo == grupo.id);

                          gruposDeRedeiros.add(CheckListItemModel(
                              texto: grupo[GrupoDeRedeirosModel.CAMPO_NOME],
                              checado: checarGrupo,
                              id: grupo.id));
                        });

                        return Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10),
                              children: [
                                ...gruposDeRedeiros
                                    .map((item) => ChecklistItem(
                                          checkListItemModel: item,
                                          iconeDoCheckBox:
                                              Icon(Icons.people_alt),
                                        ))
                                    .toList()
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            List<GrupoDeRedeirosDmo> gruposChecados = [];
                            gruposDeRedeiros.forEach((grupo) {
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
