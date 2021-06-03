import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jsvillela_app/dml/recolhimento_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/stores/agendar_recolhimento_store.dart';
import 'package:jsvillela_app/ui/tela_principal.dart';

class TelaConfirmarRecolhimento extends StatefulWidget {

  //#region Atributos
  /// Recolhimento a ser cadastrado ou editado.
  final RecolhimentoDmo _recolhimento;

  /// Lista com as cidades a serem visitadas no recolhimento.
  final List<String> _listaDeCidades;

  /// Define o tipo de manutenção que será realizada para o recolhimento (Inclusão ou Alteração)
  final TipoDeManutencao _tipoDeManutencao;

  /// Store usado para gerenciar os estados da tela.
  late final AgendarRecolhimentoStore store;
  //#endregion Atributos

  //#region Construtor(es)
  TelaConfirmarRecolhimento(this._recolhimento, this._listaDeCidades, this._tipoDeManutencao){
    store = AgendarRecolhimentoStore(tipoDeManutencao: _tipoDeManutencao, recolhimentoASerEditado: _recolhimento);
    store.setDataDoRecolhimento(_recolhimento.dataDoRecolhimento);
    store.setGruposDeRedeiros(_recolhimento.gruposDoRecolhimento);
  }
  //#endregion Construtor(es)

  @override
  _TelaConfirmarRecolhimentoState createState() => _TelaConfirmarRecolhimentoState();
}

class _TelaConfirmarRecolhimentoState extends State<TelaConfirmarRecolhimento> {


  //#region Métodos
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
              child: Column(
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
                        itemCount: widget._listaDeCidades.length,
                        itemBuilder: (context, index){
                          return Center(
                              child: Text(
                                widget._listaDeCidades[index],
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
                    child: Observer(builder: (_){
                      return ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                                return Theme.of(context).primaryColor;
                              })
                          ),
                          child: !widget.store.processando ?
                          Text(
                            widget.store.tipoDeManutencao ==
                                TipoDeManutencao.cadastro
                                ? "Concluir agendamento"
                                : "Concluir edição",
                            style: TextStyle(fontSize: 20),
                          ) :
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                          onPressed: !widget.store.habilitaBotaoDeCadastro ? null :  () async {

                            if(widget._recolhimento.gruposDoRecolhimento.isEmpty)
                              Infraestrutura.mostrarMensagemDeErro(context, "Selecione pelo menos um grupo de redeiros para prosseguir.");
                            else{

                              try{
                                if(await widget.store.cadastrarOuEditarRecolhimento() != null)
                                  _finalizarAgendamento(context);
                                else
                                  _informarErroNoAgendamento(context);

                              }catch(e){
                                _informarErroNoAgendamento(context);
                              }
                            }

                          }
                      );
                    }),
                  )
                ],
              ),
            );
          },
        )
    );
  }

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
//#endregion Métodos


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
}
