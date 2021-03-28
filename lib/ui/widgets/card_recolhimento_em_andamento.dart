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
import 'package:jsvillela_app/ui/widgets/botao_redondo.dart';
import 'package:jsvillela_app/ui/widgets/carrousel_de_itens.dart';
import 'package:jsvillela_app/ui/widgets/item_do_carrousel.dart';
import 'package:scoped_model/scoped_model.dart';

import '../tela_caderno_do_redeiro.dart';

class CardRecolhimentoEmAndamento extends StatefulWidget {

  //#region Atributos

  /// Ação do botão "Finalizar recolhimento"
  final Function acaoBotaoFinalizar;

  /// Recolhimento associado ao card.
  final RecolhimentoDmo recolhimento;

  /// Callback que é chamado após a finalização do recolhimento.
  final Function callbackFinalizarRecolhimento;

  /// Flag que indica se processo de cadastrar redeiros está em progresso.
  bool cadastrandoRedeiros;
  //#endregion Atributos

  //#region Construtor(es)
  CardRecolhimentoEmAndamento(this.acaoBotaoFinalizar, this.recolhimento, this.callbackFinalizarRecolhimento);
  //#endregion Construtor(es)

  @override
  _CardRecolhimentoEmAndamentoState createState() => _CardRecolhimentoEmAndamentoState();
}

class _CardRecolhimentoEmAndamentoState extends State<CardRecolhimentoEmAndamento> {

  //#region Métodos

  @override
  Widget build(BuildContext context) {
    print("Tamanho recolhimento: ${widget.recolhimento.redeirosDoRecolhimento.length}");
    return Expanded(
        child: CarrouselDeItens(widget.recolhimento, _finalizarRecolhimento)
    );
  }

  /// Callback chamado quando o recolhimento for finalizado.
  void _finalizarRecolhimento(){
    print("Iniciar finalizar recolhimento");
    DateTime dataFinalizacao = DateTime.now();
    RecolhimentoModel().finalizarRecolhimento(idRecolhimento: widget.recolhimento.id, dataFinalizacao: dataFinalizacao)
      .then((value) => widget.callbackFinalizarRecolhimento(dataFinalizacao));
  }
//#endregion Métodos
}
