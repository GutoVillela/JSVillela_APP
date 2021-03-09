import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Model para usuários.
class UsuarioModel extends Model{

  //#region Atributos
  /// Objeto de autenticação do Firebase.
  FirebaseAuth _autenticacao = FirebaseAuth.instance;

  /// Usuário autenticado com Firebase.
  User usuario;

  /// Mapa contendo informações do usuário logado.
  Map<String, dynamic> dadosDoUsuario = Map();

  /// Indica que existe um processo em execução a partir desta classe.
  bool estaCarregando = false;
  //#endregion Atributos

  //#region Constantes
  /// Nome do identificador para a coleção "usuarios" utilizado no Firebase.
  static const String NOME_COLECAO = "usuarios";

  /// Nome do identificador para o campo "nome" utilizado na collection do Firebase.
  static const String CAMPO_NOME = "nome";

  /// Nome do identificador para o campo "ativo" utilizado na collection do Firebase.
  static const String CAMPO_ATIVO = "ativo";
  //#endregion Constantes

  //#region Métodos
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _carregarUsuarioAtual();
  }

  /// Autentica o usuário no Firebase com base no [email] e [senha] informados.
  ///
  /// Caso a autenticação seja efetuada com sucesso o CallBack [onSuccess] é chamado.
  /// Caso a autenticação falhe o CallBack [onFail] é chamado.
   void logar({@required String email, @required String senha, @required VoidCallback onSuccess, @required VoidCallback onFail}) async {
     estaCarregando = true;
    notifyListeners();

    // Realizar login no Firebase
    _autenticacao.signInWithEmailAndPassword(email: email, password: senha).then(
      (user) async {
        usuario = user.user;

        await _carregarUsuarioAtual();

        onSuccess();
        estaCarregando = false;
        notifyListeners();

    }).catchError((e){
      onFail();
      print(e.toString());
      estaCarregando = false;
      notifyListeners();
    });
  }

  ///Carrega as informações do usuário atual a partir do login.
  Future<bool> _carregarUsuarioAtual() async{
    if(usuario == null)
      usuario = _autenticacao.currentUser;

    if(usuario != null){
      if(dadosDoUsuario[CAMPO_NOME] == null){
        DocumentSnapshot docUser = await FirebaseFirestore.instance.collection(NOME_COLECAO).doc(usuario.uid).get();
        dadosDoUsuario = docUser.data();
      }

      final SharedPreferences preferencias = await SharedPreferences.getInstance();

      // Salvar ID do Usuário caso preferência "Manter Usuário Logado" tenha sido selecionada.
      if(Preferencias.manterUsuarioLogado)
        preferencias.setString(Preferencias.PREF_USUARIO_LOGADO, usuario.uid);
      // Senão, remover ID salvo
      else
        preferencias.setString(Preferencias.PREF_USUARIO_LOGADO, "");


    }
    notifyListeners();
  }

  ///Carrega as informações do usuário atual a partir das informações de login salvas na preferência.
  Future<bool> autoLogarUsuario() async{

    // Conferir preferências do usuário para então realizar login
    if(Preferencias.manterUsuarioLogado && Preferencias.idUsuarioLogado != null && Preferencias.idUsuarioLogado.isNotEmpty){
      DocumentSnapshot docUser = await FirebaseFirestore.instance.collection(NOME_COLECAO).doc(Preferencias.idUsuarioLogado).get();
      dadosDoUsuario = docUser.data();
      return Future<bool>.value(true);
    }

    notifyListeners();
    return Future<bool>.value(false);

  }

  /// Desloga usuário.
  void deslogarUsuario() async {
    dadosDoUsuario = null;

    // Salvar preferência de "Manter Logado" como false após processo de logout
    final SharedPreferences preferencias = await SharedPreferences.getInstance();
    preferencias.setBool(Preferencias.PREF_MANTER_LOGADO, false);
    Preferencias.manterUsuarioLogado = false;

  }
  //#endregion Métodos

}