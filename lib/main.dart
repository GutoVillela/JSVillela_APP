import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_cadastro_de_mat_prima.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_cadastro_de_redeiros.dart';
import 'package:jsvillela_app/ui/menu_tabs/tela_cadastro_de_redes.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_nova_rede.dart';
import 'package:jsvillela_app/ui/tela_cadastrar_novo_redeiro.dart';
import 'package:jsvillela_app/ui/tela_de_login.dart';
import 'package:jsvillela_app/ui/tela_informacoes_do_redeiro.dart';
import 'package:jsvillela_app/ui/tela_principal.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UsuarioModel>(
        model: UsuarioModel(),
        child: MaterialApp(
          title: 'JS Villela ME',
          theme: ThemeData(
            fontFamily: "Nunito",
            primarySwatch: Colors.blue,
            primaryColor: Color.fromARGB(255, 10, 66, 168),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Colors.white,
              elevation: 0
            ),
            primaryIconTheme: IconThemeData(
              color: PaletaDeCor.AZUL_ESCURO
            ),
            primaryTextTheme: TextTheme(
              headline6: TextStyle(
                  color: PaletaDeCor.AZUL_ESCURO,
                  fontWeight: FontWeight.bold
              )// Texto da AppBar
            ),
            textTheme: TextTheme(
              headline1: TextStyle(color: PaletaDeCor.AZUL_ESCURO)
            )
          ),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              child: TelaDeLogin(),
            ),
          )
        )
    );
  }
}
