import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/ui/menu_tabs/home_tab.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_agendar_recolhimento.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_cadastro_de_mat_prima.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_cadastro_de_redes.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_consultar_recolhimento.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_notificacoes.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_preferencias.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_relatorios.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_nova_materia_prima.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_nova_rede.dart';
import 'package:jsvillela_app/ui/widgets/custom_drawer.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_novo_redeiro.dart';
import 'file:///C:/Users/gusta/AndroidStudioProjects/jsvillela_app/lib/ui/menu_tabs/tela_consultar_solicitacoes_redeiros.dart';

import 'menu_tabs/tela_cadastro_de_redeiros.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {

  //#region Constantes
  /// Constante que define o nome do botão para a ação de Cadastrar novo Redeiro na barra de ações.
  static const String OPCAO_CADASTRAR_REDEIRO = "Cadastrar novo redeiro";

  /// Constante que define o nome do botão para a ação de Cadastrar nova Rede na barra de ações.
  static const String OPCAO_CADASTRAR_REDE = "Cadastrar nova rede";

  /// Constante que define o nome do botão para a ação de Cadastrar nova Matéria-Prima na barra de ações.
  static const String OPCAO_CADASTRAR_MATERIA_PRIMA = "Cadastrar nova matéria-prima";

  /// Constante que define o nome do botão para a ação de Consultar as Solicitações dos Redeiros na barra de ações.
  static const String OPCAO_SOLICITACOES_DOS_REDEIROS = "Solicitações dos Redeiros";

  //#endregion Constantes

  //#region Atributos

  ///Page controller usado para alternar páginas dentro do aplicativo.
  final _homeScreenPageController = PageController();

  /// Lista contento as opções que serão exibidas na barra de ação da tela "Cadastro de Redeiros".
  final List<String> opcoesListaDeAcaoTelaCadastroRedeiros = [OPCAO_CADASTRAR_REDEIRO];

  /// Lista contento as opções que serão exibidas na barra de ação da tela "Cadastro de Redes".
  final List<String> opcoesListaDeAcaoTelaCadastroRedes = [OPCAO_CADASTRAR_REDE];

  /// Lista contento as opções que serão exibidas na barra de ação da tela "Cadastro de Matéria-Prima".
  final List<String> opcoesListaDeAcaoTelaCadastroMateriaPrima = [OPCAO_CADASTRAR_MATERIA_PRIMA];

  /// Lista contento as opções que serão exibidas na barra de ação da tela "Cadastro de Matéria-Prima".
  final List<String> opcoesListaDeAcaoTelaConsultarSolicitacoesRedeiros = [OPCAO_SOLICITACOES_DOS_REDEIROS];

  //#endregion Atributos

  //#region Métodos
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _homeScreenPageController,
      children: [
        Scaffold(
            appBar: AppBar(
              title: Text("RECOLHEDOR"),
              centerTitle: true,
              backgroundColor: PaletaDeCor.AZUL_BEM_CLARO,
            ),
            body: HomeTab(),
            drawer: CustomDrawer(_homeScreenPageController),
            drawerScrimColor: Color.fromARGB(100, 100, 100, 100)
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("AGENDAR RECOLHIMENTO"),
              centerTitle: true,
              backgroundColor: PaletaDeCor.AZUL_BEM_CLARO,
            ),
            drawer: CustomDrawer(_homeScreenPageController),
            drawerScrimColor: PaletaDeCor.AZUL_BEM_CLARO,
            body: TelaAgendarRecolhimento()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("CONSULTAR RECOLHIMENTOS"),
              centerTitle: true,
              //backgroundColor: PaletaDeCor.AZUL_BEM_CLARO,
            ),
            //drawerScrimColor: PaletaDeCor.AZUL_BEM_CLARO,
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
                      return opcoesListaDeAcaoTelaCadastroRedeiros.map((e) => PopupMenuItem<String>(
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
        Scaffold(
            appBar: AppBar(
              title: Text("GRUPO DE REDEIROS"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_homeScreenPageController),
            body: TelaAgendarRecolhimento()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("SOLICITAÇÕES DOS REDEIROS"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_homeScreenPageController),
            body: TelaConsultarSolicitacoesRedeiros()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("CADASTRO DE MATÉRIA-PRIMA"),
              centerTitle: true,
              actions: [
                PopupMenuButton<String>(
                    onSelected: (opcaoSelecionada){
                      // Quando a opção de "Cadastrar nova matéria-prima" é selecionada na barra ação
                      if(opcaoSelecionada == OPCAO_CADASTRAR_MATERIA_PRIMA){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => TelaCadastrarMateriaPrima())
                        ).then((value){
                          setState(() {});// Atualizar estado da tela para recarregar as matérias-primas após cadastro.
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return opcoesListaDeAcaoTelaCadastroMateriaPrima.map((e) => PopupMenuItem<String>(
                          value: e,
                          child: Text(e)
                      )).toList();
                    }
                )
              ],
            ),
            drawer: CustomDrawer(_homeScreenPageController),
            body: TelaCadastroDeMateriaPrima()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("CADASTRO DE REDES"),
              centerTitle: true,
              actions: [
                PopupMenuButton<String>(
                    onSelected: (opcaoSelecionada){
                      print(opcaoSelecionada);
                      // Quando a opção de "Cadastrar nova rede" é selecionada na barra ação
                      if(opcaoSelecionada == OPCAO_CADASTRAR_REDE){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => TelaCadastrarNovaRede())
                        ).then((value){
                          setState(() {});// Atualizar estado da tela para recarregar as redes após cadastro.
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return opcoesListaDeAcaoTelaCadastroRedes.map((e) => PopupMenuItem<String>(
                          value: e,
                          child: Text(e)
                      )).toList();
                    }
                )
              ],
            ),
            drawer: CustomDrawer(_homeScreenPageController),
            body: TelaCadastroDeRedes()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("RELATÓRIOS"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_homeScreenPageController),
            body: TelaRelatorios()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("PREFERÊNCIAS"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_homeScreenPageController),
            body: TelaPreferencias()
        ),
      ],
    );
  }
//#endregion Métodos
}
