import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';

class ListViewItemPesquisa extends StatelessWidget {
  //#region Atributos
  /// Texto principal a ser exibido no item.
  final String textoPrincipal;

  /// Texto secundário a ser exibido no item.
  final String textoSecundario;

  /// Ícone a ser exibido do lado esquerdo do item.
  final IconData iconeEsquerda;

  /// Ícone a ser exibido do lado direito do item.
  final IconData? iconeDireita;

  /// Ação a ser executada ao clicar no item.
  final Function()? acaoAoClicar;

  /// Ações disponíveis no Slidable do item.
  List<Widget>? acoesDoSlidable;
  //#endregion Atributos

  //#region Construtor(es)
  ListViewItemPesquisa(
      {required this.textoPrincipal,
      required this.textoSecundario,
      required this.iconeEsquerda,
      required this.iconeDireita,
      required this.acaoAoClicar,
      this.acoesDoSlidable});
  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Slidable(
        actionPane: SlidableScrollActionPane(),
        actions: acoesDoSlidable,
        child: ListTile(
            contentPadding: EdgeInsets.all(10),
            hoverColor: PaletaDeCor.AZUL_BEM_CLARO,
            focusColor: PaletaDeCor.AZUL_BEM_CLARO,
            leading: Icon(
              iconeEsquerda,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
            title: Text(
              textoPrincipal,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(textoSecundario),
            trailing: Icon(iconeDireita, color: Theme.of(context).primaryColor),
            onTap: acaoAoClicar),
      ),
    );
  }
}
