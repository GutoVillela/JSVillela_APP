import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/lancamento_do_caderno_dml.dart';
import 'package:jsvillela_app/models/lancamento_no_caderno.dart';

class TabelaDeLancamentos extends StatefulWidget {

  //#region Atributos

  /// Lista de lançamentos no caderno a serem exibidas na tabela.
  final List<LancamentoDoCadernoDmo> listaDeLancamentos;

  /// ID do Redeiro associado à lista de lançamentos.
  final String idDoRedeiro;

  //#endregion Atributos

  //#region Construtor(es)
  TabelaDeLancamentos(this.listaDeLancamentos, this.idDoRedeiro);
  //#endregion Construtor(es)

  @override
  _TabelaDeLancamentosState createState() => _TabelaDeLancamentosState();
}

/// Widget de construção da tabela de lançamentos usado nas telas de "Caderno do Redeiro".
class _TabelaDeLancamentosState extends State<TabelaDeLancamentos> {

  bool carregando = false;

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

    // Calcular total
    double total = 0;
    widget.listaDeLancamentos.forEach((element) {
      total += element.quantidade * element.valorUnitario;
    });

    // Formato de moeda
    final formatoMoeda = new NumberFormat.simpleCurrency();

    // Verificar se conjunto está pago
    bool pago = widget.listaDeLancamentos.first.pago;

    // Verificar se conjunto está confirmado
    bool confirmado = widget.listaDeLancamentos.first.dataConfirmacaoPagamento != null;

    return carregando ? carregamento() : SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Stack(
            overflow: Overflow.visible,
            children: [
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor)
                  ),
                  child: Column(
                    children: [
                      DataTable(
                        columns: [
                          DataColumn(label: const Text("Data")),
                          DataColumn(label: const Text("Rede")),
                          DataColumn(label: const Text("Qtd")),
                          DataColumn(label: const Text("Valor"))
                        ],
                        rows: widget.listaDeLancamentos.map((e) {

                          // Formatar para para dd/MM
                          final formatoData = new DateFormat('dd/MM');
                          DateTime dataLancamentoFormatada = new DateTime.fromMillisecondsSinceEpoch(e.dataLancamento.millisecondsSinceEpoch);

                          return DataRow(
                              selected: true,
                              cells: [
                                DataCell(Text(formatoData.format(dataLancamentoFormatada.toLocal()))),
                                DataCell(Text(e.nomeRede)),
                                DataCell(Text(e.quantidade.toString())),
                                DataCell(Text("R\$${e.valorUnitario}")),
                              ]);
                        }).toList(),
                      ),
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
                            Text("${formatoMoeda.format(total)}",
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold
                                )
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ),
              Positioned.fill(
                bottom: 0 - overflowYBotao,
                right: pago ? margemADireita : 0,
                child: Align(
                  alignment: pago ? Alignment.bottomRight : Alignment.bottomCenter,
                  child: FlatButton.icon(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    icon: Icon(pago ? Icons.check_circle :  Icons.access_time_outlined,
                        color: Theme.of(context).primaryColor),
                    color: Colors.white,
                    height: alturaDoBotao,
                    minWidth: larguraDoBotao,
                    label: Text(
                      pago ? "Pago" + (confirmado ? " e confirmado" : "") : "Não pago",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onPressed: (){

                    },
                    //child:
                  ),
                ),

              ),
              !pago ? Positioned.fill(
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
                    onPressed: (){
                      confirmarERealizarPagamento(context);
                    },
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
      ),
    );
  }

  /// Método que exibe um diálogo de confirmação e, caso usuário confirme,
  /// execute o pagamento dos registros da tabela.
  confirmarERealizarPagamento(BuildContext context){

    // Botão de Cancelar
    Widget botaoCancelar = FlatButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // Botão de confirmar
    Widget botaoConfirmar = FlatButton(
      child: Text("Confirmar"),
      onPressed:  () {
        Navigator.of(context).pop();
        processarPagamento(context);
      },
    );


    // Diálogo de confirmação
    AlertDialog alert = AlertDialog(
      title: Text("Confirmar pagamento"),
      content: Text("Gostaria de registrar o pagamento do grupo selecionado?"),
      actions: [
        botaoCancelar,
        botaoConfirmar,
      ],
    );

    // Exibir diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Widget que exibe tela de carregamento
  Widget carregamento() => Center(
    child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ),
  );

  /// Processa o pagamento do grupo selecionado.
  void processarPagamento(BuildContext context) async {

    setState(() {
      carregando = true;
    });

    LancamentoNoCadernoModel model = LancamentoNoCadernoModel();

    // Assumir mesma data de pagamento para todos os registros
    var dataDePagamento = Timestamp.now();

    // Realizar pagamentos
    widget.listaDeLancamentos.forEach((element) {
      widget.listaDeLancamentos.firstWhere((e) => e.idLancamento == element.idLancamento).dataPagamento = dataDePagamento;
      widget.listaDeLancamentos.firstWhere((e) => e.idLancamento == element.idLancamento).pago = true;
      model.informarPagamento(idDoLancamento: element.idLancamento, idDoRedeiro: widget.idDoRedeiro, dataDoPagamento: dataDePagamento, onSuccess: informarSucesso, onFail: informarErro);
    });

    print(widget.listaDeLancamentos);
    setState(() {
      carregando = false;
    });
  }

  /// Método chamado quando o pagamento é efetuado com sucesso.
  informarSucesso(){

  }

  /// Método chamado quando acontece um erro com o pagamento.
  informarErro(){

  }
}
