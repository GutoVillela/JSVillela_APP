import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_do_recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaInformacoesDoRecolhimento extends StatelessWidget {

  //#region Atributos

  /// Recolhimento.
  final RecolhimentoDmo recolhimento;
  //#endregion Atributos

  //#region Construtor(es)
  TelaInformacoesDoRecolhimento(this.recolhimento);
  //#endregion Construtor(es)


  @override
  Widget build(BuildContext context) {

    // Formatar para para dd/MM/yyyy
    final formatoData = new DateFormat('dd/MM/yyyy');

    // Indica se o recolhimento já foi finalizado.
    bool recolhimentoFinalizado = recolhimento.dataFinalizado != null;

    // Carregar informações dos grupos de recolhimento
    _carregarGruposDoRecolhimento(context);

    // Carregar informações dos redeiros do recolhimento.
    _carregarRedeirosDoRecolhimento(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("DETALHES DO RECOLHIMENTO"),
          centerTitle: true
      ),
      body: LayoutBuilder(
        builder: (context, constraints){
          return Container(
            height: constraints.maxHeight,
            padding: const EdgeInsets.all(8.0),
            child: ScopedModelDescendant<GrupoDeRedeirosModel>(
                builder: (context, child, modelGrupos){

                  if(modelGrupos.estaCarregando)
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                    );

                  return Column(
                    children: [
                      _listTileDetalhesRecolhimento(context, Icons.calendar_today, "Agendado para ${formatoData.format(recolhimento.dataDoRecolhimento)}"),
                      _listTileDetalhesRecolhimento(context, recolhimentoFinalizado ? Icons.check : Icons.access_time_sharp, recolhimentoFinalizado ? "Finalizado em ${formatoData.format(recolhimento.dataFinalizado)}" : "Não finalizado"),
                      Column(
                        children: this.recolhimento.gruposDoRecolhimento.map((e) => _listTileDetalhesRecolhimento(context, Icons.people_alt, e.nomeGrupo ?? "nulo")).toList(),
                      ),
                      SizedBox(height: 20),
                      Text("Redeiros do Recolhimento",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                      Expanded(
                        child: ScopedModelDescendant<RedeiroDoRecolhimentoModel>(
                            builder: (context, child, modelRedeiro){
                              if(modelRedeiro.estaCarregando)
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                  ),
                                );

                              print("Redeiros qtd: ${recolhimento.redeirosDoRecolhimento.length}");

                              return ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                itemCount: recolhimento.redeirosDoRecolhimento.length,
                                itemBuilder: (context, index){
                                  // return ListTile(
                                  //   title: Text(recolhimento.redeirosDoRecolhimento[index].redeiro.nome),
                                  // );
                                  return ListViewItemPesquisa(
                                      textoPrincipal: recolhimento.redeirosDoRecolhimento[index].redeiro.nome,
                                      textoSecundario: recolhimento.redeirosDoRecolhimento[index].redeiro.endereco.cidade,
                                      iconeEsquerda: Icons.person,
                                      iconeDireita: Icons.arrow_forward_ios_sharp,
                                      acaoAoClicar: (){}
                                  );
                                }
                              );
                            }
                        ),
                      )
                    ],
                  );
                }
            ),
          );
        },
      )
    );
  }

  /// Widget padrão para exibir informações do recolhimento.
  Widget _listTileDetalhesRecolhimento(BuildContext context, IconData icone, String texto) => Padding(
      padding: const EdgeInsets.only(top: 1),
      child: ListTile(
      leading: Icon(icone, color: Theme.of(context).primaryColor),
      title: Text(texto),
      tileColor: PaletaDeCor.AZUL_BEM_CLARO
    )
  );

  /// Carrega as informações dos grupos associados ao recolhimento.
  void _carregarGruposDoRecolhimento(BuildContext context) async{
    this.recolhimento.gruposDoRecolhimento = await GrupoDeRedeirosModel.of(context).carregarGruposPorId(this.recolhimento.gruposDoRecolhimento.map((e) => e.idGrupo).toList());
  }

  /// Carrega as informações dos redeiros associados ao recolhimento.
  void _carregarRedeirosDoRecolhimento(BuildContext context) async{
    this.recolhimento.redeirosDoRecolhimento = await RedeiroDoRecolhimentoModel.of(context).carregarRedeirosDeUmRecolhimentoComDetalhes(this.recolhimento.id);
  }

}
