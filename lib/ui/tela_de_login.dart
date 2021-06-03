import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/paleta_de_cores.dart';
import 'package:jsvillela_app/stores/login_store.dart';
import 'package:jsvillela_app/ui/tela_principal.dart';
import 'package:jsvillela_app/ui/widgets/botao_arredondado.dart';
import 'package:jsvillela_app/ui/widgets/botao_redondo.dart';
import 'package:jsvillela_app/ui/widgets/botao_sem_preenchimento.dart';
import 'package:jsvillela_app/ui/widgets/campo_de_texto_com_icone.dart';
import 'package:provider/provider.dart';
import 'package:jsvillela_app/infra/preferencias.dart';

class TelaDeLogin extends StatefulWidget {
  @override
  _TelaDeLoginState createState() => _TelaDeLoginState();
}

class _TelaDeLoginState extends State<TelaDeLogin> {

  //#region Atributos
  /// Login store utilizado para manipular a tela de login.
  late LoginStore _loginStore = LoginStore();

  /// Controller utilizado no campo de texto de Usuário.
  final _usuarioController = TextEditingController();

  /// Controller utilizado no campo de texto de senha.
  final _senhaController = TextEditingController();

  /// Global key utilizado para validação do formulário de login.
  final _chaveFormulario = GlobalKey<FormState>();

  /// Define se existe um usuário logado.
  String? usuarioLogado;

  /// Controller que auxiliar a informar quando o teclado estiver visível ou não
  var keyboardVisibilityController = KeyboardVisibilityController();
  //#endregion Atributos

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Inicializar login store
    _loginStore = Provider.of<LoginStore>(context);
  }

  @override
  void initState() {
    super.initState();

    // Informar quando o teclado estiver visível ou não
    keyboardVisibilityController.onChange.listen((bool visible) {
      _loginStore.setTecladoVisivel(visible);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: LayoutBuilder(
          builder: (context, constraints) {

            // Obter largura e altura da tela.
            _loginStore.setLarguraDaTela(constraints.maxWidth);
            _loginStore.setAlturaDaTela(constraints.maxHeight);

            return Stack(
              children: [
                Observer(
                  builder: (_){
                    return AnimatedContainer(
                        height: _loginStore.alturaDaTela * .3,
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
                    );
                  },
                ),
                GestureDetector(
                  onTap: (){
                    if(_loginStore.estadoDaPagina != EstadoDaPaginaDeLogin.login)
                      _loginStore.setEstadoDaPagina(EstadoDaPaginaDeLogin.login);
                  },
                  child: Observer(
                    builder: (_){

                      return AnimatedContainer(
                        height: _loginStore.alturaDaTela,
                        width: _loginStore.larguraDaTela,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: Duration(
                            milliseconds: 1000
                        ),
                        transform: Matrix4.translationValues(_loginStore.loginDeslocamentoX, _loginStore.loginDeslocamentoY, 0),
                        decoration: BoxDecoration(
                            color: PaletaDeCor.AZUL_BEM_CLARO.withOpacity(_loginStore.loginOpacidade),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)
                            )
                        ),
                        child: SingleChildScrollView(
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
                              Form(
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
                                                  if(texto!.isEmpty)
                                                    return "Este campo é obrigatório";
                                                  return null;
                                                },
                                                onChanged: _loginStore.setUsuario,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 32),
                                              child: Observer(
                                                builder: (_){
                                                  return CampoDeTextoComIcone(
                                                    texto: "Senha",
                                                    icone: Icon(Icons.lock, color: PaletaDeCor.AZUL_ESCURO),
                                                    cor: PaletaDeCor.AZUL_ESCURO,
                                                    campoDeSenha: !_loginStore.senhaVisivel,
                                                    controller: _senhaController,
                                                    regraDeValidacao: (texto){
                                                      if(texto!.isEmpty)
                                                        return "Este campo é obrigatório";
                                                      return null;
                                                    },
                                                    onChanged: _loginStore.setSenha,
                                                    sufixo: BotaoRedondo(
                                                      icone: _loginStore.senhaVisivel ? Icons.visibility_off : Icons.visibility,
                                                      corDoBotao: Colors.transparent,
                                                      corDoIcone: Theme.of(context).primaryColor,
                                                      acaoAoClicar: _loginStore.alterarVisibilidadeDaSenha,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 32),
                                              child: Observer(
                                                builder: (_){
                                                  return CheckboxListTile(
                                                    title: Text("Lembrar de mim"),
                                                    //secondary: Icon(Icons.),
                                                    value: _loginStore.lembrarUsuario,
                                                    onChanged: (bool? value) => _loginStore.setLembrarUsuario(value ?? false),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Observer(builder: (_){
                                        return Container(
                                          padding: EdgeInsets.all(32),
                                          child: Column(
                                            children: [
                                              !_loginStore.processando ?
                                              GestureDetector(
                                                  onTap: () async{
                                                    if(_chaveFormulario.currentState!.validate()){
                                                      if(await _loginStore.logarUsuario())
                                                        _logarUsuario();
                                                      else
                                                        Infraestrutura.mostrarMensagemDeErro(context, _loginStore.erro ?? "Falha ao entrar!");
                                                    }
                                                  },
                                                  child:  BotaoArredondado(
                                                      textoDoBotao: "ENTRAR"
                                                  )
                                              )
                                                  : CircularProgressIndicator(),
                                              SizedBox(height: 10),
                                              GestureDetector(
                                                  onTap: (){
                                                    FocusScope.of(context).unfocus();// Remover foco do campo atual
                                                    _loginStore.setEstadoDaPagina(EstadoDaPaginaDeLogin.esqueciASenha);
                                                  },
                                                  child: BotaoSemPreenchimento(
                                                      textoDoBotao:"ESQUECI A SENHA"
                                                  )
                                              ),
                                              SizedBox(height: 10)
                                            ],
                                          ),
                                        );
                                      })
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Observer(
                  builder: (_){
                    return AnimatedContainer(
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: Duration(
                          milliseconds: 1000
                      ),
                      transform: Matrix4.translationValues(0, _loginStore.esqueciASenhaDeslocamentoY, 0),
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
                                  _loginStore.setEstadoDaPagina(EstadoDaPaginaDeLogin.login);
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
                                  FocusScope.of(context).unfocus();// Remover foco do campo atual
                                  _loginStore.setEstadoDaPagina(EstadoDaPaginaDeLogin.login);
                                },
                                child: BotaoSemPreenchimento(
                                    textoDoBotao:"VOLTAR"
                                )
                            ),
                          )
                        ],
                      ),
                    );
                  },
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

    // Salvar preferência de "Manter Logado"
    await Preferencias().salvarPreferencia(PreferenciasDoApp.manterUsuarioLogado, _loginStore.lembrarUsuario);

    // Salvar Usuário Logado
    await Preferencias().salvarUsuarioLogado(_loginStore.usuario);
    
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => TelaPrincipal())
    );
  }

  /// Informa usuário que ocorreu uma falha no login.
  void _informarErroDeLogin(){
    Infraestrutura.mostrarMensagemDeErro(context, "Falha ao entrar!");
  }

}