import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/endereco_dmo.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/sugestao_endereco_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/services/google_place_service.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/widgets/tela_busca_endereco.dart';
import 'package:jsvillela_app/ui/widgets/tela_busca_grupos_de_redeiros.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';

class TelaCadastrarNovoRedeiro extends StatefulWidget {

  //#region Atributos

  /// Tipo de manutenção desta tela (inclusão ou alteração)
  final TipoDeManutencao tipoDeManutencao;

  /// Redeiro a ser editado.
  final RedeiroDmo redeiroASerEditado;

  //#endregion Atributos

  //#region Construtor(es)
  TelaCadastrarNovoRedeiro({@required this.tipoDeManutencao, this.redeiroASerEditado});
  //#endregion Construtor(es)

  @override
  _TelaCadastrarNovoRedeiroState createState() => _TelaCadastrarNovoRedeiroState();
}

class _TelaCadastrarNovoRedeiroState extends State<TelaCadastrarNovoRedeiro> {

  //#region Atributos
  /// Chave global para o formulário de cadastro.
  final _formKey = GlobalKey<FormState>();

  /// Chave de Scaffold.
  final _chaveScaffold = GlobalKey<ScaffoldState>();

  ///Controller utilizado no campo de texto "Nome".
  final _nomeController = TextEditingController();

  ///Controller utilizado no campo de texto "Email".
  final _emailController = TextEditingController();

  ///Controller utilizado no campo de texto "Celular".
  final _celularController = TextEditingController();

  ///Controller utilizado no campo de texto "Endereço".
  final _enderecoController = TextEditingController();

///Controller utilizado no campo de texto "Complemento".
  final _complementoController = TextEditingController();

  /// Define se usuário marcou a checkbox "WhatsApp" para este redeiro.
  bool _whatsApp = true;

  /// Lista com os grupos de redeiros selecionados.
  List<GrupoDeRedeirosDmo> gruposDeRedeiros;

  /// Define o endereço formatado digitado em tela pelo usuário.
  EnderecoDmo _enderecoDoRedeiro;

  /// Indica se a interface está carregando o endereço com base na localização atual do usuário.
  bool _carregandoEndereco = false;
  //#endregion Atributos

  @override
  void initState() {
    super.initState();

    if(widget.tipoDeManutencao == TipoDeManutencao.alteracao)
      setState(() {
        _nomeController.text = widget.redeiroASerEditado.nome;
        _emailController.text = widget.redeiroASerEditado.email;
        _celularController.text = widget.redeiroASerEditado.celular;
        _whatsApp = widget.redeiroASerEditado.whatsApp;
        _enderecoController.text = widget.redeiroASerEditado.endereco.toString();
        _enderecoDoRedeiro = widget.redeiroASerEditado.endereco;
        _complementoController.text = widget.redeiroASerEditado.endereco.complemento;
        gruposDeRedeiros = widget.redeiroASerEditado.gruposDoRedeiro;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _chaveScaffold,
      appBar: AppBar(
        title: Text(widget.tipoDeManutencao == TipoDeManutencao.cadastro ? "CADASTRAR NOVO REDEIRO" : "EDITAR REDEIRO"),
        centerTitle: true
      ),
      body: ScopedModel<RedeiroModel>(
        model: RedeiroModel(),
        child: ScopedModelDescendant<RedeiroModel>(
          builder: (context, child, model){


            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: "Nome"
                    ),
                    validator: (text){
                      if(text.isEmpty ) return "Nome obrigatório!";
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: "E-mail"
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    inputFormatters: [MaskTextInputFormatter(
                      mask: '(##) #####-####'
                    )],
                    controller: _celularController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone_android),
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: "Celular"
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (text){
                      if(text.isEmpty) return "Celular obrigatório!";
                      return null;
                    },
                  ),
                  CheckboxListTile(
                    title: Text("WhatsApp"),
                    secondary: Icon(Icons.chat),
                    value: _whatsApp,
                    onChanged: (bool valor){
                      setState(() {
                        _whatsApp = valor;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                        controller: _enderecoController,
                        readOnly: true,
                        onTap: () async{

                          // Gerar novo Token para esta sessão.
                          final sessionToken = Uuid().v4();

                          final SugestaoEnderecoDmo sugestao =  await showSearch(
                              context: context, query: _enderecoController.text,
                              delegate: TelaBuscaEndereco(sessionToken)
                          );

                          // Alterar texto exibido no campo de texto
                          if(sugestao != null){
                            final detalhesDoEndereco = await GooglePlaceServiceProvider(sessionToken)
                                .obterDetalhesDoEndereco(sugestao.idDoEndereco);

                            _enderecoController.text = detalhesDoEndereco.toString();
                            _enderecoDoRedeiro = detalhesDoEndereco;
                          }

                        },
                        decoration: InputDecoration(
                            prefixIcon: _carregandoEndereco ?
                            CupertinoActivityIndicator() :
                            Icon(Icons.location_pin),
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: "Endereço",
                        ),
                        validator: (text){
                          if(text.isEmpty) return "Endereço obrigatório!";
                          return null;

                        },
                      ),
                        flex: 6,
                      ),
                      Flexible(
                        child: IconButton(
                            tooltip: "Usar localização atual",
                            color: Theme.of(context).primaryColor,
                            icon: Icon(Icons.my_location),
                            onPressed: () async {
                              setState(() => _carregandoEndereco = true);

                              // Gerar novo Token para esta sessão.
                              final sessionToken = Uuid().v4();

                              //Obter localização atual do usuário
                              final localizacao = await Preferencias().obterLocalizacaoAtual();

                              // Caso tenha retornado uma localização válida
                              if(localizacao != null){
                                try{
                                  final detalhesDoEndereco = await GooglePlaceServiceProvider(sessionToken)
                                      .obterDetalhesDoEnderecoViaPosition(localizacao);

                                  _enderecoController.text = detalhesDoEndereco.toString();
                                  _enderecoDoRedeiro = detalhesDoEndereco;
                                }
                                catch (ex){
                                  // Exibir mensagem de erro em caso de falha.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Não foi possível obter o endereço via localização."),
                                          backgroundColor: Colors.redAccent,
                                          duration: Duration(seconds: 2))
                                  );
                                }
                              }

                              setState(() => _carregandoEndereco = false);
                            }
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _complementoController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.pin_drop_outlined),
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: "Complemento"
                    ),
                    validator: (text){
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  ListViewItemPesquisa(
                    textoPrincipal: "Grupo do Redeiro",
                    textoSecundario: gruposDeRedeiros == null || gruposDeRedeiros.isEmpty ?
                    "Nenhum grupo selecionado" :
                    gruposDeRedeiros.first.nomeGrupo +
                        (gruposDeRedeiros.length - 1 == 0 ? "" : " e mais ${gruposDeRedeiros.length - 1}."),
                    iconeEsquerda: Icons.people_sharp,
                    iconeDireita: Icons.arrow_forward_ios_sharp,
                    acaoAoClicar: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                            return TelaBuscaGruposDeRedeiros(gruposJaSelecionados: gruposDeRedeiros);
                        }
                      ).then((gruposSelecionados) {
                        setState(() {
                          if(gruposSelecionados != null)
                            gruposDeRedeiros = gruposSelecionados;
                        });
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    child: RaisedButton(
                        child: Text(
                          widget.tipoDeManutencao == TipoDeManutencao.cadastro ? "Cadastrar redeiro" : "Editar redeiro",
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: (){

                          if(_formKey.currentState.validate() && validarGruposDeRedeiros(context)){

                            _enderecoDoRedeiro.complemento = _complementoController.text;

                            RedeiroDmo dadosDoRedeiro = RedeiroDmo(
                              id: widget.redeiroASerEditado == null ? null : widget.redeiroASerEditado.id,
                              nome: _nomeController.text,
                              celular: _celularController.text,
                              email: _emailController.text,
                              whatsApp: _whatsApp,
                              endereco: _enderecoDoRedeiro,
                              ativo: widget.redeiroASerEditado == null ? true : (widget.redeiroASerEditado.ativo ?? true),
                              gruposDoRedeiro: gruposDeRedeiros
                            );

                            if((widget.tipoDeManutencao ?? TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro)
                              model.cadastrarRedeiro(
                                  dadosDoRedeiro: dadosDoRedeiro,
                                  onSuccess: _finalizarCadastroDoRedeiro,
                                  onFail: _informarErroDeCadastro);
                            else
                              model.atualizarRedeiro(
                                dadosDoRedeiro: dadosDoRedeiro,
                                onSuccess: _finalizarCadastroDoRedeiro,
                                onFail: _informarErroDeCadastro);
                          }
                        }
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// É chamado após o cadastro do Redeiro ser efetuado com sucesso.
  void _finalizarCadastroDoRedeiro(){
    String mensagem = (widget.tipoDeManutencao??TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro
        ? "Redeiro Cadastrado com sucesso!" : "Redeiro editado com sucesso!";
    Infraestrutura.mostrarMensagemDeSucesso(context, mensagem);
    Navigator.of(context).pop();
  }

  /// Informa usuário que ocorreu uma falha no login.
  void _informarErroDeCadastro(){
    String mensagem = (widget.tipoDeManutencao??TipoDeManutencao.cadastro) == TipoDeManutencao.cadastro
        ? "Falha ao cadastrar redeiro!" : "Falha ao editar redeiro!";
    Infraestrutura.mostrarMensagemDeErro(context, mensagem);
  }

  bool validarGruposDeRedeiros(BuildContext context){
    if(gruposDeRedeiros != null && gruposDeRedeiros.isNotEmpty){
      return true;
    }

    Infraestrutura.mostrarMensagemDeErro(context, "Escolha pelo menos um grupo para o redeiro.");
    return false;
  }



}

