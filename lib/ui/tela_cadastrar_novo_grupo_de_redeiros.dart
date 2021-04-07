import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaCadastrarNovoGrupoDeRedeiros extends StatefulWidget {

  //#region Atributos

  /// Tipo de manutenção desta tela (inclusão ou alteração)
  final TipoDeManutencao tipoDeManutencao;

  /// Grupo de Redeiros a ser editado.
  final GrupoDeRedeirosDmo grupoASerEditado;

  //#endregion Atributos

  //#region Construtor(es)
  TelaCadastrarNovoGrupoDeRedeiros({@required this.tipoDeManutencao, this.grupoASerEditado});
  //#endregion Construtor(es)

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

  @override
  void initState() {
    super.initState();

    if((widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.alteracao)
      _nomeGrupoDeRedeirosController.text = widget.grupoASerEditado.nomeGrupo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _chaveScaffold,
        appBar: AppBar(
            title: Text((widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro ? "CADASTRAR GRUPO" : "EDITAR GRUPO"),
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
                              (widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro ? "Cadastrar Grupo" : "Editar grupo",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            onPressed: (){
                              if(_formKey.currentState.validate()){

                                GrupoDeRedeirosDmo grupo = GrupoDeRedeirosDmo(
                                  nomeGrupo: _nomeGrupoDeRedeirosController.text,
                                  idGrupo: widget.grupoASerEditado == null ? null : widget.grupoASerEditado.idGrupo
                                );

                                if((widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro)
                                  model.cadastrarGrupoDeRedeiros(
                                      dadosDoGrupo: grupo,
                                      onSuccess: _finalizarCadastroDoGrupoDeRedeiros,
                                      onFail: _informarErroDeCadastro);
                                else
                                  model.atualizarGrupo(
                                      dadosDoGrupo: grupo,
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

  /// Callback chamado quando o cadastro ou edição for realizado com sucesso.
  void _finalizarCadastroDoGrupoDeRedeiros(){

    Infraestrutura.mostrarMensagemDeSucesso(context, (widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro
    ? "Grupo cadastrado com sucesso!" : "Grupo editado com sucesso!");

    Navigator.of(context).pop();
  }

  /// Callback chamado quando ocorer um erro no cadastro ou edição.
  void _informarErroDeCadastro() {
    Infraestrutura.mostrarMensagemDeErro(context, (widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro
        ? "Falha ao cadastrar grupo!" : "Falha ao editar grupo!");
  }

}

