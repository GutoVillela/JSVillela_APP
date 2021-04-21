import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/lancamento_no_caderno.dart';
import 'package:jsvillela_app/models/rede_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaNovoLancamentoNoCaderno extends StatefulWidget {
  //#region Atributos

  /// Define qual o ID do Redeiro associado ao Caderno para Lançamento.
  final String idDoRedeiro;
  //#endregion Atributos

  //#region Contrutor(es)
  TelaNovoLancamentoNoCaderno({required this.idDoRedeiro});
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

  // Lista de redes a serem carregadas na caixa de seleção "Rede".
  List<Map<String, String>>? redes;

  // Define qual o ID da rede selecionada em tela.
  String? idRedeSelecionada;

  //#endregion Atributos

  //#region Constantes

  // Nome atribuído ao campo "ID" da rede.
  static const String CAMPO_ID_REDE = "id";

  //#endregion Constantes

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
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection(RedeModel.NOME_COLECAO)
                          .orderBy(RedeModel.CAMPO_REDE)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                          );
                        else {
                          // Carregar redes somente uma vez
                          if (redes == null || redes!.isEmpty) {
                            redes = [];
                            snapshot.data!.docs.forEach((element) {
                              var novaRede = Map<String, String>();
                              novaRede[CAMPO_ID_REDE] = element.id;
                              novaRede[RedeModel.CAMPO_REDE] =
                                  element[RedeModel.CAMPO_REDE];

                              redes!.add(novaRede);
                            });
                          }

                          return ScopedModel<LancamentoNoCadernoModel>(
                              model: LancamentoNoCadernoModel(),
                              child: ScopedModelDescendant<
                                  LancamentoNoCadernoModel>(
                                builder: (context, child, model) {
                                  return Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        DropdownButtonFormField(
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
                                                hintText: "Rede"),
                                            items: redes!.map((rede) {
                                              return DropdownMenuItem(
                                                value: rede[CAMPO_ID_REDE],
                                                child: Text(
                                                    rede[RedeModel.CAMPO_REDE]!),
                                              );
                                            }).toList(),
                                            value: idRedeSelecionada,
                                            validator: (String? valorSelecionado) {
                                              if (valorSelecionado == null ||
                                                  valorSelecionado.isEmpty)
                                                return "Selecione uma rede!";
                                              return null;
                                            },
                                            onChanged: (String? novoValor) {
                                              setState(() {
                                                idRedeSelecionada = novoValor;
                                              });
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
                                                child: Text(
                                                  "Cancelar",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            SizedBox(width: 10),
                                            TextButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    //TODO: Implementar ação de concluir Novo Lançamento no caderno.
                                                    Map<String, dynamic>
                                                        dadosDoLancamento = {
                                                      LancamentoNoCadernoModel
                                                              .CAMPO_ID_REDE:
                                                          idRedeSelecionada,
                                                      LancamentoNoCadernoModel
                                                          .CAMPO_NOME_REDE: redes!
                                                              .where((element) =>
                                                                  element[
                                                                      CAMPO_ID_REDE] ==
                                                                  idRedeSelecionada)
                                                              .first[
                                                          RedeModel.CAMPO_REDE],
                                                      LancamentoNoCadernoModel
                                                              .CAMPO_QUANTIDADE:
                                                          int.parse(
                                                              _quantidadeController
                                                                  .text),
                                                      LancamentoNoCadernoModel
                                                              .CAMPO_VALOR_UNITARIO:
                                                          double.parse(
                                                              _valorUnitarioController
                                                                  .text),
                                                      LancamentoNoCadernoModel
                                                              .CAMPO_DATA_LANCAMENTO:
                                                          DateTime.now(),
                                                      LancamentoNoCadernoModel
                                                          .CAMPO_PAGO: false,
                                                      LancamentoNoCadernoModel
                                                              .CAMPO_DATA_PAGAMENTO:
                                                          null,
                                                      LancamentoNoCadernoModel
                                                              .CAMPO_DATA_CONFIRMACAO_PAGAMENTO:
                                                          null
                                                    };

                                                    model.cadastrarNovoLancamento(
                                                        dadosDoLancamento:
                                                            dadosDoLancamento,
                                                        idDoRedeiro:
                                                            widget.idDoRedeiro,
                                                        onSuccess:
                                                            _finalizarCadastroNovoLancamento,
                                                        onFail:
                                                            _informarErroDeCadastro);
                                                  }
                                                },
                                                child: Text(
                                                  "Concluir",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ));
                        }
                      },
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
    Navigator.of(context).pop();
  }

  /// Informa usuário que ocorreu uma falha no cadastro do novo lançamento.
  void _informarErroDeCadastro() {}
}
