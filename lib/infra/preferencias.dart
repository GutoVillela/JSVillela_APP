import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Classe que mantém as preferências do usuário salvas.
class Preferencias{

  //#region Constantes
  /// Constante que define nome da preferência "Manter usuário logado".
  static const String PREF_MANTER_LOGADO = "PREF_MANTER_LOGADO";

  /// Constante que define nome da preferência que guarda a informação do usuário logado.
  static const String PREF_USUARIO_LOGADO = "PREF_USUARIO_LOGADO";

  /// Define a quantidade de registros a ser carregado por vez, para Lazy Loading.
  static const int QUANTIDADE_REGISTROS_LAZY_LOADING = 8;
  //#endregion Constantes

  //#region Atributos
  /// Define se usuário optou por manter sessão de login ativa.
  static bool manterUsuarioLogado;

  /// Define o ID do usuário logado.
  static String idUsuarioLogado;

  //#endregion Atributos

  //#region Métodos
  /// Método responsável por carregar todas as preferências do usuário.
  void carregarPreferencias() async{

    final SharedPreferences preferencias = await SharedPreferences.getInstance();

    manterUsuarioLogado = preferencias.getBool(PREF_MANTER_LOGADO) ?? false;

    if(manterUsuarioLogado)
      idUsuarioLogado = preferencias.getString(PREF_USUARIO_LOGADO);

    print(manterUsuarioLogado);
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
  //#endregion Métodos

}