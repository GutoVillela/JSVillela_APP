import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/models/usuario_model.dart';
import 'package:jsvillela_app/ui/tela_de_login.dart';

/// Cria um Item de Menu a ser utilizado no Drawer (menu) da aplicação.
class ItemDeMenu extends StatelessWidget {

  //#region Atributos

  ///Ícone a ser exibido.
  final IconData _icone;

  ///Texto a ser exibido.
  final String _texto;

  /// PageController usado para troca de telas.
  final PageController _pageController;

  /// Define para qual página o aplicativo será direcionado após clicar no botão.
  final AppPages _page;

  //#endregion Atributos

  //#region Construtores

  ItemDeMenu(this._icone, this._texto, this._pageController, this._page);

  //#endregion Construtores

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            int pagina;

            switch(_page){
              case AppPages.inicio:
                pagina = 0;
                break;
              case AppPages.agendarRecolhimento:
                pagina = 1;
                break;
              case AppPages.consultarRecolhimentos:
                pagina = 2;
                break;
              case AppPages.notificacoes:
                pagina = 3;
                break;
              case AppPages.cadastroDeRedeiros:
                pagina = 4;
                break;
              case AppPages.gruposDeRedeiros:
                pagina = 5;
                break;
              case AppPages.solicitacoesDosRedeiros:
                pagina = 6;
                break;
              case AppPages.cadastroDeMateriaPrima:
                pagina = 7;
                break;
              case AppPages.cadastroDeRedes:
                pagina = 8;
                break;
              case AppPages.relatorios:
                pagina = 9;
                break;
              case AppPages.preferencias:
                pagina = 10;
                break;
              case AppPages.login:
                new UsuarioModel().deslogarUsuario();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => TelaDeLogin()), (route) => false);
                return;
                break;
              default:
                pagina = 0;
                break;
            }
            Navigator.of(context).pop();
            _pageController.jumpToPage(pagina);
          },
          child: Container(
            padding: EdgeInsets.only(left: 20),
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(_icone, size: 20, color: Color.fromARGB(100, 255, 255, 255)),
                SizedBox(width: 32),
                Text(_texto.toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
