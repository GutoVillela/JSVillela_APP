import 'package:flutter/material.dart';

class BotaoRedondo extends StatelessWidget {

  //#region Atributos

  /// Ícone a ser exibido no botão.
  final IconData icone;

  /// Tamanho do botão.
  final double? tamanho;

  /// Ação ao clicar no botão.
  Function()? acaoAoClicar;

  /// Cor do botão.
  final Color? corDoBotao;

  /// Cor do icone.
  final Color? corDoIcone;

  //#endregion Atributos

  //#region Construtor(es)
  BotaoRedondo({required this.icone, this.tamanho, this.acaoAoClicar, this.corDoBotao, this.corDoIcone});
  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: corDoBotao,
        child: InkWell(
          onTap: acaoAoClicar,
          splashColor: Colors.red, // inkwell color
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icone,
              size: tamanho,
              color: corDoIcone ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
