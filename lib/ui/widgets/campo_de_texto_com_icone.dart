import 'package:flutter/material.dart';

class CampoDeTextoComIcone extends StatefulWidget {

  //#region Atributos
  /// Ícone do campo de texto a ser exibido na tela.
  final Icon icone;

  /// Texto a ser aplicado no 'Hint' do campo de texto.
  final String texto;

  /// Define se campo será mascarado como campo de senha ou não.
  final bool campoDeSenha;

  /// Cor a ser aplicada na borda e no texto de ajuda do botão.
  final Color cor;

  /// Controller para o campo de texto.
  final TextEditingController controller;

  /// Regra que será utilizada na validação do formulário.
  final Function regraDeValidacao;

  /// Ação ao submeter o campo de texto (clicar com Enter).
  final Function acaoAoSubmeter;
  //#endregion Atributos

  //#region Construtor(es)
  CampoDeTextoComIcone({@required this.icone, @required this.texto, @required this.campoDeSenha, @required this.cor, @required this.controller, this.regraDeValidacao, this.acaoAoSubmeter});
  //#endregion Construtor(es)

  @override
  _CampoDeTextoComIconeState createState() => _CampoDeTextoComIconeState();
}

class _CampoDeTextoComIconeState extends State<CampoDeTextoComIcone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        onFieldSubmitted: widget.acaoAoSubmeter,
        controller: widget.controller,
        obscureText: widget.campoDeSenha,
        obscuringCharacter: '•',
        enableSuggestions: !widget.campoDeSenha,
        autocorrect: !widget.campoDeSenha,
        decoration: InputDecoration(
          prefixIcon: widget.icone,
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50)
          ),
          hintText: widget.texto
        ),
        validator: widget.regraDeValidacao,
      ),
    );
  }
}
