import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/preferencias.dart';

class TelaPreferencias extends StatefulWidget {
  @override
  _TelaPreferenciasState createState() => _TelaPreferenciasState();
}

class _TelaPreferenciasState extends State<TelaPreferencias> {

  //#region Atributos

  /// Define qual o aplicativo de mapa padrão selecionado.
  AplicativosDeMapa _appPadrao = Preferencias.aplicativosDeMapa;

  //#endregion Atributos

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          tilePreferenciaPadrao(
              context: context,
              titulo: "Aplicativo padrão para mapa",
              icone: Icons.location_pin,
              filhos: [
                tilePrefAppMapaPadrao()
              ]
          )
        ],
      ),
    );
  }

  /// Modelo de ExpandedTile padrão para ser reaproveitado em todas as preferências.
  Widget tilePreferenciaPadrao({BuildContext context, String titulo, IconData icone, List<Widget> filhos}) => ExpansionTile(
    title: Text(titulo,
        style: TextStyle(
            //color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold
        )),
    leading: Icon(icone),
    children: filhos,
  );

  /// Preferência de "Aplicativo padrão para mapa"
  Widget tilePrefAppMapaPadrao() {
    return Column(
      children: [
        RadioListTile<AplicativosDeMapa>(
          title: const Text("Google Maps"),
            value: AplicativosDeMapa.googleMaps,
            groupValue: _appPadrao,
            onChanged: (AplicativosDeMapa valor) async{

              setState(() {
                _appPadrao = valor;
              });
              await Preferencias().salvarPreferencia(PreferenciasDoApp.appPadraoMapas, _appPadrao);
            }
        ),
        RadioListTile<AplicativosDeMapa>(
          title: const Text("Waze"),
            value: AplicativosDeMapa.waze,
            groupValue: _appPadrao,
            onChanged: (AplicativosDeMapa valor) async{

              setState(() {
                _appPadrao = valor;
              });
              await Preferencias().salvarPreferencia(PreferenciasDoApp.appPadraoMapas, _appPadrao);
            }
        ),
      ],
    );
  }
}
