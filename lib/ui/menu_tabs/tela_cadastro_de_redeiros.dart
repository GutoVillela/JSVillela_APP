import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/tela_informacoes_do_redeiro.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';

class TelaCadastroDeRedeiros extends StatefulWidget {
  @override
  _TelaCadastroDeRedeirosState createState() => _TelaCadastroDeRedeirosState();
}

class _TelaCadastroDeRedeirosState extends State<TelaCadastroDeRedeiros> {

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
            return Container(
              height: constraints.maxHeight,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(12),
                    child: CampoDeTextoComIcone(
                      texto: "Nome do redeiro",
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
                  future: FirebaseFirestore.instance.collection(RedeiroModel.NOME_COLECAO).orderBy(RedeiroModel.CAMPO_NOME).get(),
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
                                  textoPrincipal: snapshot.data.docs[index][RedeiroModel.CAMPO_NOME],
                                  textoSecundario: snapshot.data.docs[index][RedeiroModel.CAMPO_ENDERECO],
                                  iconeEsquerda: Icons.person,
                                  iconeDireita: Icons.search,
                                  acaoAoClicar: (){
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => TelaInformacoesDoRedeiro(snapshot.data.docs[index]))
                                    );
                                  },
                                );
                              }
                          ),
                        ),
                      );
                    }
                  },
                )
                ]
              ),
            );
          },
        )
    );
  }

}
