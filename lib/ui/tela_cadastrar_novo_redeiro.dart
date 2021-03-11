import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/models/checklist_item_model.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/models/redeiro_model.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/widgets/tela_busca_grupos_de_redeiros.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TelaCadastrarNovoRedeiro extends StatefulWidget {
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

  /// Define se usuário marcou a checkbox "WhatsApp" para este redeiro.
  bool _whatsApp = true;

  /// Model de CheckListItem usado para demarcar os grupos de redeiros selecionados.
  List<GrupoDeRedeirosDmo> gruposDeRedeiros;
  //#endregion Atributos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _chaveScaffold,
      appBar: AppBar(
        title: Text("CADASTRAR NOVO REDEIRO"),
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
                  SizedBox(height: 20,),
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
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _enderecoController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_pin),
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: "Endereço"
                    ),
                    validator: (text){
                      if(text.isEmpty) return "Endereço obrigatório!";
                      return null;

                    },
                  ),
                  SizedBox(height: 20),
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
                          "Cadastrar redeiro",
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: (){

                          if(_formKey.currentState.validate()){

                            // Converter lista de grupos em um mapa
                            var mapaDeGrupos = { for (var v in gruposDeRedeiros) { GrupoDeRedeirosModel.ID_COLECAO : v.idGrupo, GrupoDeRedeirosModel.CAMPO_NOME : v.nomeGrupo } };

                            Map<String, dynamic> dadosDoRedeiro = {
                              RedeiroModel.CAMPO_NOME : _nomeController.text,
                              RedeiroModel.CAMPO_CELULAR : _celularController.text,
                              RedeiroModel.CAMPO_EMAIL : _emailController.text,
                              RedeiroModel.CAMPO_WHATSAPP : _whatsApp,
                              RedeiroModel.CAMPO_ENDERECO : _enderecoController.text,
                              RedeiroModel.CAMPO_ATIVO : true,
                              RedeiroModel.SUBCOLECAO_GRUPOS : mapaDeGrupos.toList()
                            };

                            print(dadosDoRedeiro);

                            model.cadastrarRedeiro(
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
    _chaveScaffold.currentState.showSnackBar(
        SnackBar(
            content: Text("Redeiro Cadastrado com sucesso!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2))
    );

    Navigator.of(context).pop();
  }

  /// Informa usuário que ocorreu uma falha no login.
  void _informarErroDeCadastro(){
    _chaveScaffold.currentState.showSnackBar(
        SnackBar(
            content: Text("Falha ao cadastrar redeiro!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2))
    );
  }

}

