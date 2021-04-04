import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';

///Cria um item Slim para List View de Pesquisa.
class SlimListViewItemPesquisa extends StatelessWidget {

  //#region Atributos
  /// Texto principal a ser exibido no item.
  String textoPrincipal;

  /// Ícone a ser exibido do lado esquerdo do item.
  IconData iconeEsquerda;

  /// Ação a ser executada ao clicar no item.
  Function acaoAoClicar;
  //#endregion Atributos

  //#region Construtor(es)
  SlimListViewItemPesquisa({@required this.textoPrincipal, @required this.iconeEsquerda, @required this.acaoAoClicar});
  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Ink(
        //color: PaletaDeCor.AZUL_BEM_CLARO,
        child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            //contentPadding: EdgeInsets.all(10),
            //tileColor: PaletaDeCor.AZUL_MARINHO,
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
            onTap: acaoAoClicar
        ),
      ),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(20),
          color: PaletaDeCor.AZUL_BEM_CLARO,
          child: InkWell(
            highlightColor: PaletaDeCor.AZUL_BEM_CLARO,
            hoverColor: PaletaDeCor.AZUL_BEM_CLARO,
            splashColor: PaletaDeCor.AZUL_BEM_CLARO,
            overlayColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              return Theme.of(context).primaryColor;
            }),
            focusColor: PaletaDeCor.AZUL_BEM_CLARO,
            onTap: acaoAoClicar,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(iconeEsquerda),
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Text(
                    textoPrincipal,
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  flex: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );


  }
}