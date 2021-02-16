import 'package:flutter/material.dart';
import 'package:jsvillela_app/ui/menu_tabs/home_tab.dart';
import 'package:jsvillela_app/ui/widgets/custom_drawer.dart';

class TelaPrincipal extends StatelessWidget{

  //#region Atributos

  ///Page controller used in the Home Screen page view.
  final _homeScreenPageController = PageController();

  //#endregion Atributos

  //#region StatelessWidget implementation
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

        )
      ],
    );
  }
  //#endregion StatelessWidget implementation

}