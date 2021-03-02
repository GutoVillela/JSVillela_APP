import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/botao_quadrado.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaInformacoesDoRedeiro extends StatelessWidget {
  //#region Atributos
  /// Informações do redeiro.
  final DocumentSnapshot redeiro;

  //#endregion Atributos

  //#region Construtor(es)
  TelaInformacoesDoRedeiro(this.redeiro);

  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     child: LayoutBuilder(
    //       builder: (context, constraints){
    //
    //         // Pixels de overflow do ícone de Perfil
    //         double overflowIconePerfil = 50;
    //
    //         return Container(
    //           color: Colors.blue,
    //           width: constraints.maxWidth,
    //           height: constraints.maxHeight,
    //           child: Stack(
    //             alignment: Alignment.center,
    //             children: [
    //               CustomScrollView(
    //                 slivers: [
    //                   SliverAppBar(
    //                     floating: true,
    //                     snap: true,
    //                     backgroundColor: Colors.transparent,
    //                     elevation: 0,
    //                     flexibleSpace: FlexibleSpaceBar(
    //                       title: Text(redeiro[RedeiroModel.CAMPO_NOME]),
    //                       centerTitle: true,
    //                     ),
    //                   ),
    //                   SliverToBoxAdapter(
    //                     child: Column(
    //                       children: [
    //                         Stack(
    //                           overflow: Overflow.visible,
    //                           alignment: Alignment.center,
    //                           children: [
    //                             Container(
    //                               height: constraints.maxHeight * .2,
    //                               color: Colors.grey,
    //                             ),
    //                             Positioned(
    //                               bottom: 0 - overflowIconePerfil,
    //                                 child: ClipOval(
    //                                   child: Material(
    //                                     color: Colors.white,
    //                                     child: InkWell(
    //                                       splashColor: Colors.red, // inkwell color
    //                                       child: SizedBox(
    //                                           width: constraints.maxWidth * .3,
    //                                           height: constraints.maxWidth * .3,
    //                                           child: Icon(
    //                                               Icons.person,
    //                                               size: 40,
    //                                           )
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 )
    //                             )
    //                           ],
    //                         ),
    //                         SizedBox(height: overflowIconePerfil + 20),
    //                         Text(redeiro[RedeiroModel.CAMPO_NOME]),
    //                         Text(redeiro[RedeiroModel.CAMPO_ENDERECO]),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               )
    //             ],
    //           ),
    //         );
    //       }
    //     ),
    // );

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            //title: Text(redeiro[RedeiroModel.CAMPO_NOME]),
            centerTitle: true
        ),
        body: Container(
          child: LayoutBuilder(builder: (context, constraints) {

            // Pixels de overflow do ícone de Perfil
            double overflowIconePerfil = 50;

            // Recuperar informação se redeiro está ativo ou não
            bool redeiroAtivo = redeiro[RedeiroModel.CAMPO_ATIVO];

            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                child: Column(children: [
                  Stack(
                    overflow: Overflow.visible,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: constraints.maxHeight * .25,
                        color: Colors.grey,
                      ),
                      Positioned(
                          bottom: 0 - overflowIconePerfil,
                          child: ClipOval(
                            child: Material(
                              color: Theme.of(context).primaryColor.withOpacity(.5),
                              child: InkWell(
                                onTap: (){  },
                                splashColor: Colors.red, // inkwell color
                                child: SizedBox(
                                    width: constraints.maxWidth * .3,
                                    height: constraints.maxWidth * .3,
                                    child: Container(
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Theme.of(context).primaryColor
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                  SizedBox(height: overflowIconePerfil + 20),
                  Text(redeiro[RedeiroModel.CAMPO_NOME],
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )),
                  Text(redeiro[RedeiroModel.CAMPO_ENDERECO]),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          redeiroAtivo ? Icons.check_circle : Icons.cancel,
                        color: redeiroAtivo ? Theme.of(context).primaryColor
                            : Colors.red
                      ),
                      SizedBox(width: 5),
                      Text(redeiroAtivo ? "Redeiro ativo" : "Redeiro inativo",
                      style: TextStyle(
                        color: redeiroAtivo ?  PaletaDeCor.AZUL_CLARO
                            : Colors.red
                      ))
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      BotaoQuadrado(
                        altura: constraints.maxWidth * .5,
                        largura: constraints.maxWidth * .5,
                        textoPrincipal: "Ligar",
                        textoSecundario: redeiro[RedeiroModel.CAMPO_CELULAR],
                        icone: Icons.phone,
                        acaoAoClicar: (){
                          //Ligar para o número.
                          launch("tel://${redeiro[RedeiroModel.CAMPO_CELULAR]}");
                        }
                      ),
                      BotaoQuadrado(
                        altura: constraints.maxWidth * .5,
                        largura: constraints.maxWidth * .5,
                        textoPrincipal: "WhatsApp",
                        textoSecundario: redeiro[RedeiroModel.CAMPO_CELULAR],
                        icone: Icons.chat,
                        acaoAoClicar: (){
                          String numeroWpp = "55" + redeiro[RedeiroModel.CAMPO_CELULAR].toString().replaceAll(new RegExp(r'\('), '')
                          .replaceAll(new RegExp(r'\)'), '').replaceAll(new RegExp(r'-'), '').replaceAll(' ', '');

                          launch("https://wa.me/${numeroWpp}?text=${"Boa tarde, tudo bem?"}");
                        }
                      )
                    ],
                  ),
                  Row(
                    children: [
                      BotaoQuadrado(
                          altura: constraints.maxWidth * .5,
                          largura: constraints.maxWidth * .5,
                          textoPrincipal: "Caderno",
                          icone: Icons.perm_contact_cal_sharp,
                          textoSecundario: "",
                          acaoAoClicar: (){
                            //TODO: Implementar ação de VER CADERNO
                          }
                      ),
                      BotaoQuadrado(
                          altura: constraints.maxWidth * .5,
                          largura: constraints.maxWidth * .5,
                          textoPrincipal: "Grupo(s)",
                          textoSecundario: "",
                          icone: Icons.people_alt,
                          acaoAoClicar: (){
                            //TODO: Implementar ação de VISUALIZAR GRUPOS
                          }
                      )
                    ],
                  )
                ]),
              ),
            );
          }),
        ));
  }
}
