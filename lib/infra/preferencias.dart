import 'package:geolocator/geolocator.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Classe que mantém as preferências do usuário salvas.
class Preferencias{

  //#region Constantes
  /// Constante que define nome da preferência "Manter usuário logado".
  static const String PREF_MANTER_LOGADO = "PREF_MANTER_LOGADO";

  /// Constante que define nome da preferência que guarda a informação do ID do usuário logado.
  static const String PREF_ID_USUARIO_LOGADO = "PREF_ID_USUARIO_LOGADO";

  /// Constante que define nome da preferência que guarda a informação do nome do usuário logado.
  static const String PREF_NOME_USUARIO_LOGADO = "PREF_NOME_USUARIO_LOGADO";

  /// Constante que define nome da preferência que guarda a informação do aplicativo padrão de mapas.
  static const String PREF_APP_MAPAS = "PREF_APP_MAPAS";

  /// Define a quantidade de registros a ser carregado por vez, para Lazy Loading.
  static const int QUANTIDADE_REGISTROS_LAZY_LOADING = 8;
  //#endregion Constantes

  //#region Atributos
  /// Define se usuário optou por manter sessão de login ativa.
  static bool manterUsuarioLogado = false;

  /// Define o ID do usuário logado.
  static String? idUsuarioLogado;

  /// Define o nome do usuário logado.
  static String? nomeUsuarioLogado;

  /// Define o aplicativo de mapa padrão do usuário.
  static AplicativosDeMapa aplicativosDeMapa = AplicativosDeMapa.googleMaps;

  //#endregion Atributos

  //#region Métodos
  /// Método responsável por carregar todas as preferências do usuário.
  Future<void> carregarPreferencias() async{

    final SharedPreferences preferencias = await SharedPreferences.getInstance();

    // Obter preferência "manterUsuarioLogado"
    manterUsuarioLogado = preferencias.getBool(PREF_MANTER_LOGADO) ?? false;

    // Obter preferência "aplicativosDeMapa"
    int? appMapa = preferencias.getInt(PREF_APP_MAPAS);
    aplicativosDeMapa =  appMapa != null ? AplicativosDeMapa.values[appMapa] : AplicativosDeMapa.googleMaps;

    if(manterUsuarioLogado){
      idUsuarioLogado = preferencias.getString(PREF_ID_USUARIO_LOGADO);
      nomeUsuarioLogado = preferencias.getString(PREF_NOME_USUARIO_LOGADO);
    }
  }

  /// Obtém localização atual do dispositivo do usuário
  Future<Position> obterLocalizacaoAtual() async {

    bool servicoAtivado;
    LocationPermission permissao;

    // Checar se serviço de localicação do usuário está ativado.
    servicoAtivado = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivado) {

      // Serviço de localização do usuário não está ativo.
      return Future.error('O serviço de localização está desativado.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.deniedForever) {

        // Permissão de localização está negada permanentemente.
        return Future.error(
            'Serviço de localização está permanentemente negado.');
      }

      if (permissao == LocationPermission.denied) {
        // Permissão de localização negada.
        return Future.error(
            'Serviço de localização negado.');
      }
    }

    // Todas as permissões de localização estão garantidas.
    // Prosseguir obtendo localização do usuário.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  /// Salva um valor na preferência determinada.
  Future<void> salvarPreferencia(PreferenciasDoApp preferencia, dynamic valor) async{

    // Salvar preferência
    final SharedPreferences preferencias = await SharedPreferences.getInstance();

    // Salvar corretamente a preferência
    switch(preferencia){
      case PreferenciasDoApp.manterUsuarioLogado:
        if(valor is bool){
          preferencias.setBool(Preferencias.PREF_MANTER_LOGADO, valor);
          Preferencias.manterUsuarioLogado = valor;
        }
        else{
          throw Exception('O valor precisa ser do tipo boleano para uma preferência do tipo PreferenciasDoApp.manterUsuarioLogado');
        }

        break;

      // Preferência de Aplicativo de mapa
      case PreferenciasDoApp.appPadraoMapas:
        if(valor is AplicativosDeMapa){
          preferencias.setInt(Preferencias.PREF_APP_MAPAS, (valor).index);
          Preferencias.aplicativosDeMapa = valor;
        }
        else{
          throw Exception('O valor precisa ser do tipo enum AplicativosDeMapa para uma preferência do tipo PreferenciasDoApp.appPadraoMapas.');
        }

        break;

    }
  }

  /// Salva o usuário logado.
  Future<void> salvarUsuarioLogado(String usuario, String idUsuario) async{

    // Salvar preferência
    final SharedPreferences preferencias = await SharedPreferences.getInstance();

    // Salvar corretamente a preferência
    preferencias.setString(Preferencias.PREF_NOME_USUARIO_LOGADO, usuario);
    Preferencias.nomeUsuarioLogado = usuario;
    preferencias.setString(Preferencias.PREF_ID_USUARIO_LOGADO, idUsuario);
    Preferencias.idUsuarioLogado = usuario;
  }
  //#endregion Métodos

}