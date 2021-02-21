import 'package:flutter/material.dart';
import 'package:jsvillela_app/ui/menu_tabs/home_tab.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_agendar_recolhimento.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_consultar_recolhimento.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_notificacoes.dart';
import 'package:jsvillela_app/ui/widgets/custom_drawer.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_novo_redeiro.dart';

import 'menu_tabs/tela_cadastro_de_redeiros.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {

  //#region Constantes
  /// Constante que define o nome do botão para a ação de Cadastrar novo Redeiro na barra de ações.
  static const String OPCAO_CADASTRAR_REDEIRO = "Cadastrar novo redeiro";
  //#endregion Constantes

  //#region Atributos

  ///Page controller usado para alternar páginas dentro do aplicativo.
  final _homeScreenPageController = PageController();

  /// Lista contento as opções que serão exibidas na barra de ação.
  final List<String> opcoesListaDeAcao = [OPCAO_CADASTRAR_REDEIRO];

  //#endregion Atributos

  //#region Métodos
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _homeScreenPageController,
      children: [
        Scaffold(
            body: HomeTab(),
            drawer: CustomDrawer(_homeScreenPageController),
            drawerScrimColor: Color.fromARGB(100, 100, 100, 100)
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("AGENDAR RECOLHIMENTO"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_homeScreenPageController),
            body: TelaAgendarRecolhimento()
        ),
        Scaffold(
            drawer: CustomDrawer(_homeScreenPageController),
            body: TelaConsultarRecolhimento()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("NOTIFICAÇÕES"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_homeScreenPageController),
            body: TelaNotificacoes()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("CADASTRO DE REDEIROS"),
              centerTitle: true,
              actions: [
                PopupMenuButton<String>(
                    onSelected: (opcaoSelecionada){
                      // Quando a opção de "Cadastrar novo redeiro" é selecionada na barra ação
                      if(opcaoSelecionada == OPCAO_CADASTRAR_REDEIRO){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => TelaCadastrarNovoRedeiro())
                        ).then((value){
                          setState(() {});// Atualizar estado da tela para recarregar os redeiros após cadastro.
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return opcoesListaDeAcao.map((e) => PopupMenuItem<String>(
                          value: e,
                          child: Text(e)
                      )).toList();
                    }
                )
              ],
            ),
            drawer: CustomDrawer(_homeScreenPageController),
            body: TelaCadastroDeRedeiros()
        ),
      ],
    );
  }
//#endregion Métodos
}
