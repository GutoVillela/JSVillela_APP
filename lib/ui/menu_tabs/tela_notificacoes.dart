import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/stores/aviso_store.dart';
import 'package:jsvillela_app/stores/navegacao_store.dart';
import 'package:jsvillela_app/ui/widgets/custom_drawer.dart';

class TelaNotificacoes extends StatefulWidget {

  @override
  _TelaNotificacoesState createState() => _TelaNotificacoesState();
}

class _TelaNotificacoesState extends State<TelaNotificacoes> {
  //#region Atributos

  /// Store que manipula informações da tela.
  final AvisoStore store = AvisoStore();

  //#endregion Atributos

  //#region Métodos
  @override
  void initState() {
    super.initState();

    // Resetar notificações ao entrar na tela de notificações
    final NavegacaoStore navStore = GetIt.I<NavegacaoStore>();
    navStore.setNotificacoes(0);
  }

  @override
  Widget build(BuildContext context) {
    store.carregarAvisos();
    return Scaffold(
        appBar: AppBar(
          title: Text("NOTIFICAÇÕES"),
          centerTitle: true,
        ),
        drawer: CustomDrawer(),
        body: Container(
          padding: EdgeInsets.all(12),
          color: PaletaDeCor.AZUL_BEM_CLARO,
          child: Column(
            children: [
              Expanded(
                child: Observer(
                    builder: (context){
                      if(store.processando)
                        return _carregando(context);

                      return ListView.separated(
                        separatorBuilder: (_, __){
                          return Divider();
                        },
                        itemBuilder: (context, index) => _tileAviso(context, index),
                        itemCount: store.avisos.length,
                      );
                    }
                ),
              )
            ],
          ),
        )
    );
  }

  /// Widget padrão para exibir informações do recolhimento.
  Widget _tileAviso(BuildContext context, int index) => Dismissible(
    key: ValueKey(index),
    onDismissed: (DismissDirection direcao){
      store.descartarAvisoDoUsuario(store.avisos[index].idAvisoDoUsuario);
    },
    background: Container(
      color: PaletaDeCor.ROXO_CLARO,
    ),
    child: ListTile(
      tileColor: Colors.white,
      contentPadding: EdgeInsets.all(10),
      leading: Icon(Icons.notifications),
      title: Text(store.avisos[index].titulo),
      subtitle: Text(store.avisos[index].texto),
    ),
  );

  /// Widget que desenha ícone de carregamento
  Widget _carregando(BuildContext context) => Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).primaryColor),
    ),
  );
//#endregion Métodos
}