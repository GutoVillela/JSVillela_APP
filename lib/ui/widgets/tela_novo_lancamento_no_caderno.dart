import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/stores/novo_lancamento_store.dart';

class TelaNovoLancamentoNoCaderno extends StatefulWidget {
  //#region Atributos

  /// Store que manipula as informações da tela.
  late final NovoLancamentoStore store;
  //#endregion Atributos

  //#region Contrutor(es)
  TelaNovoLancamentoNoCaderno({required String idDoRedeiro}) {
    store = NovoLancamentoStore(idRedeiro: idDoRedeiro);
  }
  //#endregion Contrutor(es)

  @override
  _TelaNovoLancamentoNoCadernoState createState() =>
      _TelaNovoLancamentoNoCadernoState();
}

class _TelaNovoLancamentoNoCadernoState
    extends State<TelaNovoLancamentoNoCaderno> {
  //#region Atributos
  /// Chave global para o formulário de cadastro.
  final _formKey = GlobalKey<FormState>();

  ///Controller utilizado no campo de texto "Quantidade".
  final _quantidadeController = TextEditingController();

  ///Controller utilizado no campo de texto "Valor unitário".
  final _valorUnitarioController = TextEditingController();


  //#endregion Atributos

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12.withOpacity(.6),
      child: LayoutBuilder(builder: (context, constraints) {
        return Dialog(
          backgroundColor: Colors.black12,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth - constraints.maxWidth * .05,
                height: constraints.maxHeight - constraints.maxHeight * .05,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Center(
                      child: Icon(
                        Icons.note_add,
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      ),
                    ),
                    Text(
                      "Novo Lançamento",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 26),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Observer(builder: (_){
                            return DropdownButtonFormField(
                                icon: Icon(Icons.arrow_drop_down),
                                dropdownColor:
                                PaletaDeCor.AZUL_BEM_CLARO,
                                isExpanded: true,

                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.grid_on),
                                    contentPadding:
                                    EdgeInsets.symmetric(
                                        vertical: 20),
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                    hintText: "Rede"
                                ),
                                items: widget.store.buscandoRedes ? null : widget.store.redes.map((rede) {
                                  return DropdownMenuItem(
                                    value: rede.id,
                                    child: Text(
                                        rede.nomeRede
                                    ),
                                  );
                                }).toList(),
                                value: widget.store.rede?.id,
                                validator: (String? valorSelecionado) {
                                  if (valorSelecionado == null ||
                                      valorSelecionado.isEmpty)
                                    return "Selecione uma rede!";
                                  return null;
                                },
                                onChanged: (String? valor) {
                                  widget.store.setRede(valor);
                                  _valorUnitarioController.text = widget.store.rede?.valorUnitarioRede.toStringAsFixed(2) ?? "";
                                  widget.store.setValorUnitarioRede(_valorUnitarioController.text);
                                },
                                //onSaved: (_) => _valorUnitarioController.text = widget.store.rede?.valorUnitarioRede.toStringAsFixed(2) ?? "",
                                );
                          }),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _quantidadeController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.add),
                                contentPadding:
                                EdgeInsets.symmetric(
                                    vertical: 20),
                                isDense: true,
                                border: OutlineInputBorder(),
                                hintText: "Quantidade"),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: widget.store.setQuantidade,
                            validator: (text) {
                              if (text!.isEmpty)
                                return "Quantidade obrigatória!";
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _valorUnitarioController,
                            decoration: InputDecoration(
                                prefixIcon:
                                Icon(Icons.attach_money),
                                contentPadding:
                                EdgeInsets.symmetric(
                                    vertical: 20),
                                isDense: true,
                                border: OutlineInputBorder(),
                                hintText: "Valor unitário"),
                            keyboardType: TextInputType.number,
                            onChanged: widget.store.setValorUnitarioRede,
                            validator: (text) {
                              if (text!.isEmpty)
                                return "Valor unitário obrigatório!";
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.red
                                  ),
                                  child: Text(
                                    "Cancelar",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold),
                                  )),
                              SizedBox(width: 10),
                              Observer(builder: (context){
                                return TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor
                                    ),
                                    onPressed: !widget.store.habilitaBotaoDeCadastro ? null : () async {
                                      if (_formKey.currentState!.validate()) {
                                        if(await widget.store.cadastrarLancamento() != null)
                                          _finalizarCadastroNovoLancamento();
                                        else
                                          _informarErroDeCadastro();
                                      }
                                    },
                                    child: widget.store.processando ?
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ) : Text(
                                      "Concluir",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold),
                                    )
                                );
                              })
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// É chamado após o cadastro do Novo Lançamento ser efetuado com sucesso.
  void _finalizarCadastroNovoLancamento() {
    Infraestrutura.mostrarMensagemDeSucesso(context, "Lançamento realizado com sucesso!");
    Navigator.of(context).pop();
  }

  /// Informa usuário que ocorreu uma falha no cadastro do novo lançamento.
  void _informarErroDeCadastro() {
    Infraestrutura.mostrarMensagemDeErro(context, "Não foi possível cadastrar o lançamento!");
  }
}
