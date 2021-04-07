import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/materia_prima_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/models/materia_prima_model.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaCadastrarMateriaPrima extends StatefulWidget {

  //#region Atributos

  /// Tipo de manutenção desta tela (inclusão ou alteração)
  final TipoDeManutencao tipoDeManutencao;

  /// Matéria-prima a ser editado.
  final MateriaPrimaDmo mpASerEditada;

  //#endregion Atributos

  //#region Construtor(es)
  TelaCadastrarMateriaPrima({@required this.tipoDeManutencao, this.mpASerEditada});
  //#endregion Construtor(es)

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

  //#region Métodos
  @override
  void initState() {
    super.initState();

    if((widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.alteracao){
      _nomeMateriaPrimaController.text = widget.mpASerEditada.nomeMateriaPrima;
      _iconeController.text = widget.mpASerEditada.iconeMateriaPrima;
    }
  }
  //#endregion Métodos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _chaveScaffold,
        appBar: AppBar(
            title: Text((widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro ? "CADASTRAR MATÉRIA-PRIMA" : "EDITAR MATÉRIA-PRIMA"),
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
                              (widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro ? "Cadastrar matéria-prima" : "Editar matéria-prima",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            onPressed: (){
                              if(_formKey.currentState.validate()){
                                MateriaPrimaDmo dadosDaMateriaPrima = MateriaPrimaDmo(
                                  id: widget.mpASerEditada == null ? null : widget.mpASerEditada.id,
                                  nomeMateriaPrima: _nomeMateriaPrimaController.text,
                                  iconeMateriaPrima: _iconeController.text
                                );

                                if((widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro)
                                  model.cadastrarMateriaPrima(
                                      dadosDaMateriaPrima: dadosDaMateriaPrima,
                                      onSuccess: _finalizarCadastroDaMateriaPrima,
                                      onFail: _informarErroDeCadastro);
                                else
                                  model.atualizarMateriaPrima(
                                      dadosDaMateriaPrima: dadosDaMateriaPrima,
                                      onSuccess: _finalizarCadastroDaMateriaPrima,
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

  /// Callback chamado quando o cadastro ou edição for realizado com sucesso.
  void _finalizarCadastroDaMateriaPrima(){

    Infraestrutura.mostrarMensagemDeSucesso(context, (widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro
        ? "Matéria-prima cadastrada com sucesso!" : "Matéria-prima editada com sucesso!");

    Navigator.of(context).pop();
  }

  /// Callback chamado quando ocorer um erro no cadastro ou edição.
  void _informarErroDeCadastro() {
    Infraestrutura.mostrarMensagemDeErro(context, (widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro
        ? "Falha ao cadastrar matéria-prima!" : "Falha ao editar matéria-prima!");
  }

}