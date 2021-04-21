import 'package:flutter/material.dart';

class BotaoArredondado extends StatefulWidget {

  //#region Atributos
  /// Texto do botão a ser exibido na tela.
  final String textoDoBotao;
  //#endregion Atributos

  //#region Construtor(es)
  BotaoArredondado({required this.textoDoBotao});
  //#endregion Construtor(es)

  @override
  _BotaoArredondadoState createState() => _BotaoArredondadoState();
}

class _BotaoArredondadoState extends State<BotaoArredondado> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(50)
      ),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.textoDoBotao,
          style: TextStyle(
            fontFamily: "Nunito",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
