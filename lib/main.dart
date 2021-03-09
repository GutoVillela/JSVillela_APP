import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/ui/tela_de_login.dart';
import 'package:jsvillela_app/ui/tela_principal.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jsvillela_app/infra/preferencias.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Carregar preferências do usuário
  Preferencias preferencias = Preferencias();
  await preferencias.carregarPreferencias();

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
              child: FutureBuilder<bool>(
                future: new UsuarioModel().autoLogarUsuario(),
                builder: (context, snapshot){

                  if(!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                    );

                  // Verifica se usuário foi autologado
                  if(snapshot.data)
                    return TelaPrincipal();
                  else
                    return TelaDeLogin();
                },
              ),
              //child: TelaDeLogin(),
            ),
          )
        )
    );
  }
}
