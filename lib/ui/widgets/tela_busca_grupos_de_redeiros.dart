import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'campo_de_texto_com_icone.dart';
import 'list_view_item_pesquisa.dart';

class TelaBuscaGruposDeRedeiros extends StatefulWidget {
  @override
  _TelaBuscaGruposDeRedeirosState createState() => _TelaBuscaGruposDeRedeirosState();
}

class _TelaBuscaGruposDeRedeirosState extends State<TelaBuscaGruposDeRedeiros> {

  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  //#endregion Atributos

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Theme.of(context).primaryColor.withOpacity(.9),
      color: Colors.black12.withOpacity(.6),
      child: LayoutBuilder(
          builder: (context, constraints) {

            return Dialog(
              backgroundColor: Colors.black12,
              child: Center(
                child: Container(
                  width: constraints.maxWidth - constraints.maxWidth * .05,
                  height: constraints.maxHeight - constraints.maxHeight * .05,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Icon(
                          Icons.people_sharp,
                          color: Theme.of(context).primaryColor,
                          size: 50,
                        ),
                      ),
                      Text("Buscar grupo de redeiros",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 26
                        ),
                      ),
                      Container(
                        child: CampoDeTextoComIcone(
                          texto: "Nome do redeiro",
                          icone: Icon(
                              Icons.search,
                              color: Theme.of(context).primaryColor
                          ),
                          cor: Theme.of(context).primaryColor,
                          campoDeSenha: false,
                          controller: _buscaController,
                          regraDeValidacao: (texto){
                            return null;
                          },
                        ),
                      ),
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance.collection(GrupoDeRedeirosModel.NOME_COLECAO).orderBy(GrupoDeRedeirosModel.CAMPO_NOME).get(),
                        builder: (context, snapshot){
                          if(!snapshot.hasData)
                            return Container(
                              height: 200,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                              ),
                            );
                          else{
                            return Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(top: 10),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index){
                                      return ListViewItemPesquisa(
                                        textoPrincipal: snapshot.data.docs[index][GrupoDeRedeirosModel.CAMPO_NOME],
                                        textoSecundario: "",
                                        iconeEsquerda: Icons.people_sharp,
                                        iconeDireita: Icons.search,
                                        acaoAoClicar: (){

                                        },
                                      );
                                    }
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      FlatButton(
                          onPressed: (){
                            
                          },
                          child: Text("Concluir")
                      )
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
