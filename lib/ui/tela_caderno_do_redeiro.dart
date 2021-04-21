import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/lancamento_do_caderno_dml.dart';
import 'package:jsvillela_app/models/lancamento_no_caderno.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/tabela_de_lancamentos.dart';
import 'package:jsvillela_app/ui/widgets/tela_novo_lancamento_no_caderno.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';

class TelaCadernoDoRedeiro extends StatelessWidget {

  //#region Atributos
  /// Informações do redeiro.
  final RedeiroDmo redeiro;

  /// Constante que define o nome do botão para a ação de Novo Lançamento na barra de ações.
  static const String OPCAO_NOVO_LANCAMENTO = "Novo lançamento";

  /// Lista contento as opções que serão exibidas na barra de ação da tela.
  final List<String> opcoesBarraDeAcao = [OPCAO_NOVO_LANCAMENTO];

  /// Lista com lançamentos do caderno.
  List<LancamentoDoCadernoDmo> caderno = [];
  //#endregion Atributos

  //#region Construtor(es)
  TelaCadernoDoRedeiro(this.redeiro);

  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(redeiro.nome!),
            centerTitle: true,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            actions: [
              PopupMenuButton<String>(
                  onSelected: (opcaoSelecionada){
                    // Quando a opção de "Cadastrar novo redeiro" é selecionada na barra ação
                    if(opcaoSelecionada == OPCAO_NOVO_LANCAMENTO){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return TelaNovoLancamentoNoCaderno(idDoRedeiro: redeiro.id!);
                          }
                      ).then((lancamentoRealizado) {
                        // TODO: Recarregar caderno após cadastro bem sucedido do novo lançamento
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return opcoesBarraDeAcao.map((e) => PopupMenuItem<String>(
                        value: e,
                        child: Text(e)
                    )).toList();
                  }
              )
            ],
        ),
        body: Container(
          child: LayoutBuilder(builder: (context, constraints) {

            return FutureBuilder<QuerySnapshot>(
              future: RedeiroModel().carregarCadernoDoRedeiro(redeiro.id!),
              builder: (context, snapshot){
                if(!snapshot.hasData)
                  return Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    alignment: Alignment.center,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                    ),
                  );
                else{

                  //#region Tela caso EXISTA dados de caderno
                  if(snapshot.data!.size > 0){

                    caderno = [];

                    snapshot.data!.docs.forEach((element) {

                      //#region Preencher informações do lançamento
                      LancamentoDoCadernoDmo novoLancamento = LancamentoDoCadernoDmo(
                        idLancamento: element.id,
                        dataConfirmacaoPagamento: element[LancamentoNoCadernoModel.CAMPO_DATA_CONFIRMACAO_PAGAMENTO],
                        dataLancamento: element[LancamentoNoCadernoModel.CAMPO_DATA_LANCAMENTO],
                        dataPagamento: element[LancamentoNoCadernoModel.CAMPO_DATA_PAGAMENTO],
                        idRede: element[LancamentoNoCadernoModel.CAMPO_ID_REDE],
                        nomeRede: element[LancamentoNoCadernoModel.CAMPO_NOME_REDE],
                        pago: element[LancamentoNoCadernoModel.CAMPO_PAGO],
                        quantidade: element[LancamentoNoCadernoModel.CAMPO_QUANTIDADE],
                        valorUnitario: element[LancamentoNoCadernoModel.CAMPO_VALOR_UNITARIO]
                      );

                      caderno.add(novoLancamento);
                      //#endregion Preencher informações do lançamento
                    });

                    //#region Agrupar lançamentos por data de pagamento

                    var listaDeCadernos = [];

                    while(caderno.isNotEmpty){

                      // Adicionar primeiro grupo que contém a mesma data de pagamento
                      listaDeCadernos.add(caderno.where((e) => e.dataPagamento == caderno.first.dataPagamento).toList());

                      // Remover todos os registros adicionados do caderno
                      caderno.removeWhere((e) => e.dataPagamento == caderno.first.dataPagamento);
                    }
                    //#endregion Agrupar lançamentos por data de pagamento

                    return Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: ListView(
                        children: listaDeCadernos.map((e) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: TabelaDeLancamentos(e, redeiro.id!),
                            );
                          }).toList()
                      ),
                    );
                  }
                  //#endregion Tela caso EXISTA dados de caderno

                  //#region Tela caso NÃO exista dados de caderno
                  else
                    return Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      alignment: Alignment.center,
                      child: Center(
                        child: Text("NÃO TEM NADA")
                      ),
                    );
                  //#endregion Tela caso NÃO exista dados de caderno
                }
              },
            );
          }),
        ));
  }
}

