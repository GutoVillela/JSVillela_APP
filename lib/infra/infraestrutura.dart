import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:url_launcher/url_launcher.dart';

/// Classe contendo atributos e métodos utilitários comuns entre todas a telas.
class Infraestrutura {

  //#region Métodos

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
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2))
    );
  }

  /// Método que exibe um diálogo de confirmação padrão.
  static void confirmar({@required BuildContext context, @required String titulo, @required String mensagem, @required Function acaoAoConfirmar}){

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

  /// Abre o aplicativo padrão de mapa para as coordenadas fornecidas.
  static Future<void> abrirMapa(Position destino) async{

    String urlMapa = "";

    //Obter localização atual do usuário
    final origem = await Preferencias().obterLocalizacaoAtual();

    // Caso tenha retornado uma localização válida
    if(origem == null)
      throw Exception('Não foi possível obter a localização atual do dispositivo.');

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
  // /**
  //  * Uses refection (mirrors) to produce a Map (array) from an object's
  //  * variables. Making the variable name the key, and it's value the
  //  * value.
  //  */
  // Map objectToMap(Object object)
  // {
  //   // Mirror the particular instance (rather than the class itself)
  //   InstanceMirror instanceMirror = reflect(object);
  //   Map dataMapped = new Map();
  //
  //   // Mirror the instance's class (type) to get the declarations
  //   for (var declaration in instanceMirror.type.declarations.values)
  //   {
  //     // If declaration is a type of variable, map variable name and value
  //     if (declaration is VariableMirror)
  //     {
  //       String variableName = MirrorSystem.getName(declaration.simpleName);
  //       String variableValue = instanceMirror.getField(declaration.simpleName).reflectee;
  //
  //       dataMapped[variableName] = variableValue;
  //     }
  //   }
  //
  //   return dataMapped;
  // }
  //#endregion Métodos

}