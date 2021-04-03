import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';

class ListViewItemPesquisa extends StatelessWidget {

  //#region Atributos
  /// Texto principal a ser exibido no item.
  String textoPrincipal;

  /// Texto secundário a ser exibido no item.
  String textoSecundario;

  /// Ícone a ser exibido do lado esquerdo do item.
  IconData iconeEsquerda;

  /// Ícone a ser exibido do lado direito do item.
  IconData iconeDireita;

  /// Ação a ser executada ao clicar no item.
  Function acaoAoClicar;
  //#endregion Atributos

  //#region Construtor(es)
  ListViewItemPesquisa({@required this.textoPrincipal, @required this.textoSecundario, @required this.iconeEsquerda, @required this.iconeDireita, @required this.acaoAoClicar});
  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: ListTile(
          contentPadding: EdgeInsets.all(10),
          //tileColor: PaletaDeCor.AZUL_BEM_CLARO,
          hoverColor: PaletaDeCor.AZUL_BEM_CLARO,
          focusColor: PaletaDeCor.AZUL_BEM_CLARO,
          leading: Icon(
            iconeEsquerda,
            color: Theme.of(context).primaryColor,
            size: 40,
          ),
          title: Text(
            textoPrincipal,
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
          subtitle: Text(textoSecundario),
          trailing: Icon(iconeDireita, color: Theme.of(context).primaryColor),
          onTap: acaoAoClicar
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Ink(
        color: PaletaDeCor.AZUL_BEM_CLARO,
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          tileColor: PaletaDeCor.AZUL_BEM_CLARO,
          hoverColor: Colors.grey,
          leading: Icon(
              iconeEsquerda,
              color: Theme.of(context).primaryColor,
            size: 40,
          ),
          title: Text(
              textoPrincipal,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          subtitle: Text(textoSecundario),
          trailing: Icon(iconeDireita, color: Theme.of(context).primaryColor),
          onTap: acaoAoClicar
        ),
      ),
    );
  }
}
