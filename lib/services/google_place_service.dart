import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:jsvillela_app/dml/endereco_dmo.dart';
import 'package:jsvillela_app/dml/sugestao_endereco_dmo.dart';

/// Classe de serviço para API do Google Places.
class GooglePlaceServiceProvider {

  //#region Atributos

  /// Client para as requisições.
  final client = Client();

  /// Token da Sessão.
  final sessionToken;

  /// Chave da API do Google para dispositivos Android.
  static final String androidKey = 'AIzaSyAtsWz3hEnP-lEZtJaBaV9EktLweLajEp4';

  /// Chave da API do Google para dispositivos IOS.
  static final String iosKey = 'YOUR_API_KEY_HERE';

  /// Chave da API a ser aplicada nos serviços, definida com base no SO do usuário.
  final apiKey = Platform.isAndroid ? androidKey : iosKey;
  //#endregion Atributos

  //#region Construtor(es)
  GooglePlaceServiceProvider(this.sessionToken);
  //#region Construtor(es)

  //#region Métodos

  /// Método responsável por obter as sugestões de endereço do Google com base no termo da busca.
  Future<List<SugestaoEnderecoDmo>> obterSugestoesDeEndereco(String termoDeBusca, String idioma) async {

    // Restringir resultados da busca para o Brasil.
    String paizesDaBusca = 'country:br';

    final uriRequisicao =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$termoDeBusca&types=address&language=$idioma&components=$paizesDaBusca&key=$apiKey&sessiontoken=$sessionToken';

    final resposta = await client.get(Uri.parse(uriRequisicao));

    // Caso a requisição tenha sido concluída com sucesso (status 200)
    if (resposta.statusCode == HttpStatus.ok) {

      // Obter resposta da requisição
      final result = json.decode(resposta.body);

      if (result['status'] == 'OK') {

        // Compor sugestões em uma lista.
        return result['predictions']
            .map<SugestaoEnderecoDmo>((p) => SugestaoEnderecoDmo(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Não foi possível obter as sugestões de endereço.');
    }
  }

  /// Método responsável por obter os detalhes do endereço com base no ID.
  Future<EnderecoDmo> obterDetalhesDoEndereco(String idEndereco) async {

    final uriRequisicao =
        'https://maps.googleapis.com/maps/api/geocode/json?place_id=$idEndereco&key=$apiKey';

    print(Uri.parse(uriRequisicao));

    final resposta = await client.get(Uri.parse(uriRequisicao));

    if (resposta.statusCode == HttpStatus.ok) {

      final result = json.decode(resposta.body);

      if (result['status'] == 'OK') {

        final components =
        result['results'][0]['address_components'] as List<dynamic>;

        // Converter informações obtidas em um objeto EnderecoDmo.
        final endereco = EnderecoDmo();

        endereco.posicao = result['results'][0]['location'] as Position;

        // Segunda forma de obter o endereço caso o campo "Location" não seja fornecido no retorno da requisição.
        if(endereco.posicao == null)
          endereco.posicao = Position(

            longitude: result['results'][0]['geometry']['location']['lng'],
            latitude: result['results'][0]['geometry']['location']['lat'],
            heading: 0, timestamp: DateTime.now(), speedAccuracy: 0, speed: 0, altitude: 0, accuracy: 0
          );

        components.forEach((c) {

          final List type = c['types'];

          if (type.contains('street_number')) {
            endereco.numero = c['long_name'];
          }

          if (type.contains('route')) {
            endereco.logradouro = c['long_name'];
          }

          if(type.contains('sublocality_level_1') || type.contains('sublocality')){
            endereco.bairro = c['long_name'];
          }

          if (type.contains('administrative_area_level_2') || type.contains('locality')) {
            endereco.cidade = c['long_name'];
          }

          if (type.contains('postal_code')) {
            endereco.cep = c['long_name'];
          }
        });
        return endereco;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Falha ao carregar endereço.');
    }
  }

  /// Método responsável por obter os detalhes do endereço com base na localização
  /// atual (longitude e latitude) do usuário.
  Future<EnderecoDmo> obterDetalhesDoEnderecoViaPosition(Position posicaoAtual) async {

    final uriRequisicao =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${posicaoAtual.latitude},${posicaoAtual.longitude}&key=$apiKey';

    final resposta = await client.get(Uri.parse(uriRequisicao));

    if (resposta.statusCode == HttpStatus.ok) {

      final result = json.decode(resposta.body);

      if (result['status'] == 'OK') {

        final components =
        result['results'][0]['address_components'] as List<dynamic>;

        // Converter informações obtidas em um objeto EnderecoDmo.
        final endereco = EnderecoDmo();
        endereco.posicao = posicaoAtual;

        components.forEach((c) {

          final List type = c['types'];

          if (type.contains('street_number')) {
            endereco.numero = c['long_name'];
          }

          if (type.contains('route')) {
            endereco.logradouro = c['long_name'];
          }

          if(type.contains('sublocality_level_1') || type.contains('sublocality')){
            endereco.bairro = c['long_name'];
          }

          if (type.contains('administrative_area_level_2') || type.contains('locality')) {
            endereco.cidade = c['long_name'];
          }

          if (type.contains('postal_code')) {
            endereco.cep = c['long_name'];
          }
        });
        return endereco;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Falha ao carregar endereço.');
    }
  }

  /// Método responsável por obter a localização exata do endereço (longitude e latitude)
  /// com base no endereço fornecido em tela.
  Future<Position> obterPositionAPartirDoEndereco(String endereco) async {

    final uriRequisicao =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$endereco&key=$apiKey';

    final resposta = await client.get(Uri.parse(uriRequisicao));

    if (resposta.statusCode == HttpStatus.ok) {

      final result = json.decode(resposta.body);

      if (result['status'] == 'OK') {

        return result['results'][0]['geometry']['location'] as Position;

      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Falha ao carregar posição do endereço.');
    }
  }
  //#endregion Métodos
}