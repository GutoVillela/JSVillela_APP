import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/botao_arredondado.dart';

class CardRecolhimento extends StatelessWidget {

  //#region Atributos

  /// Ação do botão "Iniciar recolhimento"
  final Function acaoDoCard;

  /// Dados de recolhimento recuperados
  final RecolhimentoDmo recolhimento;

  //#endregion Atributos

  //#region Construtor(es)
  CardRecolhimento(this.acaoDoCard, this.recolhimento);
  //#endregion Construtor(es)

  /// Define se existe um recolhimento.
  bool existeRecolhimento;
  
  @override
  Widget build(BuildContext context) {

    // Formatar para para dd/MM/yyyy
    final formatoData = new DateFormat('dd/MM/yyyy');

    // Verificar se existe recolhimentos
    existeRecolhimento = recolhimento != null;

    return Container(
      padding: EdgeInsets.all(20),
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
          Column(
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
                  Text("DESTINO: ", style: TextStyle(fontWeight: FontWeight.bold)),


                ],
              ),
              FutureBuilder<QuerySnapshot>(
                future: RedeiroModel().carregarRedeirosPorGrupos(recolhimento.gruposDoRecolhimento.map((e) => e.idGrupo).toList()),
                builder: (context, snapshotRedeiros){
                  if(!snapshotRedeiros.hasData)
                    return Center(
                        child: CupertinoActivityIndicator()
                    );

                  List<String> cidadesDoRecolhimento = RedeiroModel().obterCidadesDosRedeiros(snapshotRedeiros.data.docs.toList());

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: cidadesDoRecolhimento.length,
                      itemBuilder: (context, index) => Text(cidadesDoRecolhimento[index], textAlign: TextAlign.center)
                  );
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: acaoDoCard,
                child: BotaoArredondado(
                    textoDoBotao: "Iniciar recolhimento"
                ),
              )
            ],
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
    );
  }
}
