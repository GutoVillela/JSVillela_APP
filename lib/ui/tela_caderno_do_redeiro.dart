import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jsvillela_app/stores/caderno_do_redeiro_store.dart';
import 'package:jsvillela_app/ui/widgets/tabela_de_lancamentos.dart';
import 'package:jsvillela_app/ui/widgets/tela_novo_lancamento_no_caderno.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';

class TelaCadernoDoRedeiro extends StatefulWidget {

  //#region Atributos

  /// Store que manipula as informações da tela.
  late final CadernoDoRedeiroStore store;

  //#endregion Atributos

  //#region Construtor(es)
  TelaCadernoDoRedeiro({required RedeiroDmo redeiro}) {
    store = CadernoDoRedeiroStore(redeiro: redeiro);
  }
  //#endregion Construtor(es)

  @override
  _TelaCadernoDoRedeiroState createState() => _TelaCadernoDoRedeiroState();
}

class _TelaCadernoDoRedeiroState extends State<TelaCadernoDoRedeiro> {

  //#region Atributos
  /// Constante que define o nome do botão para a ação de Novo Lançamento na barra de ações.
  static const String OPCAO_NOVO_LANCAMENTO = "Novo lançamento";

  /// Lista contento as opções que serão exibidas na barra de ação da tela.
  final List<String> opcoesBarraDeAcao = [OPCAO_NOVO_LANCAMENTO];
  //#endregion Atributos

  //#region Métodos

  @override
  void initState() {
    super.initState();
    widget.store.carregarCadernoDoRedeiro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Observer(
            builder: (_){
              return Text(widget.store.redeiro.nome);
            },
          ),
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
                          return TelaNovoLancamentoNoCaderno(idDoRedeiro: widget.store.redeiro.id!);
                        }
                    ).then((lancamentoRealizado) {
                      widget.store.carregarCadernoDoRedeiro();
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

            return Observer(builder: (_){
              if(widget.store.processando)
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

              //#region Tela caso EXISTA dados de caderno
              return Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: widget.store.caderno.isEmpty ?
                Center(
                    child: Text("NÃO TEM NADA")
                )
                : RefreshIndicator(
                  onRefresh: widget.store.carregarCadernoDoRedeiro,
                  child: ListView(
                      children: widget.store.caderno.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: TabelaDeLancamentos(idDoRedeiro: widget.store.redeiro.id!, listaDeLancamentos: e),
                        );
                      }).toList()
                  ),
                ),
              );
              //#endregion Tela caso EXISTA dados de caderno

            });
          }),
        ));
  }
//#endregion Métodos
}


