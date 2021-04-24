import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/models/usuario_model.dart';
import 'package:jsvillela_app/ui/widgets/drawer_button.dart';
import 'package:scoped_model/scoped_model.dart';

/// Custom Drawer usado como menu principal da aplicação.
class CustomDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ScopedModelDescendant<UsuarioModel>(
        builder: (context, child, model){
          return ListView(
            children: [
              Container(
                padding: EdgeInsets.all(32),
                color: PaletaDeCor.AZUL_BEM_CLARO,
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
                          Text("${model.dadosDoUsuario![UsuarioModel.CAMPO_NOME]}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(model.dadosDoUsuario![UsuarioModel.CAMPO_ATIVO] ?? false ? "Recolhedor ativo" : "Recolhedor inativo")
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
                    ItemDeMenu(Icons.home, "Início", AppPages.inicio),
                    ItemDeMenu(Icons.directions_car, "Agendar recolhimento", AppPages.agendarRecolhimento),
                    ItemDeMenu(Icons.search, "Consultar recolhimentos", AppPages.consultarRecolhimentos),
                    ItemDeMenu(Icons.notifications, "Notificações", AppPages.notificacoes),
                    ItemDeMenu(Icons.person, "Cadastro de redeiros", AppPages.cadastroDeRedeiros),
                    ItemDeMenu(Icons.people_sharp, "Grupos de redeiros", AppPages.gruposDeRedeiros),
                    ItemDeMenu(Icons.bookmark, "Solicitações dos redeiros", AppPages.solicitacoesDosRedeiros),
                    ItemDeMenu(Icons.dns_rounded, "Cadastro de matéria-prima", AppPages.cadastroDeMateriaPrima),
                    ItemDeMenu(Icons.grid_on, "Cadastro de redes", AppPages.cadastroDeRedes),
                    ItemDeMenu(Icons.bar_chart, "Relatórios", AppPages.relatorios),
                    ItemDeMenu(Icons.settings, "Preferências", AppPages.preferencias),
                    ItemDeMenu(Icons.logout, "Sair", AppPages.login),
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