import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/dml/redeiro_do_recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_do_recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/botao_arredondado.dart';
import 'package:jsvillela_app/ui/widgets/card_recolhimento_em_andamento.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jsvillela_app/ui/tela_editar_recolhimento.dart';

class CardRecolhimento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RecolhimentoModel>(
        builder: (context, child, modelRecolhimento){
          // Formatar para para dd/MM/yyyy
          final formatoData = new DateFormat('dd/MM/yyyy');

          // Verificar se existe recolhimento do dia.
          bool existeRecolhimento = modelRecolhimento.recolhimentoDoDia != null;

          // Verificar se recolhimento do dia já foi finalizado
          bool recolhimentoDoDiaFinalizado = existeRecolhimento && modelRecolhimento.recolhimentoDoDia.dataFinalizado != null;

          if(!existeRecolhimento || recolhimentoDoDiaFinalizado)
            return _cardNaoExisteRecolhimento(context, formatoData, recolhimentoDoDiaFinalizado);
          else{
            // Obter cidades dos redeiros
            List<String> cidadesDoRecolhimento = [];

            if(modelRecolhimento.recolhimentoDoDia.redeirosDoRecolhimento != null && modelRecolhimento.recolhimentoDoDia.redeirosDoRecolhimento.isNotEmpty)
              cidadesDoRecolhimento = RedeiroModel().obterCidadesAPartirDosRedeiros(modelRecolhimento.recolhimentoDoDia.redeirosDoRecolhimento.map((e) => e.redeiro).toList());

            // Verificar se para este recolhimento existe algum redeiro já cadastrado
            return ScopedModel<RedeiroDoRecolhimentoModel>(
              model: RedeiroDoRecolhimentoModel(),
              child: !modelRecolhimento.recolhimentoEmAndamento ?
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: PaletaDeCor.AZUL_BEM_CLARO
                ),
                child: Column(
                  children: [
                    Text(formatoData.format(DateTime.now()),
                        style:  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                        )
                    ),
                    SizedBox(height: 20),
                    existeRecolhimento ?
                    ScopedModelDescendant<RedeiroDoRecolhimentoModel>(
                      builder: (context, child, model){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Você tem um recolhimento agendado para hoje.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16
                                )
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("DESTINO: ", style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: cidadesDoRecolhimento.length,
                                itemBuilder: (context, index) => Text(cidadesDoRecolhimento[index], textAlign: TextAlign.center)
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: (){

                                //Validar se existem grupos associados ao recolhimento
                                if(modelRecolhimento.recolhimentoDoDia.gruposDoRecolhimento == null || modelRecolhimento.recolhimentoDoDia.gruposDoRecolhimento.isEmpty || modelRecolhimento.recolhimentoDoDia.gruposDoRecolhimento.any((element) => element.idGrupo == null)){
                                  Infraestrutura.mostrarAviso(
                                    context: context,
                                    titulo: "Grupo do recolhimento apagado",
                                    mensagem: "Existe um ou mais grupos deste recolhimento que foi apagado. Por favor edite o recolhimento e selecione grupos válidos para poder iniciá-lo.",
                                    acaoAoConfirmar: (){
                                      Navigator.of(context).pop();// Fechar diálogo
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => TelaEditarRecolhimento(modelRecolhimento.recolhimentoDoDia))
                                      );
                                    }
                                  );
                                }
                                else{
                                  print("INICIOU RECOLHIMENTO");
                                  modelRecolhimento.recolhimentoDoDia.gruposDoRecolhimento..forEach((element) {
                                    print("REC: ${element.idGrupo} | GRUPO: ${element.nomeGrupo}");
                                  });
                                  model.cadastrarRedeirosDoRecolhimento(
                                      idRecolhimento: modelRecolhimento.recolhimentoDoDia.id,
                                      redeirosDoRecolhimento: modelRecolhimento.recolhimentoDoDia.redeirosDoRecolhimento,
                                      onSuccess: (redeirosCadastrados) async {
                                        // Após a Model cadastrar os Redeiros do Recolhimento ela devolve
                                        //no callback uma nova lista dos redeiros cadastrados com ID's preenchidos.
                                        // Portanto esses IDs são recuperados e atribuídos aqui.
                                        modelRecolhimento.recolhimentoDoDia.redeirosDoRecolhimento = redeirosCadastrados;

                                        await _iniciarRecolhimento(context, modelRecolhimento.recolhimentoDoDia.id);
                                      },
                                      onFail: () => _informarFalhaAoIniciarRecolhimento(context));
                                }
                              },
                              child: BotaoArredondado(
                                  textoDoBotao: "Iniciar recolhimento"
                              ),
                            )
                          ],
                        );
                      },
                    ) :
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Você não tem nada agendado para hoje. Aproveite o dia!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ) :
              CardRecolhimentoEmAndamento(modelRecolhimento.recolhimentoDoDia),
            );
          }
        }
    );
  }

  Widget _cardNaoExisteRecolhimento(BuildContext context, DateFormat formatoData, bool recolhimentoDoDiaFinalizado) => Container(
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: PaletaDeCor.AZUL_BEM_CLARO
    ),
    child: Column(
      children: [
        Text(formatoData.format(DateTime.now()),
            style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor
            )
        ),
        SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(recolhimentoDoDiaFinalizado ?
            "O recolhimento de hoje foi finalizado. Aproveite o resto do dia!" :
            "Você não tem nada agendado para hoje. Aproveite o dia!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16
                )
            ),
          ],
        )
      ],
    ),
  );

  /// Informa a interface que existe um recolhimento em andamento.
  Future<void> _iniciarRecolhimento(BuildContext context, String idRecolhimento) async{
    await RecolhimentoModel.of(context).iniciarRecolhimento(idRecolhimento);
  }

  /// Informa a interface que aconteceu um erro ao iniciar o recolhimento.
  void _informarFalhaAoIniciarRecolhimento(BuildContext context){
    Infraestrutura.mostrarMensagemDeErro(context, "Aconteceu um erro ao iniciar o recolhimento.");
  }
}
