import 'package:flutter/material.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaCadastrarNovoGrupoDeRedeiros extends StatefulWidget {
  @override
  _TelaCadastrarNovoGrupoDeRedeirosState createState() => _TelaCadastrarNovoGrupoDeRedeirosState();
}

class _TelaCadastrarNovoGrupoDeRedeirosState extends State<TelaCadastrarNovoGrupoDeRedeiros> {
  /// Chave global para o formulário de cadastro.
  final _formKey = GlobalKey<FormState>();

  /// Chave de Scaffold.
  final _chaveScaffold = GlobalKey<ScaffoldState>();

  ///Controller utilizado no campo de texto "Nome do Grupo".
  final _nomeGrupoDeRedeirosController = TextEditingController();

  ///Controller utilizado no campo numerico "Id do Grupo".
  final _idDoGrupoDeRedeirosController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _chaveScaffold,
        appBar: AppBar(
            title: Text("CADASTRAR GRUPO"),
            centerTitle: true
        ),
        body: ScopedModel<GrupoDeRedeirosModel>(
          model: GrupoDeRedeirosModel(),
          child: ScopedModelDescendant<GrupoDeRedeirosModel>(
              builder: (context, child, model){
                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      TextFormField(
                        controller: _nomeGrupoDeRedeirosController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.grid_on),
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: "Nome do Grupo"
                        ),
                        validator: (text){
                          if(text.isEmpty ) return "Nome obrigatório!";
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        child: RaisedButton(
                            child: Text(
                              "Cadastrar Grupo",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            onPressed: (){
                              if(_formKey.currentState.validate()){
                                Map<String, dynamic> dadosDoGrupo = {
                                  GrupoDeRedeirosModel.CAMPO_NOME : _nomeGrupoDeRedeirosController.text
                                };

                                model.cadastrarGrupoDeRedeiros(
                                    dadosDoGrupo: dadosDoGrupo,
                                    onSuccess: _finalizarCadastroDoGrupoDeRedeiros,
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

  void _finalizarCadastroDoGrupoDeRedeiros(){
    _chaveScaffold.currentState.showSnackBar(
        SnackBar(
            content: Text("Grupo cadastrado com sucesso!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2))
    );

    Navigator.of(context).pop();
  }

  void _informarErroDeCadastro() {
    _chaveScaffold.currentState.showSnackBar(
        SnackBar(
            content: Text("Falha ao cadastrar grupo!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2))
    );
  }

}

