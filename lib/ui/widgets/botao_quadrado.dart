import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';

class BotaoQuadrado extends StatelessWidget {

  //#region Atributos
  /// Altura do Widget.
  final double? altura;

  /// Largura do Widget.
  final double? largura;

  /// Texto principal do botão.
  final String textoPrincipal;

  /// Texto secundário do botão.
  final String? textoSecundario;

  /// Ícone do botão.
  final IconData? icone;

  /// Ação a ser realizada após clicar no botão
  final VoidCallback? acaoAoClicar;
  //#endregion Atributos

  //#region Construtor(es)
  BotaoQuadrado({this.altura, this.largura, required this.textoPrincipal, this.textoSecundario, this.icone, this.acaoAoClicar});
  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: largura,
      height: altura,
      child: Material(
          borderRadius: BorderRadius.circular(2),
          color: PaletaDeCor.AZUL_BEM_CLARO,
          child: InkWell(
            onTap: acaoAoClicar,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icone, color: Colors.blue),
                SizedBox(height: 20),
                Text(textoPrincipal,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    )
                ),
                SizedBox(height: 20),
                Text(textoSecundario ?? "",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}
