import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/models/usuario_model.dart';
import 'package:jsvillela_app/ui/tela_principal.dart';
import 'package:jsvillela_app/ui/widgets/botao_arredondado.dart';
import 'package:jsvillela_app/ui/widgets/botao_sem_preenchimento.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jsvillela_app/infra/preferencias.dart';

class TelaDeLogin extends StatefulWidget {
  @override
  _TelaDeLoginState createState() => _TelaDeLoginState();
}

class _TelaDeLoginState extends State<TelaDeLogin> {

  //#region Atributos
  /// Estado atual da página.
  EstadoDaPaginaDeLogin _estadoDaPagina = EstadoDaPaginaDeLogin.inicio;

  /// Largura da tela.
  double larguraDaTela = 0;

  /// Altura da tela.
  double alturaDaTela = 0;

  /// Deslocamento (offset) no eixo Y do container do formulário de login.
  double _loginDeslocamentoY = 0;

  /// Deslocamento (offset) no eixo X do container do formulário de login.
  double _loginDeslocamentoX = 0;

  /// Largura do container do formulário de login.
  double _loginLargura = 0;

  /// Opacidade do container do formulário de login.
  double _loginOpacidade = 1;

  /// Deslocamento (offset) no eixo Y do container do formulário de esqueci a senha.
  double _esqueciASenhaDeslocamentoY = 0;

  /// Define se o teclado está visível ou não.
  bool _tecladoVisivel = false;

  /// Controller utilizado no campo de texto de Usuário.
  final _usuarioController = TextEditingController();

  /// Controller utilizado no campo de texto de senha.
  final _senhaController = TextEditingController();

  /// Global key utilizado para validação do formulário de login.
  final _chaveFormulario = GlobalKey<FormState>();

  /// Chave de Scaffold.
  final _chaveScaffold = GlobalKey<ScaffoldState>();

  /// Define se usuário marcou a checkbox "Lembrar de mim".
  bool _lembrarDeMim = true;

  /// Define se existe um usuário logado.
  String usuarioLogado;
  //#endregion Atributos

  @override
  void initState() {
    super.initState();

    // Informar quando o teclado estiver visível ou não
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _tecladoVisivel = visible;
        });
      },
    );

    setState(() {
      _estadoDaPagina = EstadoDaPaginaDeLogin.login;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _chaveScaffold,
      body: Container(
        child: LayoutBuilder(
          builder: (context, constraints) {

            // Obter largura e altura da tela.
            larguraDaTela = constraints.maxWidth;
            alturaDaTela = constraints.maxHeight;

            // Deslocamento dos formulários quando estão visíveis (em primeiro plano).
            double deslocamentoFormsPrimeiroPlano = alturaDaTela * .3;

            // Deslocamento dos formulários quando estão visíveis (em segundo plano).
            double deslocamentoFormsSegundoPlano = alturaDaTela * .25;

            // Definir cor de fundo da página atual segundo estado atual da página
            switch(_estadoDaPagina){
              case EstadoDaPaginaDeLogin.inicio:
                _loginDeslocamentoY = alturaDaTela;
                _loginDeslocamentoX = 0;
                _loginLargura = larguraDaTela;
                _loginOpacidade = 1;

                _esqueciASenhaDeslocamentoY = alturaDaTela;
                break;
              case EstadoDaPaginaDeLogin.login:
                _loginDeslocamentoY = _tecladoVisivel ? 20 : deslocamentoFormsPrimeiroPlano;
                _loginDeslocamentoX = 0;
                _loginLargura = larguraDaTela;
                _loginOpacidade = 1;

                _esqueciASenhaDeslocamentoY = alturaDaTela;
                break;
              case EstadoDaPaginaDeLogin.esqueciASenha:
                _loginDeslocamentoY = deslocamentoFormsSegundoPlano;
                _loginDeslocamentoX = 20;
                _loginLargura = larguraDaTela - _loginDeslocamentoX * 2;
                _loginOpacidade = .7;

                _esqueciASenhaDeslocamentoY = _tecladoVisivel ? 20 : deslocamentoFormsPrimeiroPlano;
                break;
            }

            return Stack(
              children: [
                AnimatedContainer(
                  height: alturaDaTela * .3,
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(
                      milliseconds: 800
                  ),
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(50),
                    child: Center(
                        child: Image.asset("assets/imagens/logo_js_villela.png", fit: BoxFit.fill)
                    ),
                  )
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      if(_estadoDaPagina != EstadoDaPaginaDeLogin.login)
                        _estadoDaPagina = EstadoDaPaginaDeLogin.login;
                    });
                  },
                  child: AnimatedContainer(
                    height: alturaDaTela,
                    width: _loginLargura,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: Duration(
                        milliseconds: 1000
                    ),
                    transform: Matrix4.translationValues(_loginDeslocamentoX, _loginDeslocamentoY, 0),
                    decoration: BoxDecoration(
                        color: PaletaDeCor.ROXO_CLARO.withOpacity(_loginOpacidade),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)
                        )
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                              child: Text(
                                "Entre para continuar",
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              )
                          ),
                        ),
                        ScopedModelDescendant<UsuarioModel>(
                            builder: (context, child, model){
                              if(model.estaCarregando)
                                return Center(child: CircularProgressIndicator());

                              return Form(
                                  key: _chaveFormulario,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(32),
                                              child: CampoDeTextoComIcone(
                                                texto: "Usuário ou código",
                                                icone: Icon(Icons.person, color: PaletaDeCor.AZUL_ESCURO),
                                                cor: PaletaDeCor.AZUL_ESCURO,
                                                campoDeSenha: false,
                                                controller: _usuarioController,
                                                regraDeValidacao: (texto){
                                                  if(texto.isEmpty)
                                                    return "Este campo é obrigatório";
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 32),
                                              child: CampoDeTextoComIcone(
                                                texto: "Senha",
                                                icone: Icon(Icons.lock, color: PaletaDeCor.AZUL_ESCURO),
                                                cor: PaletaDeCor.AZUL_ESCURO,
                                                campoDeSenha: true,
                                                controller: _senhaController,
                                                regraDeValidacao: (texto){
                                                  if(texto.isEmpty)
                                                    return "Este campo é obrigatório";
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 32),
                                              child: CheckboxListTile(
                                                title: Text("Lembrar de mim"),
                                                //secondary: Icon(Icons.),
                                                value: _lembrarDeMim,
                                                onChanged: (bool valor){
                                                  setState(() {
                                                    _lembrarDeMim = valor;
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(32),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                                onTap: (){
                                                  if(_chaveFormulario.currentState.validate()){
                                                    model.logar(
                                                        email: _usuarioController.text,
                                                        senha: _senhaController.text,
                                                        onSuccess: _logarUsuario,
                                                        onFail: _informarErroDeLogin
                                                    );
                                                  }
                                                },
                                                child: BotaoArredondado(
                                                    textoDoBotao: "ENTRAR"
                                                )
                                            ),
                                            SizedBox(height: 10),
                                            GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    FocusScope.of(context).unfocus();// Remover foco do campo atual
                                                    _estadoDaPagina = EstadoDaPaginaDeLogin.esqueciASenha;
                                                  });
                                                },
                                                child: BotaoSemPreenchimento(
                                                    textoDoBotao:"ESQUECI A SENHA"
                                                )
                                            ),
                                            SizedBox(height: 10)
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              );
                            }
                        )
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(
                      milliseconds: 1000
                  ),
                  transform: Matrix4.translationValues(0, _esqueciASenhaDeslocamentoY, 0),
                  decoration: BoxDecoration(
                      color: PaletaDeCor.ROXO_CLARO,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)
                      )
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                            child: Text(
                              "Recuperar senha",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(32),
                        child: CampoDeTextoComIcone(
                            texto: "Usuário ou código",
                            icone: Icon(Icons.person, color: PaletaDeCor.AZUL_ESCURO),
                            campoDeSenha: false,
                            cor: PaletaDeCor.AZUL_ESCURO
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(32),
                        child: GestureDetector(
                            onTap: (){
                              setState(() {
                                _estadoDaPagina = EstadoDaPaginaDeLogin.login;
                              });
                            },
                            child: BotaoArredondado(
                                textoDoBotao: "RECUPERAR SENHA"
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: GestureDetector(
                            onTap: (){
                              setState(() {
                                FocusScope.of(context).unfocus();// Remover foco do campo atual
                                _estadoDaPagina = EstadoDaPaginaDeLogin.login;
                              });
                            },
                            child: BotaoSemPreenchimento(
                                textoDoBotao:"VOLTAR"
                            )
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }

  /// É chamado após o usuário ser autenticado com sucesso. Chama a tela principal.
  void _logarUsuario() async{
    _chaveScaffold.currentState.showSnackBar(
        SnackBar(
            content: Text("Login efetuado com sucesso!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2))
    );

    // Salvar preferência de "Manter Logado"
    final SharedPreferences preferencias = await SharedPreferences.getInstance();
    preferencias.setBool(Preferencias.PREF_MANTER_LOGADO, _lembrarDeMim);
    Preferencias.manterUsuarioLogado = _lembrarDeMim;
    
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => TelaPrincipal())
    );
  }

  /// Informa usuário que ocorreu uma falha no login.
  void _informarErroDeLogin(){
    _chaveScaffold.currentState.showSnackBar(
        SnackBar(
            content: Text("Falha ao entrar!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2))
    );
  }

}

/// Enum que define os possíveis estados para esta página de login.
enum EstadoDaPaginaDeLogin{
  inicio,
  login,
  esqueciASenha
}