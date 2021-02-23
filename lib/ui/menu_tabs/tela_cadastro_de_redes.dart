import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/rede_model.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';

class TelaCadastroDeRedes extends StatefulWidget {
  @override
  _TelaCadastroDeRedesState createState() => _TelaCadastroDeRedesState();
}

class _TelaCadastroDeRedesState extends State<TelaCadastroDeRedes> {

  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  //#endregion Atributos

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
        LayoutBuilder(
          builder: (context, constraints){
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
                      regraDeValidacao: (texto){
                        return null;
                      },
                    ),
                  ),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection(RedeModel.NOME_COLECAO).orderBy(RedeModel.CAMPO_REDE).get(),
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
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index){
                                return ListViewItemPesquisa(
                                    textoPrincipal: snapshot.data.docs[index][RedeModel.CAMPO_REDE],
                                    textoSecundario: "R\$ " + snapshot.data.docs[index][RedeModel.CAMPO_VALOR_UNITARIO].toString(),
                                    iconeEsquerda: Icons.person,
                                    iconeDireita: Icons.search
                                );
                              }
                          ),
                        );
                      }
                    },
                  )
                ]
            );
          },
        )
    );
  }

}
