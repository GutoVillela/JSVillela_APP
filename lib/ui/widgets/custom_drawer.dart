import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/models/usuario_model.dart';
import 'package:jsvillela_app/ui/widgets/drawer_button.dart';
import 'package:scoped_model/scoped_model.dart';

/// Custom Drawer usado como menu principal da aplicação.
class CustomDrawer extends StatelessWidget {

  //#region Atributos

  ///Page controller usado para alternar entre as páginas da aplicação.
  final PageController _customDrawerPageController;

  //#endregion Atributos

  //#region Construtor(es)

  CustomDrawer(this._customDrawerPageController);

  //#endregion Construtor(es)

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ScopedModelDescendant<UsuarioModel>(
        builder: (context, child, model){
          return ListView(
            children: [
              Container(
                padding: EdgeInsets.all(32),
                color: PaletaDeCor.AZUL_MARINHO,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person_pin,
                        color: Theme.of(context).primaryColor,
                        size: 60
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${model.dadosDoUsuario[UsuarioModel.CAMPO_NOME]}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(model.dadosDoUsuario[UsuarioModel.CAMPO_ATIVO] ? "Recolhedor ativo" : "Recolhedor inativo")
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    ItemDeMenu(Icons.directions_car, "Agendar recolhimento", _customDrawerPageController, AppPages.agendarRecolhimento),
                    ItemDeMenu(Icons.search, "Consultar recolhimentos", _customDrawerPageController, AppPages.consultarRecolhimentos),
                    ItemDeMenu(Icons.notifications, "Notificações", _customDrawerPageController, AppPages.notificacoes),
                    ItemDeMenu(Icons.person, "Cadastro de redeiros", _customDrawerPageController, AppPages.cadastroDeRedeiros),
                    ItemDeMenu(Icons.people_sharp, "Grupos de redeiros", _customDrawerPageController, AppPages.gruposDeRedeiros),
                    ItemDeMenu(Icons.bookmark, "Solicitações dos redeiros", _customDrawerPageController, AppPages.solicitacoesDosRedeiros),
                    ItemDeMenu(Icons.dns_rounded, "Cadastro de matéria-prima", _customDrawerPageController, AppPages.cadastroDeMateriaPrima),
                    ItemDeMenu(Icons.grid_on, "Cadastro de redes", _customDrawerPageController, AppPages.cadastroDeRedes),
                    ItemDeMenu(Icons.bar_chart, "Relatórios", _customDrawerPageController, AppPages.relatorios),
                    ItemDeMenu(Icons.settings, "Preferências", _customDrawerPageController, AppPages.preferencias),
                    ItemDeMenu(Icons.logout, "Sair", _customDrawerPageController, AppPages.login),
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
              )
            ],
          );
        }
      ),
    );
  }
}