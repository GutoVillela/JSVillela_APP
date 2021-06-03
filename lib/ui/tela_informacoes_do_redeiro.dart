import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/tela_caderno_do_redeiro.dart';
import 'package:jsvillela_app/ui/widgets/botao_quadrado.dart';
import 'package:jsvillela_app/ui/widgets/tela_busca_grupos_de_redeiros.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaInformacoesDoRedeiro extends StatelessWidget {
  //#region Atributos
  /// Informações do redeiro.
  final RedeiroDmo redeiro;

  //#endregion Atributos

  //#region Construtor(es)
  TelaInformacoesDoRedeiro(this.redeiro);

  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {

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
            bool redeiroAtivo = redeiro.ativo;

            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                child: Column(children: [
                  Stack(
                    clipBehavior: Clip.none,
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
                  Text(redeiro.nome,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )),
                  Text(redeiro.endereco.toString(), textAlign: TextAlign.center),
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
                        textoSecundario: redeiro.celular,
                        icone: Icons.phone,
                        acaoAoClicar: (){
                          //Ligar para o número.
                          launch("tel://${redeiro.celular}");
                        }
                      ),
                      BotaoQuadrado(
                        altura: constraints.maxWidth * .5,
                        largura: constraints.maxWidth * .5,
                        textoPrincipal: "WhatsApp",
                        textoSecundario: redeiro.celular,
                        icone: Icons.chat,
                        acaoAoClicar: (){
                          String numeroWpp = "55" + redeiro.celular!.replaceAll(new RegExp(r'\('), '')
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
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => TelaCadernoDoRedeiro(redeiro: redeiro))
                            );
                          }
                      ),
                      BotaoQuadrado(
                          altura: constraints.maxWidth * .5,
                          largura: constraints.maxWidth * .5,
                          textoPrincipal: "Grupo(s)",
                          textoSecundario: "",
                          icone: Icons.people_alt,
                          acaoAoClicar: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return TelaBuscaGruposDeRedeiros(gruposJaSelecionados: redeiro.gruposDoRedeiro);
                                }
                            ).then((gruposSelecionados) {
                                if(gruposSelecionados != null){
                                  Infraestrutura.mostrarDialogoDeCarregamento(context: context, titulo: "Atualizando grupos do redeiro...");

                                  redeiro.gruposDoRedeiro = gruposSelecionados;

                                  RedeiroModel().atualizarRedeiro(dadosDoRedeiro: redeiro,
                                    onSuccess: (){
                                    Infraestrutura.mostrarMensagemDeSucesso(context, "Grupos do redeiro alterados com sucesso!");
                                    },
                                    onFail: (){
                                      Infraestrutura.mostrarMensagemDeErro(context, "Não foi possível alterar os grupos do redeiro.");
                                    });

                                  // Esconder diálogo de carregamento
                                  Navigator.of(context).pop();
                                }
                            });
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
