import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/dml/sugestao_endereco_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/infra/preferencias.dart';
import 'package:jsvillela_app/services/google_place_service.dart';
import 'package:jsvillela_app/stores/cadastrar_redeiro_store.dart';
import 'package:jsvillela_app/ui/widgets/list_view_item_pesquisa.dart';
import 'package:jsvillela_app/ui/widgets/tela_busca_endereco.dart';
import 'package:jsvillela_app/ui/widgets/tela_busca_grupos_de_redeiros.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'package:jsvillela_app/dml/redeiro_dmo.dart';

class TelaCadastrarNovoRedeiro extends StatefulWidget {

  //#region Atributos

  /// Store que guarda os estados e atributos da tela.
  late final CadastrarRedeiroStore store;

  //#endregion Atributos

  //#region Construtor(es)
  TelaCadastrarNovoRedeiro({required TipoDeManutencao tipoDeManutencao, RedeiroDmo? redeiroASerEditado}){
    store =  CadastrarRedeiroStore(tipoDeManutencao: tipoDeManutencao, redeiroASerEditado: redeiroASerEditado);
    // Em caso de edição, iniciar valores
    if(tipoDeManutencao == TipoDeManutencao.alteracao && redeiroASerEditado != null){
      store.nomeRedeiro = redeiroASerEditado.nome;
      store.emailRedeiro = redeiroASerEditado.email ?? "";
      store.celularRedeiro = redeiroASerEditado.celular ?? "";
      store.whatsapp = redeiroASerEditado.whatsApp;
      store.endereco = redeiroASerEditado.endereco;
      store.gruposDeRedeiros = ObservableList.of(redeiroASerEditado.gruposDoRedeiro);
    }
  }
  //#endregion Construtor(es)

  @override
  _TelaCadastrarNovoRedeiroState createState() =>
      _TelaCadastrarNovoRedeiroState();
}

class _TelaCadastrarNovoRedeiroState extends State<TelaCadastrarNovoRedeiro> {
  //#region Atributos
  /// Chave global para o formulário de cadastro.
  final _formKey = GlobalKey<FormState>();

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
  //#endregion Atributos

  @override
  void initState() {
    super.initState();

    // Em caso de edição, iniciar valores
    if(widget.store.tipoDeManutencao == TipoDeManutencao.alteracao){
      _nomeController.text = widget.store.nomeRedeiro;
      _emailController.text = widget.store.emailRedeiro;
      _celularController.text = widget.store.celularRedeiro;
      _enderecoController.text =
          widget.store.endereco.toString();
      _complementoController.text =
          widget.store.endereco.complemento ?? "";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.store.tipoDeManutencao == TipoDeManutencao.cadastro
              ? "CADASTRAR NOVO REDEIRO"
              : "EDITAR REDEIRO"),
          centerTitle: true),
      body: Form(
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
                  hintText: "Nome"),
              validator: (text) {
                if (text!.isEmpty) return "Nome obrigatório!";
                return null;
              },
              onChanged: widget.store.setNomeRedeiro
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  isDense: true,
                  border: OutlineInputBorder(),
                  hintText: "E-mail"),
              keyboardType: TextInputType.emailAddress,
              onChanged: widget.store.setEmailRedeiro
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TelefoneInputFormatter()
              ],
              controller: _celularController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_android),
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  isDense: true,
                  border: OutlineInputBorder(),
                  hintText: "Celular"),
              keyboardType: TextInputType.phone,
              validator: (text) {
                if (text!.isEmpty) return "Celular obrigatório!";
                return null;
              },
              onChanged: widget.store.setCelularRedeiro
            ),
            Observer(
              builder: (_){
                return CheckboxListTile(
                  title: Text("WhatsApp"),
                  secondary: Icon(Icons.chat),
                  value: widget.store.whatsapp,
                  onChanged: widget.store.setWhatsapp,
                );
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _enderecoController,
                    readOnly: true,
                    onTap: () async {

                      // Gerar novo Token para esta sessão.
                      final sessionToken = Uuid().v4();

                      final SugestaoEnderecoDmo? sugestao =
                      await showSearch<SugestaoEnderecoDmo?>(
                          context: context,
                          query: _enderecoController.text,
                          delegate: TelaBuscaEndereco(sessionToken));

                      // Alterar texto exibido no campo de texto
                      if (sugestao != null) {
                        final detalhesDoEndereco =
                        await GooglePlaceServiceProvider(sessionToken)
                            .obterDetalhesDoEndereco(
                            sugestao.idDoEndereco);

                        widget.store.setEndereco(detalhesDoEndereco);

                        _enderecoController.text =
                            detalhesDoEndereco.toString();
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Observer(
                        builder: (_){
                          if(widget.store.carregandoEndereco)
                            return CupertinoActivityIndicator();

                          return Icon(Icons.location_pin);
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                      isDense: true,
                      border: OutlineInputBorder(),
                      hintText: "Endereço",
                    ),
                    validator: (text) {
                      if (text!.isEmpty) return "Endereço obrigatório!";
                      return null;
                    }
                  ),
                  flex: 6,
                ),
                Flexible(
                  child: IconButton(
                      tooltip: "Usar localização atual",
                      color: Theme.of(context).primaryColor,
                      icon: Icon(Icons.my_location),
                      onPressed: () async {
                        widget.store.setCarregandoEndereco(true);

                        // Gerar novo Token para esta sessão.
                        final sessionToken = Uuid().v4();

                        //Obter localização atual do usuário
                        final localizacao =
                        await Preferencias().obterLocalizacaoAtual();

                        // Caso tenha retornado uma localização válida
                        try {
                          final detalhesDoEndereco =
                          await GooglePlaceServiceProvider(
                              sessionToken)
                              .obterDetalhesDoEnderecoViaPosition(
                              localizacao);

                          _enderecoController.text =
                              detalhesDoEndereco.toString();
                          widget.store.setEndereco(detalhesDoEndereco);
                        } catch (ex) {
                          // Exibir mensagem de erro em caso de falha.
                          Infraestrutura.mostrarMensagemDeErro(context, "Não foi possível obter o endereço via localização.");
                        }

                        widget.store.setCarregandoEndereco(false);
                      }),
                  flex: 1,
                )
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _complementoController,
              onChanged: widget.store.setComplemento,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.pin_drop_outlined),
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  isDense: true,
                  border: OutlineInputBorder(),
                  hintText: "Complemento"),
              validator: (text) {
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
          Observer(builder: (_){
            return ListViewItemPesquisa(
              textoPrincipal: "Grupo do Redeiro",
              textoSecundario: widget.store.textoGruposDoRecolhimento,
              iconeEsquerda: Icons.people_sharp,
              iconeDireita: Icons.arrow_forward_ios_sharp,
              acaoAoClicar: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TelaBuscaGruposDeRedeiros(
                          gruposJaSelecionados: widget.store.gruposDeRedeiros);
                    }).then((gruposSelecionados) {
                    if (gruposSelecionados != null)
                      widget.store.setGruposDeRedeiros(gruposSelecionados as List<GrupoDeRedeirosDmo>);

                });
              },
            );
          }),
            SizedBox(height: 20),
            Observer(
              builder: (_){
                return SizedBox(
                  height: 60,
                  child: ElevatedButton(
                      child: !widget.store.processando ?
                      Text(
                        widget.store.tipoDeManutencao ==
                            TipoDeManutencao.cadastro
                            ? "Cadastrar redeiro"
                            : "Editar redeiro",
                        style: TextStyle(fontSize: 20),
                      ) :
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              return Theme.of(context).primaryColor; // Use the component's default.
                            },
                          )
                      ),
                      onPressed: !widget.store.habilitaBotaoDeCadastro ? null : () async {
                        if (_formKey.currentState!.validate() &&
                            validarGruposDeRedeiros(context)) {

                          if(await widget.store.cadastrarOuEditarRedeiro() != null){
                            _finalizarCadastroDoRedeiro();
                          }
                          else{
                            _informarErroDeCadastro();
                          }
                        }
                      }),
                );
              }
            )
          ],
        ),
      ),
    );
  }

  /// É chamado após o cadastro do Redeiro ser efetuado com sucesso.
  void _finalizarCadastroDoRedeiro() {
    String mensagem = widget.store.tipoDeManutencao ==
            TipoDeManutencao.cadastro
        ? "Redeiro Cadastrado com sucesso!"
        : "Redeiro editado com sucesso!";
    Infraestrutura.mostrarMensagemDeSucesso(context, mensagem);
    Navigator.of(context).pop();
  }

  /// Informa usuário que ocorreu uma falha no login.
  void _informarErroDeCadastro() {
    String mensagem = widget.store.tipoDeManutencao  ==
            TipoDeManutencao.cadastro
        ? "Falha ao cadastrar redeiro!"
        : "Falha ao editar redeiro!";
    Infraestrutura.mostrarMensagemDeErro(context, mensagem);
  }

  bool validarGruposDeRedeiros(BuildContext context) {
    if (widget.store.gruposDeRedeiros.isNotEmpty) {
      return true;
    }

    Infraestrutura.mostrarMensagemDeErro(
        context, "Escolha pelo menos um grupo para o redeiro.");
    return false;
  }
}
