import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_solicitacao.dart';

class TelaConsultarSolicitacoesRedeiros extends StatefulWidget {
  @override
  _TelaConsultarSolicitacoesRedeirosState createState() =>
      _TelaConsultarSolicitacoesRedeirosState();
}

class _TelaConsultarSolicitacoesRedeirosState
    extends State<TelaConsultarSolicitacoesRedeiros> {
  //#region Atributos

  /// Controller utilizado no campo de texto de Busca.
  final _buscaController = TextEditingController();

  /// Define se o checkbox foi marcado
  bool _solicitacoesJaAtendidas = false;
  //#endregion Atributos

  @override
  Widget build(BuildContext context) {
    return Container(child: LayoutBuilder(
      builder: (context, constraints) {
        return Column(children: [
          Container(
            padding: EdgeInsets.all(12),
            child: CampoDeTextoComIcone(
              texto: "Pesquisar por nome de redeiro",
              icone: Icon(Icons.search, color: PaletaDeCor.AZUL_ESCURO),
              cor: PaletaDeCor.AZUL_ESCURO,
              campoDeSenha: false,
              controller: _buscaController,
              regraDeValidacao: (texto) {
                return null;
              },
            ),
          ),
          CheckboxListTile(
            title: Text("Incluir solicitações já atendidas ?"),
            secondary: Icon(Icons.av_timer),
            value: _solicitacoesJaAtendidas,
            onChanged: (bool valor) {
              setState(() {
                _solicitacoesJaAtendidas = valor;
              });
            },
          ),
          Container(
              padding: EdgeInsets.all(12),
              child: ListViewItemDaSolicitacao(
                nomeRedeiro: "Maria Dos Santos",
                dataDaSolicitacao: "Solicitação feita em 03 de Março de 2021",
                itensDaSolicitacao: "item1;item2",
                solicitacaoAtendida: false,
              )
          ),
          Container(
              padding: EdgeInsets.all(12),
              child: ListViewItemDaSolicitacao(
                nomeRedeiro: "Maria Dos Santos",
                dataDaSolicitacao: "Solicitação feita em 03 de Março de 2021",
                itensDaSolicitacao: "item1;item2",
                solicitacaoAtendida: true,
              )
          ),
          //return list_view_item_solicitacao
        ]);
      },
    ));
  }
}
