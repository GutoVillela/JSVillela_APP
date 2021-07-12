import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/stores/navegacao_store.dart';
import 'package:jsvillela_app/ui/menu_tabs/home_tab.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_agendar_recolhimento.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_cadastro_de_grupos_de_redeiros.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_cadastro_de_mat_prima.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_cadastro_de_redes.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_consultar_recolhimento.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_notificacoes.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_preferencias.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_relatorios.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_nova_materia_prima.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_nova_rede.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_novo_grupo_de_redeiros.dart';
import 'package:jsvillela_app/ui/widgets/custom_drawer.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_novo_redeiro.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_consultar_solicitacoes_redeiros.dart';
import 'package:mobx/mobx.dart';

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

  /// Constante que define o nome do botão para a ação de Cadastrar novo Grupo na barra de ações.
  static const String OPCAO_CADASTRAR_NOVO_GRUPO_DE_REDEIROS = "Cadastrar novo grupo de redeiros";

  /// Constante que define o nome do botão para a ação de Consultar as Solicitações dos Redeiros na barra de ações.
  static const String OPCAO_SOLICITACOES_DOS_REDEIROS = "Solicitações dos Redeiros";

  //#endregion Constantes

  //#region Atributos

  /// Store que é utilizada para navegar entre telas.
  final NavegacaoStore navegacaoStore = GetIt.I<NavegacaoStore>();

  ///Page controller usado para alternar páginas dentro do aplicativo.
  final _homeScreenPageController = PageController();

  /// Lista contento as opções que serão exibidas na barra de ação da tela "Cadastro de Redeiros".
  final List<String> opcoesListaDeAcaoTelaCadastroRedeiros = [OPCAO_CADASTRAR_REDEIRO];

  /// Lista contento as opções que serão exibidas na barra de ação da tela "Cadastro de Redes".
  final List<String> opcoesListaDeAcaoTelaCadastroRedes = [OPCAO_CADASTRAR_REDE];

  /// Lista contento as opções que serão exibidas na barra de ação da tela "Cadastro de Matéria-Prima".
  final List<String> opcoesListaDeAcaoTelaCadastroMateriaPrima = [OPCAO_CADASTRAR_MATERIA_PRIMA];

  /// Lista contento as opções que serão exibidas na barra de ação da tela "Cadastro de Grupo de Redeiros".
  final List<String> opcoesListaDeAcaoTelaCadastroDeGrupoDeRedeiros = [OPCAO_CADASTRAR_NOVO_GRUPO_DE_REDEIROS];

  /// Lista contento as opções que serão exibidas na barra de ação da tela "Cadastro de Matéria-Prima".
  final List<String> opcoesListaDeAcaoTelaConsultarSolicitacoesRedeiros = [OPCAO_SOLICITACOES_DOS_REDEIROS];

  //#endregion Atributos

  //#region Métodos
  
  @override
  void initState() {
    super.initState();

    /// Reaction que fica observando a página atual do aplicativo
    reaction((_) => navegacaoStore.paginaAtual, (int pagina){
      _homeScreenPageController.jumpToPage(pagina);
    });
  }
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _homeScreenPageController,
      children: [
        HomeTab(),
        TelaAgendarRecolhimento(tipoDeManutencao: TipoDeManutencao.cadastro),
        Scaffold(
            appBar: AppBar(
              title: Text("CONSULTAR RECOLHIMENTOS"),
              centerTitle: true,
              //backgroundColor: PaletaDeCor.AZUL_BEM_CLARO,
            ),
            //drawerScrimColor: PaletaDeCor.AZUL_BEM_CLARO,
            drawer: CustomDrawer(),
            body: TelaConsultarRecolhimento()
        ),
        TelaNotificacoes(),
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
                            MaterialPageRoute(builder: (context) => TelaCadastrarNovoRedeiro(tipoDeManutencao: TipoDeManutencao.cadastro))
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
            drawer: CustomDrawer(),
            body: TelaCadastroDeRedeiros()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("GRUPO DE REDEIROS"),
              centerTitle: true,
              actions: [
                PopupMenuButton<String>(
                    onSelected: (opcaoSelecionada){
                      // Quando a opção de "Grupo de Redeiros" é selecionada na barra ação
                      if(opcaoSelecionada == OPCAO_CADASTRAR_NOVO_GRUPO_DE_REDEIROS){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => TelaCadastrarNovoGrupoDeRedeiros(tipoDeManutencao: TipoDeManutencao.cadastro))
                        ).then((value){
                          setState(() {});// Atualizar estado da tela para recarregar os grupos
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return opcoesListaDeAcaoTelaCadastroDeGrupoDeRedeiros.map((e) => PopupMenuItem<String>(
                          value: e,
                          child: Text(e)
                      )).toList();
                    }
                )
              ],
            ),
            drawer: CustomDrawer(),
            body: TelaCadastroDeGruposDeRedeiros()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("SOLICITAÇÕES DOS REDEIROS"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(),
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
                            MaterialPageRoute(builder: (context) => TelaCadastrarMateriaPrima(tipoDeManutencao: TipoDeManutencao.cadastro))
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
            drawer: CustomDrawer(),
            body: TelaCadastroDeMateriaPrima()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("CADASTRO DE REDES"),
              centerTitle: true,
              actions: [
                PopupMenuButton<String>(
                    onSelected: (opcaoSelecionada){
                      // Quando a opção de "Cadastrar nova rede" é selecionada na barra ação
                      if(opcaoSelecionada == OPCAO_CADASTRAR_REDE){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => TelaCadastrarNovaRede(tipoDeManutencao: TipoDeManutencao.cadastro))
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
            drawer: CustomDrawer(),
            body: TelaCadastroDeRedes()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("RELATÓRIOS"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(),
            body: TelaRelatorios()
        ),
        Scaffold(
            appBar: AppBar(
              title: Text("PREFERÊNCIAS"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(),
            body: TelaPreferencias()
        ),
      ],
    );
  }
//#endregion Métodos
}
