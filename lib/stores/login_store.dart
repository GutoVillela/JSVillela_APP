import 'package:jsvillela_app/dml/usuario_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/parse_server/usuario_parse.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

/// Classe que contém a Store usada na tela de Login.
abstract class _LoginStore with Store{

  //#region Construtor(es)

  _LoginStore(){
    autorun((_){
      print(processando);
    });
  }
  //#endregion Construtor(es)

  //#region Observables
  ///Atributo observável que define o nome de usuário para login.
  @observable
  String usuario = "";

  ///Atributo observável que define a senha para login.
  @observable
  String senha = "";

  ///Atributo observável que define se usuário irá permanecer logado.
  @observable
  bool lembrarUsuario = false;

  ///Atributo observável que define se classe está processando uma tarefa.
  @observable
  bool processando = false;

  ///Atributo observável que define se a senha será visível na interface.
  @observable
  bool senhaVisivel = false;

  /// Atributo observável que define o estado atual da tela de Login.
  @observable
  EstadoDaPaginaDeLogin estadoDaPagina = EstadoDaPaginaDeLogin.login;

  /// Atributo observável que definea largura máxima total da tela.
  @observable
  double larguraDaTela = 400;

  /// Atributo observável que definea altura máxima total da tela.
  @observable
  double alturaDaTela = 600;

  /// Atributo observável que define se o teclado está visível na tela.
  @observable
  bool tecladoVisivel = false;

  /// Atributo observável que define se ocorreu algum erro durante processo de login.
  @observable
  String? erro;
  //#endregion Observables

  //#region Computed
  /// Atributo observável que define o deslocamento no eixo Y do container de "Login".
  @computed
  double get loginDeslocamentoY{
    if(estadoDaPagina == EstadoDaPaginaDeLogin.inicio)
      return alturaDaTela;

    else if(estadoDaPagina == EstadoDaPaginaDeLogin.login)
      return tecladoVisivel ? 20 : deslocamentoFormsPrimeiroPlano;

    else
      return deslocamentoFormsSegundoPlano;
  }

  /// Atributo observável que define o deslocamento no eixo X do container de "Login".
  @computed
  double get loginDeslocamentoX{
    if(estadoDaPagina == EstadoDaPaginaDeLogin.inicio || estadoDaPagina == EstadoDaPaginaDeLogin.login)
      return 0;
    else
      return 20;
  }

  /// Atributo observável que define a largura do container de "Login".
  @computed
  double get loginLargura{
    if(estadoDaPagina == EstadoDaPaginaDeLogin.inicio || estadoDaPagina == EstadoDaPaginaDeLogin.login)
      return larguraDaTela;

    else
      return larguraDaTela - loginDeslocamentoX * 2;
  }

  /// Atributo observável que define a opacidade do container de "Login".
  @computed
  double get loginOpacidade{
    if(estadoDaPagina == EstadoDaPaginaDeLogin.esqueciASenha)
      return .7;

    else
      return 1;
  }

  /// Atributo observável que define o deslocamento no eixo Y do container de "Esqueci a senha".
  @computed
  double get esqueciASenhaDeslocamentoY{
    if(estadoDaPagina == EstadoDaPaginaDeLogin.inicio || estadoDaPagina == EstadoDaPaginaDeLogin.login)
      return alturaDaTela;

    else
      return tecladoVisivel ? 20 : deslocamentoFormsPrimeiroPlano;
  }

  /// Deslocamento dos formulários quando estão visíveis (em primeiro plano).
  @computed
  double get deslocamentoFormsPrimeiroPlano => alturaDaTela * .3;

  /// Deslocamento dos formulários quando estão visíveis (em segundo plano).
  @computed
  double get deslocamentoFormsSegundoPlano => alturaDaTela * .25;
  //#endregion Computed

  //#region Actions
  ///Action que define o valor do atributo observável "usuario".
  @action
  void setUsuario(String value) => usuario = value;

  ///Action que define o valor do atributo observável "senha".
  @action
  void setSenha(String value) => senha = value;

  ///Action que define o valor do atributo observável "lembrarUsuario".
  @action
  void setLembrarUsuario(bool value) => lembrarUsuario = value;

  ///Inverte o valor do atributo observável "senhaVisivel".
  @action
  void alterarVisibilidadeDaSenha() => senhaVisivel = !senhaVisivel;

  ///Action que define o valor do atributo observável "tecladoVisivel".
  @action
  void setTecladoVisivel(bool value) => tecladoVisivel = value;

  ///Action que define o valor do atributo observável "estadoDaPagina".
  @action
  void setEstadoDaPagina(EstadoDaPaginaDeLogin value) => estadoDaPagina = value;

  ///Action que define o valor do atributo observável "larguraDaTela".
  @action
  void setLarguraDaTela(double value) => larguraDaTela = value;

  ///Action que define o valor do atributo observável "alturaDaTela".
  @action
  void setAlturaDaTela(double value) => alturaDaTela = value;

  /// Action que realiza processo de login do usuário.
  @action
  Future<UsuarioDmo?> logarUsuario() async {

    // Indicar que classe iniciou o processamento.
    processando = true;

    try{
      // Realizar login do usuário
      final usuarioLogado = await UsuarioParse().logarUsuario(usuario, senha);

      // Salvar ID do usuário logado
      Preferencias.idUsuarioLogado = usuarioLogado.id;
      Preferencias.nomeUsuarioLogado = usuarioLogado.usuario;

      // Indicar que classe finalizou o processamento.
      processando = false;

      // Autenticar somente usuários do tipo Recolhedor
      return usuarioLogado.tipoDeUsuario == TipoDeUsuario.recolhedor ? usuarioLogado : null;
    }
    catch (e){
      erro = e.toString();
      // Indicar que classe finalizou o processamento.
      processando = false;
      return null;
    }
  }
  //#endregion Actions
}