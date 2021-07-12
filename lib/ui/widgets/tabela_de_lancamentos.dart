import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/lancamento_do_caderno_dml.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/stores/tabela_de_lancamentos_store.dart';
import 'package:mobx/mobx.dart';

class TabelaDeLancamentos extends StatefulWidget {

  //#region Atributos

  /// Store que manipula as informações da tela.
  late final TabelaDeLancamentosStore store;

  //#endregion Atributos

  //#region Construtor(es)
  TabelaDeLancamentos({required List<LancamentoDoCadernoDmo> listaDeLancamentos, required String idDoRedeiro}) {
    store = TabelaDeLancamentosStore(idDoRedeiro: idDoRedeiro, listaDeLancamentos: ObservableList.of(listaDeLancamentos));
  }
  //#endregion Construtor(es)

  @override
  _TabelaDeLancamentosState createState() => _TabelaDeLancamentosState();
}

/// Widget de construção da tabela de lançamentos usado nas telas de "Caderno do Redeiro".
class _TabelaDeLancamentosState extends State<TabelaDeLancamentos> {

  @override
  Widget build(BuildContext context) {

    // Altura do botão
    double alturaDoBotao = 40;

    // Largura do botão
    double larguraDoBotao = 100;

    // Overflow do botão para baixo
    double overflowYBotao = alturaDoBotao / 2;

    // Margem à direita dos botões de pagar e status
    double margemADireita = 10;

    // Formato de moeda
    final formatoMoeda = new NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).languageCode);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Observer(builder: (context){
        return widget.store.processando ? carregamento() :
        Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor)
                    ),
                    child: Column(
                      children: [
                        Observer(builder: (_){
                          return DataTable(
                            columns: [
                              DataColumn(label: const Text("Data")),
                              DataColumn(label: const Text("Rede")),
                              DataColumn(label: const Text("Qtd")),
                              DataColumn(label: const Text("Valor"))
                            ],
                            rows: widget.store.listaDeLancamentos.map((e) {

                              // Formatar para para dd/MM
                              final formatoData = new DateFormat('dd/MM');
                              DateTime dataLancamentoFormatada = new DateTime.fromMillisecondsSinceEpoch(e.dataLancamento.millisecondsSinceEpoch);

                              return DataRow(
                                  selected: true,
                                  cells: [
                                    DataCell(Text(formatoData.format(dataLancamentoFormatada.toLocal()))),
                                    DataCell(Text(e.rede.nomeRede)),
                                    DataCell(Text(e.quantidade.toString())),
                                    DataCell(Text(formatoMoeda.format(e.valorUnitario))),
                                  ]);
                            }).toList(),
                          );
                        }),
                        Divider(
                          height: 20,
                          thickness: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: overflowYBotao),
                          child: Row(
                            children: [
                              Text("Total: ",
                                  style: TextStyle(
                                      fontSize: 28
                                  )
                              ),
                              Observer(builder: (_){
                                return Text("${formatoMoeda.format(widget.store.total)}",
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold
                                    )
                                );
                              })

                            ],
                          ),
                        )
                      ],
                    )
                ),
                Observer(builder: (context){
                  return Positioned.fill(
                    bottom: 0 - overflowYBotao,
                    right: widget.store.pago ? margemADireita : 0,
                    child: Align(
                      alignment: widget.store.pago ? Alignment.bottomRight : Alignment.bottomCenter,
                      child: FlatButton.icon(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).primaryColor
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        icon: Observer(builder: (_){
                          return Icon(widget.store.pago ? Icons.check_circle :  Icons.access_time_outlined,
                              color: Theme.of(context).primaryColor);
                        }),
                        color: Colors.white,
                        height: alturaDoBotao,
                        minWidth: larguraDoBotao,
                        label: Observer(builder: (_){
                          return Text(
                            widget.store.pago ? "Pago" + (widget.store.confirmado ? " e confirmado" : "") : "Não pago",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold
                            ),
                          );
                        },
                        ),
                        onPressed: (){

                        },
                        //child:
                      ),
                    ),

                  );
                }),

                !widget.store.pago ? Positioned.fill(
                  bottom: 0 - overflowYBotao,
                  right: margemADireita,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      icon: Icon(Icons.attach_money, color: Colors.white),
                      color: Colors.green[600],
                      height: alturaDoBotao,
                      minWidth: larguraDoBotao,
                      label: Text(
                        "Pagar",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () => processarPagamento(context),
                      //child:
                    ),
                  ),

                ) : SizedBox()
              ],
            ),
            SizedBox(
              height: overflowYBotao,
            )
          ],
        );
      },
      ),
    );
  }

  /// Widget que exibe tela de carregamento
  Widget carregamento() => Center(
    child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ),
  );

  /// Processa o pagamento do grupo selecionado.
  void processarPagamento(BuildContext context) {

    Infraestrutura.confirmar(context: context,
        titulo: "Confirmar pagamento",
        mensagem: "Gostaria de registrar o pagamento do grupo selecionado?",
        acaoAoConfirmar: () async {
          await widget.store.processarPagamento();
          Navigator.of(context).pop();
        }
    );
  }

  /// Método chamado quando o pagamento é efetuado com sucesso.
  informarSucesso(){

  }

  /// Método chamado quando acontece um erro com o pagamento.
  informarErro(){

  }
}
