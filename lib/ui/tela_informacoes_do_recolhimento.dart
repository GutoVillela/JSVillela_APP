import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/ui/tela_informacoes_do_redeiro.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';

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
            child: Column(
              children: [
                _listTileDetalhesRecolhimento(context, Icons.calendar_today, "Agendado para ${formatoData.format(recolhimento.dataDoRecolhimento)}"),
                _listTileDetalhesRecolhimento(context, recolhimentoFinalizado ? Icons.check : Icons.access_time_sharp, recolhimentoFinalizado ? "Finalizado em ${formatoData.format(recolhimento.dataFinalizado!)}" : "Não finalizado"),
                Column(
                  children: this.recolhimento.gruposDoRecolhimento.map((e) => _listTileDetalhesRecolhimento(context, Icons.people_alt, e.nomeGrupo)).toList(),
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
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: recolhimento.redeirosDoRecolhimento.length,
                      itemBuilder: (context, index){

                        bool redeiroExcluido = recolhimento.redeirosDoRecolhimento[index].redeiro == null;

                        return ListViewItemPesquisa(
                            textoPrincipal: redeiroExcluido ? "Redeiro excluído" : recolhimento.redeirosDoRecolhimento[index].redeiro!.nome,
                            textoSecundario: redeiroExcluido ? "" : recolhimento.redeirosDoRecolhimento[index].redeiro!.endereco.cidade!,
                            iconeEsquerda: redeiroExcluido ? Icons.remove_circle_outlined : Icons.person,
                            iconeDireita: redeiroExcluido ? null : Icons.arrow_forward_ios_sharp,
                            acaoAoClicar: (){
                              if(!redeiroExcluido)
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TelaInformacoesDoRedeiro(recolhimento.redeirosDoRecolhimento[index].redeiro!)));
                              else
                                Infraestrutura.mostrarMensagemDeErro(context, "Este redeiro foi excluído");
                            }
                        );
                      }
                  ),
                )
              ],
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

}
