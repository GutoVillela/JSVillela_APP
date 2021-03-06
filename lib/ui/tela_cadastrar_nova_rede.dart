import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jsvillela_app/dml/rede_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/stores/cadastrar_rede_store.dart';

class TelaCadastrarNovaRede extends StatefulWidget {
  //#region Atributos

  late final CadastrarRedeStore store;

  //#endregion Atributos

  //#region Construtor(es)
  TelaCadastrarNovaRede({required TipoDeManutencao tipoDeManutencao , RedeDmo? redeASerEditada})
  {
    store =  CadastrarRedeStore(tipoDeManutencao: tipoDeManutencao, redeASerEditada: redeASerEditada);
    // Em caso de edição, iniciar valores
    if(tipoDeManutencao == TipoDeManutencao.alteracao && redeASerEditada != null){
      store.nomeRede = redeASerEditada.nomeRede;
      store.valorUnitarioRede = redeASerEditada.valorUnitarioRede;
      print("Na store: " + store.valorUnitarioRede.toString());
    }
  }
  //#endregion Construtor(es)

  @override
  _TelaCadastrarNovaRedeState createState() => _TelaCadastrarNovaRedeState();
}

class _TelaCadastrarNovaRedeState extends State<TelaCadastrarNovaRede> {
  //#region Atributos
  /// Chave global para o formulário de cadastro.
  final _formKey = GlobalKey<FormState>();

  /// Chave de Scaffold.
  final _chaveScaffold = GlobalKey<ScaffoldState>();

  ///Controller utilizado no campo de texto "Nome da Rede".
  final _nomeRedeController = TextEditingController();

  ///Controller utilizado no campo numerico "Valor Unitario".
  final _vlrUnitarioController = TextEditingController();
  //#endregion Atributos

  //#region Métodos
  @override
  void initState() {
    super.initState();

    if (widget.store.tipoDeManutencao  == TipoDeManutencao.alteracao) {
      _nomeRedeController.text = widget.store.nomeRede;
      _vlrUnitarioController.text = widget.store.valorUnitarioRede.toStringAsFixed(2);
    }
  }
  //#endregion Métodos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _chaveScaffold,
        appBar: AppBar(
            title: Text(
                widget.store.tipoDeManutencao  ==
                        TipoDeManutencao.cadastro
                    ? "CADASTRAR REDE"
                    : "EDITAR REDE"),
            centerTitle: true),
        body: Form(
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
                        hintText: "Nome da Rede"),
                    validator: (text) {
                      if (text!.isEmpty) return "Nome obrigatório!";
                      return null;
                    },
                    onChanged: widget.store.setNomeRede,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _vlrUnitarioController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.monetization_on),
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: "Valor Unitário"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      RealInputFormatter()
                    ],
                    validator: (text) {
                      if (text!.isEmpty) return "Valor obrigatório!";
                      return null;
                    },
                    // ignore: non_constant_identifier_names, unnecessary_statements
                    onChanged: widget.store.setValorUnitarioRede,
                  ),
                  SizedBox(height: 20),
                  Observer(
                      builder: (_){
                        return SizedBox(
                          height: 60,
                          child: ElevatedButton(
                              child: !widget.store.processando ?
                              Text(
                                widget.store.tipoDeManutencao ==
                                    TipoDeManutencao.cadastro
                                    ? "Cadastrar Rede"
                                    : "Editar Rede",
                                style: TextStyle(fontSize: 20),
                              ) :
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      return Theme.of(context).primaryColor; // Use the component's default.
                                    },
                                  )
                              ),
                              onPressed: !widget.store.habilitaBotaoDeCadastro ? null : () async {
                                if(await widget.store.cadastrarOuEditarRede() != null){
                                  _finalizarCadastroDaRede();
                                }
                                else{
                                  _informarErroDeCadastro();
                                }
                              }),
                        );
                      }
                  )
              ],
          ),
    ));
}

  /// Callback chamado quando o cadastro ou edição for realizado com sucesso.
  void _finalizarCadastroDaRede() {
    Infraestrutura.mostrarMensagemDeSucesso(

        context,
        widget.store.tipoDeManutencao  == TipoDeManutencao.cadastro
            ? "Rede Cadastrada com sucesso!"
            : "Rede editada com sucesso!");

    Navigator.of(context).pop();
  }

  /// Callback chamado quando ocorer um erro no cadastro ou edição.
  void _informarErroDeCadastro() {
    Infraestrutura.mostrarMensagemDeErro(
        context,
        widget.store.tipoDeManutencao  == TipoDeManutencao.cadastro
            ? "Falha ao cadastrar rede!"
            : "Falha ao editar rede!");
  }
}
