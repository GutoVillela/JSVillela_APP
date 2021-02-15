import 'package:flutter/material.dart';

class CampoDeTextoComIcone extends StatefulWidget {

  //#region Atributos
  /// Ícone do campo de texto a ser exibido na tela.
  final Icon icone;

  /// Texto a ser aplicado no 'Hint' do campo de texto.
  final String texto;

  /// Cor a ser aplicada na borda e no texto de ajuda do botão.
  final Color cor;
  //#endregion Atributos

  //#region Construtor(es)
  CampoDeTextoComIcone({@required this.icone, @required this.texto, @required this.cor});
  //#endregion Construtor(es)

  @override
  _CampoDeTextoComIconeState createState() => _CampoDeTextoComIconeState();
}

class _CampoDeTextoComIconeState extends State<CampoDeTextoComIcone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.cor,
          width: 2
        ),
        borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            child: widget.icone
          ),
          Expanded(
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  hintText: widget.texto
                ),
              )
          )

        ],
      ),
    );
  }
}
