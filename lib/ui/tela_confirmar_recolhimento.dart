import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/models/recolhimento_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/tela_principal.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaConfirmarRecolhimento extends StatelessWidget {

  //#region Atributos
  //
  // /// Data do Recolhimento selecionada em tela.
  // final DateTime _dataDoRecolhimento;
  //
  // /// Lista com os grupos de redeiros selecionados.
  // final List<GrupoDeRedeirosDmo> _gruposDeRedeiros;

  /// Recolhimento a ser cadastrado ou editado.
  final RecolhimentoDmo _recolhimento;

  /// Lista com as cidades a serem visitadas no recolhimento.
  final List<String> _listaDeCidades;

  /// Define o tipo de manutenção que será realizada para o recolhimento (Inclusão ou Alteração)
  final TipoDeManutencao _tipoDeManutencao;
  //#endregion Atributos

  //#region Construtor(es)
  //TelaConfirmarRecolhimento(this._dataDoRecolhimento, this._gruposDeRedeiros, this._listaDeCidades, this._tipoDeManutencao);
  TelaConfirmarRecolhimento(this._recolhimento, this._listaDeCidades, this._tipoDeManutencao);
  //#region Construtor(es)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("AGENDAR RECOLHIMENTO"),
          centerTitle: true
      ),
      body: LayoutBuilder(
        builder: (context, constraints){
          return Container(
            padding: EdgeInsets.all(32),
            child: ScopedModelDescendant<RecolhimentoModel>(
                builder: (context, child, modelRecolhimento){

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: Icon(Icons.location_on_outlined, size: 80, color: Theme.of(context).primaryColor)),
                      SizedBox(height: 20),
                      Text("Confirmar cidades",
                          style:  TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                            itemCount: _listaDeCidades.length,
                            itemBuilder: (context, index){
                              return Center(
                                  child: Text(
                                    _listaDeCidades[index],
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold

                                    ),
                                  ));
                            }

                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        width: constraints.maxWidth,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                                  return Theme.of(context).primaryColor;
                                })
                            ),
                            child: Text(
                              "Concluir agendamento",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            onPressed: (){

                              if(_recolhimento.dataDoRecolhimento == null)
                                Infraestrutura.mostrarMensagemDeErro(context, "Data do recolhimento não fornecida.");
                              else if(_recolhimento.gruposDoRecolhimento == null || _recolhimento.gruposDoRecolhimento.isEmpty)
                                Infraestrutura.mostrarMensagemDeErro(context, "Selecione pelo menos um grupo de redeiros para prosseguir.");
                              else{

                                switch(_tipoDeManutencao){
                                  case TipoDeManutencao.cadastro:
                                    // Realizar cadastro do Recolhimento
                                    modelRecolhimento.cadastrarRecolhimento(
                                        dadosDoRecolhimento: _recolhimento,
                                        onSuccess: () => _finalizarAgendamento(context),
                                        onFail: () => _informarErroNoAgendamento(context)
                                    );
                                    break;

                                  case TipoDeManutencao.alteracao:
                                  // Realizar alteração do Recolhimento
                                    modelRecolhimento.atualizarRecolhimento(
                                        dadosDoRecolhimento: _recolhimento,
                                        onSuccess: () => _finalizarAgendamento(context),
                                        onFail: () => _informarErroNoAgendamento(context)
                                    );
                                    break;
                                }
                              }

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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //         title: Text("AGENDAR RECOLHIMENTO"),
  //         centerTitle: true
  //     ),
  //     body: LayoutBuilder(
  //       builder: (context, constraints){
  //         return Container(
  //           padding: EdgeInsets.all(32),
  //           child: ScopedModelDescendant<RecolhimentoModel>(
  //               builder: (context, child, modelRecolhimento){
  //
  //                 return Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Center(child: Icon(Icons.location_on_outlined, size: 80, color: Theme.of(context).primaryColor)),
  //                     SizedBox(height: 20),
  //                     Text("Confirmar cidades",
  //                         style:  TextStyle(
  //                             fontSize: 20,
  //                             fontWeight: FontWeight.bold
  //                         )
  //                     ),
  //                     SizedBox(height: 20),
  //                     Expanded(
  //                       child: ListView.builder(
  //                           itemCount: _listaDeCidades.length,
  //                           itemBuilder: (context, index){
  //                             return Center(
  //                                 child: Text(
  //                                   _listaDeCidades[index],
  //                                   style: TextStyle(
  //                                       color: Theme.of(context).primaryColor,
  //                                       fontSize: 28,
  //                                       fontWeight: FontWeight.bold
  //
  //                                   ),
  //                                 ));
  //                           }
  //
  //                       ),
  //                     ),
  //                     SizedBox(height: 20),
  //                     SizedBox(
  //                       height: 60,
  //                       width: constraints.maxWidth,
  //                       child: ElevatedButton(
  //                           style: ButtonStyle(
  //                               backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
  //                                 return Theme.of(context).primaryColor;
  //                               })
  //                           ),
  //                           child: Text(
  //                             "Concluir agendamento",
  //                             style: TextStyle(
  //                                 fontSize: 20
  //                             ),
  //                           ),
  //                           onPressed: (){
  //
  //                             if(_dataDoRecolhimento == null)
  //                               Infraestrutura.mostrarMensagemDeErro(context, "Data do recolhimento não fornecida.");
  //                             else if(_gruposDeRedeiros == null || _gruposDeRedeiros.isEmpty)
  //                               Infraestrutura.mostrarMensagemDeErro(context, "Selecione pelo menos um grupo de redeiros para prosseguir.");
  //                             else{
  //
  //                               var dadosDoRecolhimento = RecolhimentoDmo(
  //                                   dataDoRecolhimento: _dataDoRecolhimento,
  //                                   gruposDoRecolhimento: _gruposDeRedeiros
  //                               );
  //
  //                               switch(_tipoDeManutencao){
  //                                 case TipoDeManutencao.cadastro:
  //                                   // Realizar cadastro do Recolhimento
  //                                   modelRecolhimento.cadastrarRecolhimento(
  //                                       dadosDoRecolhimento: dadosDoRecolhimento,
  //                                       onSuccess: () => _finalizarAgendamento(context),
  //                                       onFail: () => _informarErroNoAgendamento(context)
  //                                   );
  //                                   break;
  //
  //                                 case TipoDeManutencao.alteracao:
  //                                 // Realizar alteração do Recolhimento
  //                                   modelRecolhimento.(
  //                                       dadosDoRecolhimento: dadosDoRecolhimento,
  //                                       onSuccess: () => _finalizarAgendamento(context),
  //                                       onFail: () => _informarErroNoAgendamento(context)
  //                                   );
  //                                   break;
  //                               }
  //                             }
  //
  //                           }
  //                       ),
  //                     )
  //                   ],
  //                 );
  //               }
  //           ),
  //         );
  //       },
  //     )
  //   );
  // }

  /// É chamado após o cadastro do Recolhimento ser efetuado com sucesso.
  void _finalizarAgendamento(BuildContext context){
    Infraestrutura.mostrarMensagemDeSucesso(context, "Recolhimento agendado com sucesso.");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) => TelaPrincipal()), (route) => false
    );
  }

  /// Informa usuário que ocorreu uma falha ao agendar o recolhimento.
  void _informarErroNoAgendamento(BuildContext context){
    Infraestrutura.mostrarMensagemDeErro(context, "Aconteceu um erro ao realizar o agendamento.");
  }

}
