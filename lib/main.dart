import 'package:jsvillela_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/ui/tela_de_login.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
            primaryColor: Color.fromARGB(255, 10, 66, 168)
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
