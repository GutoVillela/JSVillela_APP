import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/stores/navegacao_store.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

/// Classe contendo atributos e métodos utilitários comuns entre todas a telas.
class Infraestrutura {



  //#region Métodos

  /// Inicializa o Parse Server
  static Future<void> inicializarParseServer() async{

    // Inicializar o Firebase
    await Firebase.initializeApp();

    await Parse().initialize(
        '',
        'https://parseapi.back4app.com/',
        clientKey: '',
        autoSendSessionId: true,
        debug: true
    );
  }

  /// Configura o ambiente para receber push notifications.
  static Future<void> configurarPushFCM(String idUsuario) async{

    // Obter token do dispositivo
    String? token = await FirebaseMessaging.instance.getToken();

    // Definir GCMSenderId e Token do dispositivo para PUSH NOTIFICATION
    ParseInstallation installation = await ParseInstallation.currentInstallation();
    installation.set("deviceToken", token);
    installation.set("GCMSenderId", "125937015070");
    installation.set("usuario", (ParseUser('', '', '')..objectId =idUsuario).toPointer());
    installation.subscribeToChannel("recolhedores");
    installation.save();

    // Configurar os eventos de Push Notification
    FirebaseMessaging.onBackgroundMessage(receberPushEmBackground);
    FirebaseMessaging.onMessage.listen(receberPush);
    FirebaseMessaging.onMessageOpenedApp.listen(receberPushComAppAberto);
  }

  // Evento que processa Push Notifications recebidas com o aplicativo em Background.
  static Future<void> receberPushEmBackground(RemoteMessage message) async {
    print("Método: receberPushEmBackground");
    final NavegacaoStore store = GetIt.I<NavegacaoStore>();
    store.incrementarNotificacao();
  }

  /// Evento que processa Push Notifications recebidas com o aplicativo aberto.
  static void receberPushComAppAberto(RemoteMessage message) async {
    final NavegacaoStore store = GetIt.I<NavegacaoStore>();
    store.incrementarNotificacao();
    print("Método: receberPushComAppAberto");
  }

  /// Evento que processa Push Notifications recebidas de forma geral.
  static void receberPush(RemoteMessage message) async {
    final NavegacaoStore store = GetIt.I<NavegacaoStore>();
    store.incrementarNotificacao();
    print('MENSAGEM: ${message.data['uri']}');
    print("Método: receberPush");
  }

  /// Exibe uma mensagem padrão de erro em forma de SnackBar.
  static void mostrarMensagemDeErro(BuildContext context, String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(mensagem),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2))
    );
  }

  /// Exibe uma mensagem padrão de sucesso em forma de SnackBar.
  static void mostrarMensagemDeSucesso(BuildContext context, String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(mensagem),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 2))
    );
  }

  /// Método que exibe um diálogo de confirmação padrão.
  static void confirmar({required BuildContext context, required String titulo, required String mensagem, required Function()? acaoAoConfirmar}){

    // Botão de Cancelar
    Widget botaoCancelar = TextButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // Botão de confirmar
    Widget botaoConfirmar = TextButton(
      child: Text("Confirmar"),
      onPressed: acaoAoConfirmar,
    );


    // Diálogo de confirmação
    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        botaoCancelar,
        botaoConfirmar,
      ],
    );

    // Exibir diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Método que exibe um diálogo de aviso padrão.
  static void mostrarAviso({required BuildContext context, required String titulo, required String mensagem, required Function() acaoAoConfirmar}){

    // Botão de confirmar
    Widget botaoConfirmar = TextButton(
      child: Text("OK"),
      onPressed: acaoAoConfirmar,
    );


    // Diálogo de confirmação
    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        botaoConfirmar,
      ],
    );

    // Exibir diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Método que exibe um diálogo com um Widget de processamento.
  static void mostrarDialogoDeCarregamento({required BuildContext context, required String titulo}){

    // Diálogo de processamento.
    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Container(
        height: 30,
        child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            )
        ),
      ),
    );

    // Exibir diálogo
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => alert
    );
  }

  /// Abre o aplicativo padrão de mapa para as coordenadas fornecidas.
  static Future<void> abrirMapa(Position destino) async{

    String urlMapa = "";

    //Obter localização atual do usuário
    final origem = await Preferencias().obterLocalizacaoAtual();

    if (Platform.isAndroid) {
      // Implementação da abertura do Mapa para Android
      switch(Preferencias.aplicativosDeMapa){
        case AplicativosDeMapa.googleMaps:
          urlMapa = 'https://www.google.com/maps/dir/?api=1&origin=${origem.latitude},${origem.longitude}&destination=${destino.latitude},${destino.longitude}&travelmode=driving';
          break;
        case AplicativosDeMapa.waze:
          urlMapa = 'https://waze.com/ul?ll=${destino.latitude},${destino.longitude}&navigate=yes&z=10';
          break;
        default:
          urlMapa = 'https://www.google.com/maps/dir/?api=1&origin=${origem.latitude},${origem.longitude}&destination=${destino.latitude},${destino.longitude}&travelmode=driving';
          break;
      }
    } else if (Platform.isIOS) {
      // Implementação da abertura do Mapa para IOS
      switch(Preferencias.aplicativosDeMapa){
        case AplicativosDeMapa.googleMaps:
          urlMapa = 'http://maps.apple.com/?saddr=${origem.latitude},${origem.longitude}&daddr=${destino.latitude},${destino.longitude}';
          break;
        case AplicativosDeMapa.waze:
          urlMapa = 'https://waze.com/ul?ll=${destino.latitude},${destino.longitude}&navigate=yes&z=10';
          break;
        default:
          urlMapa = 'http://maps.apple.com/?saddr=${origem.latitude},${origem.longitude}&daddr=${destino.latitude},${destino.longitude}';
          break;
      }
    }

    print(urlMapa);

    if (!await canLaunch(urlMapa))
      throw Exception('Não foi possível abrir o aplicativo de mapa.');

    await launch(urlMapa);
  }
  //#endregion Métodos

}