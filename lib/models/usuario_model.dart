import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model para usuários.
class UsuarioModel extends Model{

  //#region Atributos
  /// Objeto de autenticação do Firebase.
  FirebaseAuth _autenticacao = FirebaseAuth.instance;

  /// Usuário autenticado com Firebase.
  User usuario;

  /// Mapa contendo informações do usuário logado.
  Map<String, dynamic> dadosDoUsuario;

  /// Indica que existe um processo em execução a partir desta classe.
  bool estaCarregando = false;
  //#endregion Atributos

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

  Future<Null> _carregarUsuarioAtual() async{
    if(usuario == null)
      usuario = _autenticacao.currentUser;

    /*if(usuario != null){
      if(dadosDoUsuario["name"] == null){
        DocumentSnapshot docUser = await FirebaseFirestore.instance.collection("users").doc(usuario.uid).get();
        dadosDoUsuario = docUser.data();
      }
    }*/
    notifyListeners();
  }
  //#endregion Métodos

}