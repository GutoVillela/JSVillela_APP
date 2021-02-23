import 'package:flutter/material.dart';
import 'package:jsvillela_app/models/rede_model.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaCadastrarNovaRede extends StatefulWidget {
  @override
  _TelaCadastrarNovaRedeState createState() => _TelaCadastrarNovaRedeState();
}

class _TelaCadastrarNovaRedeState extends State<TelaCadastrarNovaRede> {
  /// Chave global para o formulário de cadastro.
  final _formKey = GlobalKey<FormState>();

  /// Chave de Scaffold.
  final _chaveScaffold = GlobalKey<ScaffoldState>();

  ///Controller utilizado no campo de texto "Nome da Rede".
  final _nomeRedeController = TextEditingController();

  ///Controller utilizado no campo numerico "Valor Unitario".
  final _vlrUnitarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _chaveScaffold,
        appBar: AppBar(
            title: Text("CADASTRAR REDE"),
            centerTitle: true
        ),
        body: ScopedModel<RedeModel>(
          model: RedeModel(),
          child: ScopedModelDescendant<RedeModel>(
            builder: (context, child, model){
              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    TextFormField(
                      controller: _nomeRedeController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.grid_on),
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          isDense: true,
                          border: OutlineInputBorder(),
                          hintText: "Nome da Rede"
                      ),
                      validator: (text){
                        if(text.isEmpty ) return "Nome obrigatório!";
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _vlrUnitarioController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.monetization_on),
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          isDense: true,
                          border: OutlineInputBorder(),
                          hintText: "Valor Unitário"
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (text){
                        if(text.isEmpty ) return "Valor obrigatório!";
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 60,
                      child: RaisedButton(
                          child: Text(
                            "Cadastrar Rede",
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          onPressed: (){
                            if(_formKey.currentState.validate()){
                              Map<String, dynamic> dadosDaRede = {
                                RedeModel.CAMPO_REDE : _nomeRedeController.text,
                                RedeModel.CAMPO_VALOR_UNITARIO : _vlrUnitarioController.text
                              };

                              model.cadastrarRede(
                                  dadosDaRede: dadosDaRede,
                                  onSuccess: _finalizarCadastroDaRede,
                                  onFail: _informarErroDeCadastro);
                            }
                          }
                      ),
                    )
                  ],
                ),
              );
            }
          ),
        )
    );
  }

  void _finalizarCadastroDaRede(){
    _chaveScaffold.currentState.showSnackBar(
        SnackBar(
            content: Text("Rede Cadastrada com sucesso!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2))
    );

    Navigator.of(context).pop();
  }

  /// Informa usuário que ocorreu uma falha no cadastro da rede.
  void _informarErroDeCadastro(){
    _chaveScaffold.currentState.showSnackBar(
        SnackBar(
            content: Text("Falha ao cadastrar rede!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2))
    );
  }

}