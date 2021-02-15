import 'package:flutter/material.dart';

/// Desenha um botão sem preenchimento e com bordas.
class BotaoSemPreenchimento extends StatefulWidget {

  //#region Atributos
  /// Texto do botão.
  final String textoDoBotao;
  //#endregion Atributos

  //#region Construtor(es)
  BotaoSemPreenchimento({@required this.textoDoBotao});
  //#endregion Construtor(es)

  @override
  _BotaoSemPreenchimentoState createState() => _BotaoSemPreenchimentoState();
}

class _BotaoSemPreenchimentoState extends State<BotaoSemPreenchimento> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFFB40284A),
              width: 2
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          widget.textoDoBotao,
          style: TextStyle(
              color: Color(0xFFB40284A),
              fontSize: 16
          ),
        ),
      ),
    );
  }
}
