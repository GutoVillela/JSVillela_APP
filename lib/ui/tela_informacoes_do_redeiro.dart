import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';

class TelaInformacoesDoRedeiro extends StatelessWidget {

  //#region Atributos
  /// Informações do redeiro.
  final DocumentSnapshot redeiro;
  //#endregion Atributos

  //#region Construtor(es)
  TelaInformacoesDoRedeiro(this.redeiro);
  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(redeiro["nome"]),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.grid_on)),
                Tab(icon: Icon(Icons.list)),
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection(RedeiroModel.NOME_COLECAO).doc(redeiro.id)
                .collection("items").get(),
            builder: (context, snapshot){
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else
                return Container(color: Colors.black12,);
              /*return TabBarView(
                  physics: NeverScrollableScrollPhysics(), // Evita trocar de tab arrastando para o lado
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.all(4),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          childAspectRatio: 0.55
                      ),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index){
                        return ProductTile(GridType.grid, ProductData.fromDocument(snapshot.data.docs[index]));
                      },
                    ),
                    ListView.builder(
                      padding: EdgeInsets.all(4),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index){
                        return ProductTile(GridType.list, ProductData.fromDocument(snapshot.data.docs[index]));
                      },
                    )
                  ],
                );*/
            },
          ),
        )
    );
  }
}
