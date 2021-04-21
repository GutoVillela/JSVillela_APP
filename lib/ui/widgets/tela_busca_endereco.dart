import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/sugestao_endereco_dmo.dart';
import 'package:jsvillela_app/services/google_place_service.dart';

class TelaBuscaEndereco extends SearchDelegate<SugestaoEnderecoDmo?>{

  //#region Atributos

  /// Token da Sessão.
  final sessionToken;

  /// Instâcia da classe de serviço do Google Places.
  late GooglePlaceServiceProvider servicoGooglePlaces;

  /// Lista de sugestões de endereço obtidas na busca (para evitar nova requisição no método buildResults.
  List<SugestaoEnderecoDmo> sugestoesDeEndereco = [];

  /// Texto que aparecerá na barra de pesquisa.
  @override
  String get searchFieldLabel => "Digite seu endereço";
  //#endregion Atributos

  //#region Construtor(es)
  TelaBuscaEndereco(this.sessionToken){
    servicoGooglePlaces = GooglePlaceServiceProvider(sessionToken);
  }
  //#endregion Construtor(es)

  //#region Implementação da interface SearchDelegate
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: "Limpar",
        icon: Icon(Icons.clear),
        onPressed: (){
          // Limpar query de busca
          query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Voltar',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.location_on_outlined),
        title:
        Text(sugestoesDeEndereco[index].descricaoEndereco),
        onTap: () {
          close(context, sugestoesDeEndereco[index]);
        },
      ),
      itemCount: sugestoesDeEndereco.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return sugestoesDeBusca(context);
  }
  //#endregion Implementação da interface SearchDelegate

  /// Widget que monta as sugestões de busca.
  Widget sugestoesDeBusca(BuildContext context) => FutureBuilder(
    future: query.isEmpty
        ? null
        : servicoGooglePlaces.obterSugestoesDeEndereco(
        query, Localizations.localeOf(context).languageCode),
        builder: (context, snapshot) {
          if(query == '')
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Text('Digite seu endereço.')
            );

          if(!snapshot.hasData)
            return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                )
            );

          sugestoesDeEndereco = snapshot.data as List<SugestaoEnderecoDmo>;

          return ListView.builder(
            itemBuilder: (context, index) {

              // Adicionar endereço à lista de sugestões de endereço.
              //sugestoesDeEndereco.add((snapshot.data[index] as SugestaoEnderecoDmo));

              return ListTile(
                leading: Icon(Icons.location_on_outlined),
                title:
                Text(sugestoesDeEndereco[index].descricaoEndereco),
                onTap: () {
                  close(context, sugestoesDeEndereco[index]);
                },
              );
            },
            itemCount: sugestoesDeEndereco.length,
          );
        }
    );

}
