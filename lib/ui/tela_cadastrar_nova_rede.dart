import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/rede_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/models/rede_model.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaCadastrarNovaRede extends StatefulWidget {

  //#region Atributos

  /// Tipo de manutenção desta tela (inclusão ou alteração)
  final TipoDeManutencao tipoDeManutencao;

  /// Rede a ser editada.
  final RedeDmo redeASerEditada;

  //#endregion Atributos

  //#region Construtor(es)
  TelaCadastrarNovaRede({@required this.tipoDeManutencao, this.redeASerEditada});
  //#endregion Construtor(es)

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
  void initState() {
    super.initState();

    if((widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.alteracao){
      _nomeRedeController.text = widget.redeASerEditada.nome_rede;
      _vlrUnitarioController.text = widget.redeASerEditada.valor_unitario_rede.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _chaveScaffold,
        appBar: AppBar(
            title: Text((widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro ? "CADASTRAR REDE" : "EDITAR REDE"),
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
                            (widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro ? "Cadastrar Rede" : "Editar rede",
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          onPressed: (){
                            if(_formKey.currentState.validate()){
                              RedeDmo dadosDaRede = RedeDmo(
                                id: widget.redeASerEditada != null ? widget.redeASerEditada.id : null,
                                nome_rede : _nomeRedeController.text,
                                valor_unitario_rede : double.parse(_vlrUnitarioController.text.replaceAll(RegExp(r','), '.'))
                              );

                              if((widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro)
                                model.cadastrarRede(
                                    dadosDaRede: dadosDaRede,
                                    onSuccess: _finalizarCadastroDaRede,
                                    onFail: _informarErroDeCadastro);
                              else
                                model.atualizarRede(
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

  /// Callback chamado quando o cadastro ou edição for realizado com sucesso.
  void _finalizarCadastroDaRede(){

    Infraestrutura.mostrarMensagemDeSucesso(context, (widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro
        ? "Rede Cadastrada com sucesso!" : "Rede editada com sucesso!");

    Navigator.of(context).pop();
  }

  /// Callback chamado quando ocorer um erro no cadastro ou edição.
  void _informarErroDeCadastro() {
    Infraestrutura.mostrarMensagemDeErro(context, (widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro
        ? "Falha ao cadastrar rede!" : "Falha ao editar rede!");
  }

}