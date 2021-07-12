import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/stores/carrousel_de_itens_store.dart';
import 'package:jsvillela_app/stores/consultar_recolhimentos_store.dart';
import 'package:jsvillela_app/stores/consultar_redeiros_store.dart';
import 'package:jsvillela_app/stores/consultar_rede_store.dart';
import 'package:jsvillela_app/stores/consultar_materia_prima_store.dart';
import 'package:jsvillela_app/stores/inicio_store.dart';
import 'package:jsvillela_app/stores/login_store.dart';
import 'package:jsvillela_app/stores/navegacao_store.dart';
import 'package:jsvillela_app/ui/tela_de_login.dart';
import 'package:jsvillela_app/ui/tela_principal.dart';
import 'package:provider/provider.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar o Parse Server
  await Infraestrutura.inicializarParseServer();

  // Carregar preferências do usuário
  Preferencias preferencias = Preferencias();
  await preferencias.carregarPreferencias();
  setupLocators();

  runApp(MyApp());
}

/// Método que configura os Locators da aplicação
void setupLocators(){
  // Desta forma a mesma instância das classes estarão disponíveis em toda a aplicação
  GetIt.I.registerSingleton(NavegacaoStore());
  GetIt.I.registerSingleton(InicioStore());
  GetIt.I.registerSingleton(ConsultarRedeirosStore());
  GetIt.I.registerSingleton(ConsultarRecolhimentosStore());
  GetIt.I.registerSingleton(ConsultarRedeStore());
  GetIt.I.registerSingleton(ConsultarMateriaPrimaStore());
  GetIt.I.registerSingleton(CarrouselDeItensStore());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Provider(
      create: (_) => LoginStore(),
      child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate
          ],
          supportedLocales: [
            Locale(WidgetsBinding.instance!.window.locale.languageCode, WidgetsBinding.instance!.window.locale.countryCode)
          ],
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
              child: autoLogarUsuario() ? TelaPrincipal() : TelaDeLogin(),
            ),
          )
      ),
    );
  }

  /// Verifica se existe um usuário autolagado no sistema.
  bool autoLogarUsuario(){
    return Preferencias.idUsuarioLogado != null;
  }
}