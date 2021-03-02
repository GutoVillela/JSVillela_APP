import 'package:flutter/material.dart';
import 'package:jsvillela_app/models/materia_prima_model.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaCadastrarMateriaPrima extends StatefulWidget {
  @override
  _TelaCadastrarMateriaPrimaState createState() => _TelaCadastrarMateriaPrimaState();
}

class _TelaCadastrarMateriaPrimaState extends State<TelaCadastrarMateriaPrima> {

  //#region Atributos
  /// Chave global para o formulário de cadastro.
  final _formKey = GlobalKey<FormState>();

  /// Chave de Scaffold.
  final _chaveScaffold = GlobalKey<ScaffoldState>();

  ///Controller utilizado no campo de texto "Nome da Materia Prima".
  final _nomeMateriaPrimaController = TextEditingController();

  ///Controller utilizado no campo de texto "Icone".
  final _iconeController = TextEditingController();
  //#endregion Atributos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _chaveScaffold,
        appBar: AppBar(
            title: Text("CADASTRAR MATÉRIA PRIMA"),
            centerTitle: true
        ),
        body: ScopedModel<MateriaPrimaModel>(
          model: MateriaPrimaModel(),
          child: ScopedModelDescendant<MateriaPrimaModel>(
              builder: (context, child, model){
                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      TextFormField(
                        controller: _nomeMateriaPrimaController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.grid_on),
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: "Matéria Prima"
                        ),
                        validator: (text){
                          if(text.isEmpty ) return "Nome obrigatório!";
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                      //TODO: Criar uma maneira de selecionar um ícone a partir de uma lista
                      TextFormField(
                        controller: _iconeController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.add_circle_outline),
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: "Ícone"
                        ),
                        validator: (text){
                          if(text.isEmpty ) return "Selecione um ícone!";
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        child: RaisedButton(
                            child: Text(
                              "Cadastrar matéria-prima",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            onPressed: (){
                              if(_formKey.currentState.validate()){
                                Map<String, dynamic> dadosDaMateriaPrima = {
                                  MateriaPrimaModel.CAMPO_NM_MAT_PRIMA : _nomeMateriaPrimaController.text,
                                  MateriaPrimaModel.CAMPO_ICONE_MAT_PRIMA : _iconeController.text
                                };

                                model.cadastrarMateriaPrima(
                                    dadosDaMateriaPrima: dadosDaMateriaPrima,
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
            content: Text("Matéria prima cadastrada com sucesso!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2))
    );

    Navigator.of(context).pop();
  }

  /// Informa usuário que ocorreu uma falha no cadastro da materia prima.
  void _informarErroDeCadastro(){
    _chaveScaffold.currentState.showSnackBar(
        SnackBar(
            content: Text("Falha ao cadastrar!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2))
    );
  }

}