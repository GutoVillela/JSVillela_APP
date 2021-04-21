import 'package:flutter/material.dart';

class CampoDeTextoComIcone extends StatelessWidget {
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
  final TextEditingController? controller;

  /// Regra que será utilizada na validação do formulário.
  final String? Function(String?)? regraDeValidacao;

  /// Ação ao submeter o campo de texto (clicar com Enter).
  final Function(String)? acaoAoSubmeter;

  /// Evento de onChanged do campo de texto.
  final Function(String)? onChanged;

  /// Widget de sufixo que será exibido à direito do campo de texto.
  final Widget? sufixo;
  //#endregion Atributos

  //#region Construtor(es)
  CampoDeTextoComIcone(
      {required this.icone,
      required this.texto,
      required this.campoDeSenha,
      required this.cor,
      this.controller,
      this.regraDeValidacao,
      this.acaoAoSubmeter,
      this.onChanged,
      this.sufixo});
  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        onFieldSubmitted: acaoAoSubmeter,
        controller: controller,
        obscureText: campoDeSenha,
        obscuringCharacter: '•',
        enableSuggestions: !campoDeSenha,
        autocorrect: !campoDeSenha,
        decoration: InputDecoration(
          prefixIcon: icone,
          suffixIcon: sufixo,
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          hintText: texto,
        ),
        validator: regraDeValidacao,
        onChanged: onChanged,
      ),
    );
  }
}
