import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';

class ListViewItemDaSolicitacao extends StatelessWidget {
  //#region Atributos
  /// Texto principal a ser exibido no item.
  String nomeRedeiro;

  /// Data formatada a ser exibido no item.
  String dataDaSolicitacao;

  /// Ícone a ser exibido do lado esquerdo do item.
  String itensDaSolicitacao;

  //Usado para definir a cor do widget
  bool solicitacaoAtendida = false;

  //#region Construtor(es)
  ListViewItemDaSolicitacao(
      {required this.nomeRedeiro,
      required this.dataDaSolicitacao,
      required this.itensDaSolicitacao,
      this.solicitacaoAtendida = false});
  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Ink(
        color: (solicitacaoAtendida == true
            ? PaletaDeCor.AZUL_BEM_CLARO
            : PaletaDeCor.ROXO_CLARO),
        child: ListTile(
            contentPadding: EdgeInsets.all(10),
            //tileColor: PaletaDeCor.AZUL_MARINHO,
            title: Text(
              nomeRedeiro,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(dataDaSolicitacao + ';' + itensDaSolicitacao)),
      ),
    );
  }
}
