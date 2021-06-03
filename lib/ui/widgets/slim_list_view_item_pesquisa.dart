import 'package:flutter/material.dart';

///Cria um item Slim para List View de Pesquisa.
class SlimListViewItemPesquisa extends StatelessWidget {
  //#region Atributos
  /// Texto principal a ser exibido no item.
  String textoPrincipal;

  /// Ícone a ser exibido do lado esquerdo do item.
  IconData iconeEsquerda;

  /// Ação a ser executada ao clicar no item.
  Function? acaoAoClicar;
  //#endregion Atributos

  //#region Construtor(es)
  SlimListViewItemPesquisa(
      {required this.textoPrincipal,
      required this.iconeEsquerda,
      required this.acaoAoClicar});
  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Ink(
        //color: PaletaDeCor.AZUL_BEM_CLARO,
        child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            //contentPadding: EdgeInsets.all(10),
            //tileColor: PaletaDeCor.AZUL_MARINHO,
            leading: Icon(
              iconeEsquerda,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
            title: Text(
              textoPrincipal,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => acaoAoClicar),
      ),
    );
  }
}
